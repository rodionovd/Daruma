//
//  RectanglePulseLayer.m
//  Daruma
//
//  Created by Dmitry Rodionov on 27/04/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "BorderPulseLayer.h"

// Pulse properties
static CGFloat const kPulseDuration     = 0.4f;
static float   const kPulseRepeatCount  = 1.0f;
static CGFloat const kPulseInitialScale = 0.0f;
static CGFloat const kPulseFinalScale   = 1.0f;
static CGFloat const kPulseBorderWidthAdjustment = 0.1f;
static CGFloat const kPulseBorderColorAlpha = 1.0f;
// Animation timings
#define kOpacityAnimationKeyFrameTimings @[@0.0, @0.4, @1]
#define kOpacityAnimationKeyFrameValues  @[@0.6, @0.9, @0.6]

@implementation BorderPulseLayer

+ (instancetype)layerForBorder: (CALayer *)borderLayer
{
    BorderPulseLayer *layer = [[self class] layer];
    layer.frame = borderLayer.bounds;
    layer.borderColor  = CGColorCreateCopyWithAlpha(borderLayer.borderColor, kPulseBorderColorAlpha);
    layer.borderWidth  = borderLayer.borderWidth + kPulseBorderWidthAdjustment;
    layer.cornerRadius = borderLayer.cornerRadius;

    return layer;
}

- (void)pulse
{
    [self addAnimation: [self buildAnimationGroup] forKey: @"pulse"];
}

- (CAAnimationGroup *)buildAnimationGroup
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup new];
    animationGroup.duration    = kPulseDuration;
    animationGroup.repeatCount = kPulseRepeatCount;
    animationGroup.removedOnCompletion = YES;

    animationGroup.animations = @[({
        CABasicAnimation *scaleAnimation =
            [CABasicAnimation animationWithKeyPath: @"transform.scale.xy"];
        scaleAnimation.fromValue = @(kPulseInitialScale);
        scaleAnimation.toValue   = @(kPulseFinalScale);
        scaleAnimation.duration  = kPulseDuration;
        scaleAnimation;
    }), ({
        CAKeyframeAnimation *opacityAnimation =
            [CAKeyframeAnimation animationWithKeyPath: @"opacity"];
        opacityAnimation.duration = kPulseDuration;
        opacityAnimation.values   = kOpacityAnimationKeyFrameValues;
        opacityAnimation.keyTimes = kOpacityAnimationKeyFrameTimings;
        opacityAnimation;
    })];
    
    animationGroup.delegate = self;
    return animationGroup;
}

- (void)animationDidStop: (CAAnimation *)animation finished: (BOOL)flag
{
    [self removeFromSuperlayer];
}
@end

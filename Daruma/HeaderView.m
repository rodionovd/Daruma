//
//  HeaderView.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import CoreImage;
#import "HeaderView.h"

@interface HeaderView()
@end

@implementation HeaderView

+ (NSSize)genericSize
{
    return NSMakeSize(
        0  /* this width will be automatically adjusted by an enclosing collection view's layout */,
        34
    );
}

+ (NSArray <CIFilter *> *)defaultBackgroundFilters
{
    CIFilter *blur = [CIFilter filterWithName: @"CIGaussianBlur"];
    [blur setValue: @(3) forKey: @"inputRadius"];

    CIFilter *vintage_yellowish = [CIFilter filterWithName: @"CIPhotoEffectProcess"];
    return @[blur, vintage_yellowish];
}

- (void)setTitle: (NSString *)title
{
    NSTextField *textField = nil;
    for (NSView *view in self.subviews) {
        if ([view isKindOfClass: [NSTextField class]]) {
            textField = (NSTextField *)view;
        }
    }
    if (!textField) return;

    _title = [title copy];
    textField.stringValue = _title;
}

// Source: Apple's CocoaSlideCollection demo
- (void)drawRect: (NSRect)dirtyRect
{
    // Fill with semitransparent white.
    [[NSColor colorWithCalibratedWhite:0.95 alpha: .7] set];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);

    // Fill bottom and top edges with semitransparent gray.
    [[NSColor colorWithCalibratedWhite:0.75 alpha: .7] set];

    NSRect bottomEdgeRect = self.bounds;
    bottomEdgeRect.size.height = .5f;
    NSRectFillUsingOperation(bottomEdgeRect, NSCompositeSourceOver);

    NSRect topEdgeRect = bottomEdgeRect;
    topEdgeRect.origin.y = NSMaxY(self.bounds) - 1.0;
    NSRectFillUsingOperation(topEdgeRect, NSCompositeSourceOver);
}

#pragma mark - Background filters

- (void)awakeFromNib
{
    [self applyBackgroundFilters];
}

- (void)viewDidUnhide
{
    [self applyBackgroundFilters];
}

- (void)viewDidHide
{
    [self removeBackgroundFilters];
}

- (void)applyBackgroundFilters
{
    [self setLayerUsesCoreImageFilters: YES];
    self.layer.backgroundFilters = [[self class] defaultBackgroundFilters];
}

- (void)removeBackgroundFilters
{
    self.layer.backgroundFilters = @[];
}

@end

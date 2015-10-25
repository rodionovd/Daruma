//
//  FeelEmoticonView.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/14/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "FeelEmoticonView.h"

#define kSelectionBorderRadius (3.5)
#define kSelectionBorderWidth (1.0)
#define kSelectionCandidateBorderColor [NSColor selectedControlColor]
#define kSelectionBorderColor [NSColor colorWithCalibratedRed: 0.0 green: 0.5 blue: 1.0 alpha: .6]

@implementation FeelEmoticonView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame: frameRect])) {
        [self setWantsLayer: YES];
        _highlightState = NSCollectionViewItemHighlightNone;
    }
    return self;
}

#pragma mark - Custom setters

- (void)setHighlightState: (NSCollectionViewItemHighlightState)newHighlightState
{
    if (newHighlightState != _highlightState) {
        _highlightState = newHighlightState;
        [self setNeedsDisplay: YES]; // invokes -updateLayer
    }
}

- (void)setSelected: (BOOL)newSelected
{
    if (newSelected != _selected) {
        _selected = newSelected;
        [self setNeedsDisplay: YES]; // invokes -updateLayer
    }
}

- (BOOL)wantsUpdateLayer
{
    // We want to receive -updateLayer (see below)
    return YES;
}

- (void)updateLayer
{
    NSColor *borderColor = nil;
    if (_highlightState == NSCollectionViewItemHighlightForSelection) {
        borderColor = kSelectionCandidateBorderColor;
    } else if (_selected && _highlightState != NSCollectionViewItemHighlightForDeselection) {
        borderColor = kSelectionBorderColor;
    } else {
        borderColor = nil;
    }
    
    self.layer.borderColor = borderColor.CGColor ?: nil;
    self.layer.borderWidth = borderColor.CGColor ? kSelectionBorderWidth : 0.0;
    self.layer.cornerRadius = kSelectionBorderRadius;
}

@end

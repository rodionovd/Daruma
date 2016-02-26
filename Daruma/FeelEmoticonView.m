//
//  FeelEmoticonView.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/14/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

#import "FeelEmoticonView.h"
#import "EmoticonRenderer.h"

#define kSelectionBorderRadius (3.5)
#define kSelectionBorderWidth (1.0)
#define kSelectionCandidateBorderColor [NSColor selectedControlColor]
#define kSelectionBorderColor [NSColor colorWithCalibratedRed: 0.0 green: 0.5 blue: 1.0 alpha: .6]

@implementation FeelEmoticonView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame: frameRect])) {
        self.wantsLayer = YES;
        _highlightState = NSCollectionViewItemHighlightNone;
    }
    return self;
}

#pragma mark - Custom setters

- (void)setHighlightState: (NSCollectionViewItemHighlightState)newHighlightState
{
    if (newHighlightState != _highlightState) {
        _highlightState = newHighlightState;
    }
    [self.layer setNeedsDisplay];
}

- (void)setSelected: (BOOL)newSelected
{
    if (newSelected != _selected) {
        _selected = newSelected;
    }
    [self.layer setNeedsDisplay];
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect: (NSRect)dirtyRect
{
    [self lockFocus];
    [self.renderer drawEmoticonInRect: dirtyRect];
    [self unlockFocus];

    NSColor *borderColor = nil;
    if (self.highlightState == NSCollectionViewItemHighlightForSelection) {
        borderColor = kSelectionCandidateBorderColor;
    } else if (self.selected && self.highlightState != NSCollectionViewItemHighlightForDeselection) {
        borderColor = kSelectionBorderColor;
    } else {
        borderColor = nil;
    }
    
    self.layer.borderColor = borderColor.CGColor ?: nil;
    self.layer.borderWidth = borderColor.CGColor ? kSelectionBorderWidth : 0.0;
    self.layer.cornerRadius = kSelectionBorderRadius;
}

@end

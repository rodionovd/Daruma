//
//  FeelEmoticonView.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/14/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import QuartzCore;
#import "FeelEmoticonView.h"
#import "EmoticonRenderer.h"
#import "BorderPulseLayer.h"

#define kSelectionBorderRadius (3.5)
#define kSelectionBorderWidth (1.0)
#define kSelectionCandidateBorderColor [NSColor selectedControlColor]
#define kSelectionBorderColor [NSColor colorWithCalibratedRed: 0.0 green: 0.5 blue: 1.0 alpha: .6]

@implementation FeelEmoticonView

- (instancetype)initWithFrame: (NSRect)frameRect
{
    if ((self = [super initWithFrame: frameRect])) {
        self.wantsLayer = YES;
        _highlightState = NSCollectionViewItemHighlightNone;
        _actionsQueue = dispatch_queue_create("double-click-actions-queue",
                                              DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Double click: animation + handler

- (void)mouseDown: (NSEvent *)theEvent
{
    [super mouseDown: theEvent];
    if (theEvent.clickCount != 2) {
        return;
    }
    // Indicate that we've doing something on double click
    BorderPulseLayer *pulseLayer = [BorderPulseLayer layerForBorder: self.layer];
    [self.layer addSublayer: pulseLayer];
    [pulseLayer pulse];
    // Call a handler if any
    dispatch_async(_actionsQueue, ^{
        if (self.doubleClickAction) self.doubleClickAction();
    });
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
    // Draw an emoticon
    [self lockFocus];
    [self.renderer drawEmoticonInRect: dirtyRect];
    [self unlockFocus];

    // Draw a border around the cell if needed
    NSColor *borderColor = [self currentBorderColor];
    self.layer.borderColor = borderColor.CGColor ?: nil;
    self.layer.borderWidth = borderColor.CGColor ? kSelectionBorderWidth : 0.0;
    self.layer.cornerRadius = kSelectionBorderRadius;
}

- (NSColor *)currentBorderColor
{
    if (self.highlightState == NSCollectionViewItemHighlightForSelection) {
        return kSelectionCandidateBorderColor;
    }
    if (self.selected && self.highlightState != NSCollectionViewItemHighlightForDeselection) {
        return kSelectionBorderColor;
    }

    return nil;
}

@end

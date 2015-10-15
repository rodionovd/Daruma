//
//  FeelEmoticonView.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/14/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "FeelEmoticonView.h"

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
        // invokes -updateLayer
        [self setNeedsDisplay: YES];
    }
}

- (void)setSelected: (BOOL)newSelected
{
    if (newSelected != _selected) {
        _selected = newSelected;
        // invokes -updateLayer
        [self setNeedsDisplay: YES];
    }
}

- (BOOL)wantsUpdateLayer
{
    // We want to receive -updateLayer since we gonna set our backing layer's properties to reflect changes to the state instead of drawing stuff in -drawRect:
    return YES;
}

- (void)updateLayer
{
    // FIXME: I smell some dirty code out here
    
    NSColor *borderColor = nil;
    if (_highlightState == NSCollectionViewItemHighlightForSelection) {
        // Item is a candidate to become selected: Show an orange border around it.
        // NOTE: tap
        borderColor = [NSColor selectedControlColor];
    } else if (_selected && _highlightState != NSCollectionViewItemHighlightForDeselection) {
        // Item is selected, and is not indicated for proposed deselection: Show an Aqua border around it.
        // NOTE: click
        borderColor = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:1.0]; // Aqua
    } else {
        // Item is either not selected, or is selected but not highlighted for deselection:
        // show no border around it.
        borderColor = nil;
    }
    
    // FIXME: Don't draw a border, but change the text field font color instead!
    
    self.layer.borderColor = borderColor.CGColor ?: [NSColor clearColor].CGColor;
    self.layer.borderWidth = borderColor.CGColor ? 1.0 : 0.0;
    self.layer.cornerRadius = 3.0;
}

@end

//
//  FeelViewItem.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

#import "FeelViewItem.h"
#import "FeelEmoticonView.h"

@interface FeelViewItem ()
@end

@implementation FeelViewItem

#pragma mark - Mouse Events

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown: theEvent];

    NSEventModifierFlags unwantedMask = (NSShiftKeyMask | NSControlKeyMask | NSCommandKeyMask);

    if (theEvent.clickCount == 1 && (theEvent.modifierFlags & unwantedMask) == 0) {
        // :deselect all other cells if needed
        NSIndexPath *currentPath = [self.collectionView indexPathForItem: self];
        if (self.collectionView.selectionIndexPaths.count > 1) {
            self.collectionView.selectionIndexPaths = [NSSet setWithObject: currentPath];
        }
    }
}

#pragma mark Selection and Highlighting

- (void)setHighlightState: (NSCollectionViewItemHighlightState)newHighlightState
{
    super.highlightState = newHighlightState;
    ((FeelEmoticonView *)self.view).highlightState = newHighlightState;
}

- (void)setSelected:(BOOL)selected
{
    super.selected = selected;
    ((FeelEmoticonView *)self.view).selected = selected;
}

@end

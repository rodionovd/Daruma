//
//  RespondableCollectionView.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/21/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "ResponsiveCollectionView.h"

@implementation ResponsiveCollectionView

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

- (BOOL)resignFirstResponder
{
    return YES;
}

// Select the first item of the first section on DOWN key if selection is empty
- (void)moveDown: (id)sender
{
    [super moveDown: sender];
    [self selectFirstItemAndScrollIfNeeded];
}

- (BOOL)selectFirstItemAndScrollIfNeeded
{
    if (self.selectionIndexPaths.count != 0) {
        return NO; // selection is not empty, so aborting
    }
    if ([self indexPathsForVisibleItems].count == 0) {
        return NO; // have nothing to show and thus select
    }

    NSSet *firstItem = [NSSet setWithObject: [NSIndexPath indexPathForItem: 0 inSection: 0]];

    NSCollectionViewScrollPosition scrollPosition = NSCollectionViewScrollPositionCenteredVertically;
    if ([[self indexPathsForVisibleItems] intersectsSet: firstItem]) {
        // don't scroll if the item is already onscreen
        scrollPosition = NSCollectionViewScrollPositionNone;
    }

    [self selectItemsAtIndexPaths: firstItem scrollPosition: scrollPosition];
    return YES;
}

@end

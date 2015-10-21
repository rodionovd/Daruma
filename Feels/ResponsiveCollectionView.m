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

    if (self.selectionIndexPaths.count != 0) {
        return; // selection is not empty, aborting
    }
    if (self.indexPathsForVisibleItems.count == 0) {
        return; // have nothing to show and select
    }

    NSSet *firstItem = [NSSet setWithObject: [NSIndexPath indexPathForItem: 0 inSection: 0]];

    NSCollectionViewScrollPosition scrollPosition = NSCollectionViewScrollPositionCenteredVertically;
    if ([self.indexPathsForVisibleItems intersectsSet: firstItem]) {
        // don't scroll if the item is already onscreen
        scrollPosition = NSCollectionViewScrollPositionNone;
    }

    [self selectItemsAtIndexPaths: firstItem scrollPosition: scrollPosition];
}

@end

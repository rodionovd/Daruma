//
//  WrappedLayout.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "CollectionViewBrowserLayout.h"

@implementation CollectionViewBrowserLayout

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self setItemSize:NSMakeSize(SLIDE_WIDTH, SLIDE_HEIGHT)];
        [self setMinimumInteritemSpacing: 5];
        [self setMinimumLineSpacing: 5];
        [self setSectionInset: NSEdgeInsetsMake(10, 10, 10, 10)];
    }
    return self;
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSCollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [attributes setZIndex:[indexPath item]];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(NSRect)rect {
    NSArray *layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    for (NSCollectionViewLayoutAttributes *attributes in layoutAttributesArray) {
        [attributes setZIndex:[[attributes indexPath] item]];
    }
    return layoutAttributesArray;
}


@end

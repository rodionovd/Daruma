//
//  WrappedLayout.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "CollectionViewBrowserLayout.h"

#define kMinimumInteritemSpacing (3)
#define kMinimumLineSpacing (3)
#define kSectionInset NSEdgeInsetsMake(10, 10, 10, 10)

@implementation CollectionViewBrowserLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setMinimumInteritemSpacing: kMinimumInteritemSpacing];
        [self setMinimumLineSpacing: kMinimumLineSpacing];
        [self setSectionInset: kSectionInset];
    }
    return self;
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath: (NSIndexPath *)indexPath
{
    NSCollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath: indexPath];
    [attributes setZIndex: [indexPath item]];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect: (NSRect)rect
{
    NSArray *layoutAttributesArray = [super layoutAttributesForElementsInRect: rect];
    for (NSCollectionViewLayoutAttributes *attributes in layoutAttributesArray) {
        [attributes setZIndex: [[attributes indexPath] item]];
    }
    return layoutAttributesArray;
}


@end

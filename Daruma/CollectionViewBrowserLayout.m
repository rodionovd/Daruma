//
//  WrappedLayout.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "CollectionViewBrowserLayout.h"
#import "NSArray+Stuff.h"

#define kMinimumInteritemSpacing (20)
#define kMinimumLineSpacing (20)
#define kSectionInset NSEdgeInsetsMake(10, 10, 10, 10)

@implementation CollectionViewBrowserLayout

- (instancetype)init
{
    if ((self = [super init])) {
        self.minimumInteritemSpacing = kMinimumInteritemSpacing;
        self.minimumLineSpacing = kMinimumLineSpacing;
        self.sectionInset = kSectionInset;
    }
    return self;
}

#pragma mark - Adjust layout when there's new scroller style

- (void)invalidateLayoutUponNotification: (NSNotification *)notification
{
    [self invalidateLayout];
}

#pragma mark - Sticky Headers

- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect)newBounds
{
    return YES;
}

// The code below is adopted from PDKTStickySectionHeadersCollectionViewLayout by Produkt
// https://github.com/Produkt/PDKTStickySectionHeadersCollectionViewLayout
// PDKTStickySectionHeadersCollectionViewLayout.m
// Kudos to them 👍🏼!
- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect: (NSRect)rect
{
    // 0) fetch the base attributes for everything but headers
    NSArray *attributes = [[super layoutAttributesForElementsInRect: rect] rd_filter: ^BOOL(NSCollectionViewLayoutAttributes *item) {
        return ![item.representedElementKind isEqualToString: NSCollectionElementKindSectionHeader];
    }];
    CGPoint const contentOffset = self.collectionView.visibleRect.origin;
    // 1) figure out what's on screen now
    NSArray *headersAttribites = [[[[attributes rd_map: ^NSNumber *(NSCollectionViewLayoutAttributes *item) {
        return @(item.indexPath.section);
    // 2) for each visible section request its header's layout attributes for further adjusting
    }] rd_distinct] rd_map: ^id(NSNumber *section) {
        NSIndexPath *sectionTop = [NSIndexPath indexPathForItem: 0 inSection: [section integerValue]];
        return [self layoutAttributesForSupplementaryViewOfKind: NSCollectionElementKindSectionHeader
                                                    atIndexPath: sectionTop];
    // 3) transform each header's frame so they look "sticky" to the top
    }] rd_map: ^id(NSCollectionViewLayoutAttributes *item) {
        return [self transformHeaderFrameWithLayoutAttributes: item contentOffset: contentOffset];
    }];

    return [attributes arrayByAddingObjectsFromArray: headersAttribites];
}

// We set Z-index of all headers to NSIntegerMax so they appear "above" other items
- (NSCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind: (NSString *)elementKind
                                                                     atIndexPath: (NSIndexPath *)indexPath
{
    NSCollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind: elementKind
                                                                                         atIndexPath: indexPath];
    if ([elementKind isEqualToString: NSCollectionElementKindSectionHeader]) {
        attributes.zIndex = NSIntegerMax;
    }
    return attributes;
}

// Here's the actual code for moving headers around
- (NSCollectionViewLayoutAttributes *)transformHeaderFrameWithLayoutAttributes: (NSCollectionViewLayoutAttributes *)attributes
                                                                 contentOffset: (CGPoint)contentOffset
{
    CGPoint originInCollectionView = CGPointMake(attributes.frame.origin.x - contentOffset.x,
                                                 attributes.frame.origin.y - contentOffset.y);
    CGRect frame = attributes.frame;
    // 1) The current section's header must be visible, so it appears "fixed" to the top.
    if (originInCollectionView.y < 0) {
        frame.origin.y += (originInCollectionView.y * (-1));
    }
    // 2) If there're sections after that one ...
    if (attributes.indexPath.section < [self.collectionView numberOfSections]-1) {
        NSInteger nextSection = attributes.indexPath.section + 1;
        NSIndexPath *nextHeaderIndexPath = [NSIndexPath indexPathForItem: 0 inSection: nextSection];
        NSCollectionViewLayoutAttributes *nextHeaderAttributes =
            [self layoutAttributesForSupplementaryViewOfKind: NSCollectionElementKindSectionHeader
                                                 atIndexPath: nextHeaderIndexPath];
        // 3) if these two headers are collapsing we move them together as a single item: the top Y
        // of the new header must be equal to the buttom Y of the old one (so it looks like the former
        // is pushing the latter out)
        CGFloat maxY = nextHeaderAttributes.frame.origin.y;
        if (CGRectGetMaxY(frame) >= maxY) {
            frame.origin.y = maxY - frame.size.height;
        }
    }

    NSCollectionViewLayoutAttributes *adjustedAttributes = [attributes copy];
    adjustedAttributes.frame = frame;

    return adjustedAttributes;
}

@end

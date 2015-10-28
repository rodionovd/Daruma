//
//  BrowserCoordinator.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "BrowserCoordinator.h"
#import "BrowserWindowController.h"
#import "DataLense.h"
#import "Feel.h"
#import "HeaderView.h"
#import "NSString+EmoticonSize.h"
#import "EmoticonValueTransformer.h"
#import "EmoticonRenderer.h"
#import "FeelEmoticonView.h"

@interface BrowserCoordinator() <BrowserCoordinatorProtocol>
@property (strong) DataLense *dataLense;
@property (strong, nullable) BrowserWindowController *browserWindowController;
@property (strong) NSCache *itemSizesCache;
@property (strong) NSCache *paintersCache;
@end

@implementation BrowserCoordinator

- (instancetype)initWithFeelsContainerURL: (NSURL *)containerURL
{
    if ((self = [super init])) {
        self.dataLense = [[DataLense alloc] initWithContentsOfURL: containerURL];

        [self.dataLense addObserver: self
                         forKeyPath: @"view"
                            options: NSKeyValueObservingOptionOld
                            context: NULL];

        self.itemSizesCache = [NSCache new];
        self.paintersCache = [NSCache new];
    }
    return self;
}

- (void)start
{
    self.browserWindowController = [BrowserWindowController new];
    self.browserWindowController.coordinator = self;
    [self.browserWindowController showWindow: self];
}

#pragma mark - KVO

- (void)observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id)object
                        change: (NSDictionary<NSString *,id> *)change
                       context: (void *)context
{
    if (object == self.dataLense && [keyPath isEqualToString: @"view"]) {
        [self.browserWindowController reloadCollectionView: self];
    }
}

#pragma mark - BrowserCoordinator protocol

- (void)writeItemsToPasteboard: (NSSet <NSIndexPath *> *)indexPaths
{
    NSString *contents = [self.dataLense contentsForItemsAtIndexPaths: indexPaths];
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] writeObjects: @[contents]];
}

- (void)searchFieldDidReportPredicate: (NSString *)newPredicate
{
    self.dataLense.predicate = newPredicate;
}

- (void)searchFieldDidCompleteSearch: (NSSearchField *)searchField
{
    self.dataLense.predicate = nil;
}

#pragma mark - NSCollectionViewDelegate's

// Enable drag’n’drop
- (BOOL)collectionView: (NSCollectionView *)collectionView
writeItemsAtIndexPaths: (NSSet<NSIndexPath *> *)indexPaths
          toPasteboard: (NSPasteboard *)pasteboard
{
    [pasteboard declareTypes: @[NSStringPboardType] owner: nil];
    [pasteboard setString: [self.dataLense contentsForItemsAtIndexPaths: indexPaths]
                  forType: NSStringPboardType];
    return YES;
}

#pragma mark - NSCollectionViewDataSource's

- (NSInteger)numberOfSectionsInCollectionView: (NSCollectionView *)collectionView
{
    return self.dataLense.view.count;
}

- (NSInteger)collectionView: (NSCollectionView *)collectionView numberOfItemsInSection: (NSInteger)idx
{
    return self.dataLense.view[idx].items.count;
}

- (NSCollectionViewItem *)collectionView: (NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath: (NSIndexPath *)indexPath
{
    NSCollectionViewItem *item = [collectionView makeItemWithIdentifier: @"FeelEmoticon"
                                                           forIndexPath: indexPath];

    Feel *modelObject = [self.dataLense objectAtIndexPath: indexPath];

    EmoticonRenderer *painter = [self.paintersCache objectForKey: modelObject];
    if (painter == nil) {
        NSString *emoticon = [[EmoticonValueTransformer new] transformedValue: modelObject.emoticon];
        painter = [EmoticonRenderer rendererForEmoticon: emoticon];
        [self.paintersCache setObject: painter forKey: modelObject];
    }
    [(FeelEmoticonView *)item.view setRenderer: painter];
    return item;
}

- (nonnull NSView *)collectionView: (nonnull NSCollectionView *)collectionView viewForSupplementaryElementOfKind: (nonnull NSString *)kind atIndexPath: (nonnull NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    if ([kind isEqualToString: NSCollectionElementKindSectionHeader]) {
        identifier = NSStringFromClass([HeaderView class]);
    } else if ([kind isEqualToString: NSCollectionElementKindSectionFooter]) {
        // don't want a footer view (yet?)
    }

    // NOTE: a collection view will also ask us about a supplementary view for the selection rectangle,
    // but we just want to use the default (system) style selection, so leave it right now.
    if (!identifier) {
        return nil;
    }
    
    NSView *view = [collectionView makeSupplementaryViewOfKind: kind
                                                withIdentifier: identifier
                                                  forIndexPath: indexPath];
    if ([kind isEqual: NSCollectionElementKindSectionHeader] && [view isKindOfClass: HeaderView.class]) {
        [(HeaderView *)view setTitle: self.dataLense.view[indexPath.section].title];
    }
    return view;
}

- (NSSize)collectionView: (NSCollectionView *)collectionView
                  layout: (NSCollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection: (NSInteger)section
{
    return [HeaderView genericSize];
}


#pragma mark - NSCollectionViewDelegateFlowLayout

- (NSSize)collectionView: (NSCollectionView *)collectionView
                  layout: (NSCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath: (NSIndexPath *)indexPath
{
    Feel *modelObject = [self.dataLense objectAtIndexPath: indexPath];
    NSString *emoticon = [[EmoticonValueTransformer new] transformedValue: modelObject.emoticon];

    // Have we already calculated a size for this emoticon?
    NSValue *sizeWrapper = [self.itemSizesCache objectForKey: modelObject];
    NSSize proposedSize = NSZeroSize;
    if (sizeWrapper != nil) {
        proposedSize = [sizeWrapper sizeValue];
    } else {
        // Otherwise do the math!
        proposedSize = [emoticon rd_emoticonSize];
        // and cache the results
        [self.itemSizesCache setObject: [NSValue valueWithSize: proposedSize]
                                forKey: modelObject];
    }
    // Sanitize an item's width in the flow layout mode
    if ([collectionViewLayout isKindOfClass: NSCollectionViewFlowLayout.class]) {
        NSCollectionViewFlowLayout *flowLayout = (NSCollectionViewFlowLayout *)collectionViewLayout;
        NSEdgeInsets insets = flowLayout.sectionInset;
        CGFloat collectionViewMinWidth = collectionView.window.minSize.width;

        // Assume NSScrollerStyleOverlay by default so scrollers don't take any additional place
        CGFloat scrollerWidth = 0.0f;
        if ([NSScroller preferredScrollerStyle] == NSScrollerStyleLegacy) {
            scrollerWidth = [NSScroller scrollerWidthForControlSize: NSRegularControlSize
                                                      scrollerStyle: [NSScroller preferredScrollerStyle]];
        }
        CGFloat maxAllowedWidth = collectionViewMinWidth - scrollerWidth - (insets.left + insets.right);
        proposedSize.width = (proposedSize.width > maxAllowedWidth) ? maxAllowedWidth : proposedSize.width;
    }

    return proposedSize;
}

@end

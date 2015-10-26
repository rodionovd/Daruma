//
//  BrowserCoordinator.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "BrowserCoordinator.h"
#import "BrowserWindowController.h"
#import "Feel.h"
#import "DataLense.h"
#import "HeaderView.h"
#import "NSString+EmoticonSize.h"
#import "EmoticonValueTransformer.h"

@interface BrowserCoordinator() <BrowserCoordinatorProtocol>
@property (strong) DataLense *dataLense;
@property (strong, nullable) BrowserWindowController *browserWindowController;
@property (strong) NSCache *itemSizesCache;
@end

@implementation BrowserCoordinator

- (instancetype)initWithFeelsContainerURL: (NSURL *)containerURL
{
    if ((self = [super init])) {
        self.dataLense = [[DataLense alloc] initWithContentsOfURL: containerURL];

        [self.dataLense addObserver: self
                         forKeyPath: @"sections"
                            options: NSKeyValueObservingOptionOld
                            context: NULL];

        self.itemSizesCache = [NSCache new];
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
    if (object == self.dataLense && [keyPath isEqualToString: @"sections"]) {
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
    return self.dataLense.sections.count;
}

- (NSInteger)collectionView: (NSCollectionView *)collectionView numberOfItemsInSection: (NSInteger)idx
{
    return self.dataLense.sections[idx].items.count;
}

- (NSCollectionViewItem *)collectionView: (NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath: (NSIndexPath *)indexPath
{
    NSCollectionViewItem *item = [collectionView makeItemWithIdentifier: @"FeelEmoticon"
                                                           forIndexPath: indexPath];
    // see FeelEmoticon.xib for bindings
    item.representedObject = [self.dataLense objectAtIndexPath: indexPath];
    return item;
}

- (nonnull NSView *)collectionView: (nonnull NSCollectionView *)collectionView viewForSupplementaryElementOfKind: (nonnull NSString *)kind atIndexPath: (nonnull NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    if ([kind isEqualToString: NSCollectionElementKindSectionHeader]) {
        identifier = @"HeaderView";
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
        [(HeaderView *)view setTitle: self.dataLense.sections[indexPath.section].title];
    }
    return view;
}

- (NSSize)collectionView: (NSCollectionView *)collectionView layout: (NSCollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection: (NSInteger)section
{
    return [HeaderView baseSize];
}


#pragma mark - NSCollectionViewDelegateFlowLayout

- (NSSize)collectionView: (NSCollectionView *)collectionView
                  layout: (NSCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath: (NSIndexPath *)indexPath
{
    NSString *emoticon = [[EmoticonValueTransformer new] transformedValue:
                          [self.dataLense objectAtIndexPath: indexPath].emoticon];
    NSSize proposedSize = NSZeroSize;

    // Have we already calculated a size for this emoticon?
    NSValue *sizeWrapper = [self.itemSizesCache objectForKey: emoticon];
    if (sizeWrapper != nil) {
        proposedSize = [sizeWrapper sizeValue];
    } else {
        // Otherwise do the math!
        proposedSize = [emoticon rd_emoticonSize];
        // and cache the results
        [self.itemSizesCache setObject: [NSValue valueWithSize: proposedSize]
                                forKey: emoticon];
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

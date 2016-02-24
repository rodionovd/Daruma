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
#import "EmoticonValueTransformer.h"
#import "EmoticonRenderer.h"
#import "FeelEmoticonView.h"
#import "NSArray+Stuff.h"

@interface BrowserCoordinator() <BrowserCoordinatorProtocol>
@property (strong) DataLense *dataLense;
@property (strong, nullable) BrowserWindowController *browserWindowController;
@property (strong) NSCache *paintersCache;
@end

@implementation BrowserCoordinator

- (instancetype)initWithFeelsContainerURL: (NSURL *)containerURL
{
    if ((self = [super init])) {
        _dataLense = [[DataLense alloc] initWithContentsOfURL: containerURL];
        [_dataLense addObserver: self
                         forKeyPath: [DataLense observableContentsKey]
                            options: NSKeyValueObservingOptionOld
                            context: NULL];
        _paintersCache = [NSCache new];
    }
    return self;
}

- (void)start
{
    self.browserWindowController = [BrowserWindowController new];
    self.browserWindowController.coordinator = self;
    // Load placeholders :: all sections' keywords
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *placeholders = [[self.dataLense.view rd_flatMap: ^NSArray *(Section *section) {
            return [section.keywords.allObjects arrayByAddingObject: section.title.lowercaseString];
        }] rd_filter: ^BOOL(NSString *placeholder) {
            return placeholder.length > 1;
        }];
        [self.browserWindowController usePlaceholders: placeholders];
    });
    [self.browserWindowController showWindow: self];
}

#pragma mark - KVO

- (void)observeValueForKeyPath: (NSString *)keyPath
                      ofObject: (id)object
                        change: (NSDictionary<NSString *,id> *)change
                       context: (void *)context
{
    if (object == self.dataLense && [keyPath isEqualToString: [DataLense observableContentsKey]]) {
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

- (void)setupSearchFieldBindings: (nonnull NSSearchField *)searchField
{
    NSDictionary *bindingOptions = @{NSContinuouslyUpdatesValueBindingOption : @YES};
    [searchField bind: NSValueBinding
             toObject: self.dataLense
          withKeyPath: [DataLense observablePredicateKey]
              options: bindingOptions];
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
    return (NSInteger)self.dataLense.view.count;
}

- (NSInteger)collectionView: (NSCollectionView *)collectionView numberOfItemsInSection: (NSInteger)idx
{
    return (NSInteger)self.dataLense.view[(NSUInteger)idx].items.count;
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
    ((FeelEmoticonView *)item.view).renderer = painter;
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
    if ([kind isEqual: NSCollectionElementKindSectionHeader] && [view isKindOfClass: [HeaderView class]]) {
        ((HeaderView *)view).title = self.dataLense.view[(NSUInteger)indexPath.section].title;
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

    EmoticonRenderer *painter = [self.paintersCache objectForKey: modelObject];
    if (painter == nil) {
        painter = [EmoticonRenderer rendererForEmoticon: emoticon];
        [self.paintersCache setObject: painter forKey: modelObject];
    }
    NSSize proposedSize = [painter calculateEmoticonSize];
    // Sanitize an item's width in the flow layout mode
    if ([collectionViewLayout isKindOfClass: [NSCollectionViewFlowLayout class]]) {
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
        proposedSize.width = MIN(proposedSize.width, maxAllowedWidth);
    }

    return proposedSize;
}

@end

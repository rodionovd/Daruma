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
#import "FeelViewItem.h"
#import "EmoticonValueTransformer.h"

@interface BrowserCoordinator() <BrowserCoordinatorProtocol>
@property (strong) DataLense *dataLense;
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

- (void)searchField: (NSSearchField *)searchField didReportPredicate: (NSString *)newPredicate
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
// Emoticons are huge, so we have to deal with it
#define kEmoticonFontSizeMultiplier (1.15)
#define kItemSizeHeightMultiplier (1.3)

    NSString *emoticon = [[EmoticonValueTransformer new] transformedValue:
                          [self.dataLense objectAtIndexPath: indexPath].emoticon];

    NSFont *emoticonFont = [FeelViewItem emoticonFont];
    NSDictionary *fontAttributes = @{
         NSFontAttributeName: [NSFont fontWithName: emoticonFont.fontName
                                              // Make more room for huge emoticons
                                              size: emoticonFont.pointSize * kEmoticonFontSizeMultiplier]
    };
    NSStringDrawingOptions drawingOptions =
        NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics;
    NSSize proposedSize = [emoticon boundingRectWithSize: NSZeroSize
                                                 options: drawingOptions
                                              attributes: fontAttributes].size;

    // Round up since we don't neeed all the precision CGFloat has
    // (it actually causes items popping, so just remove everything after the decimal point/comma)
    proposedSize.width = ceil(proposedSize.width);
    proposedSize.height = ceil(proposedSize.height);

    // Sanitize an item's width in flow layout mode
    if ([collectionViewLayout isKindOfClass: NSCollectionViewFlowLayout.class]) {
        NSCollectionViewFlowLayout *flowLayout = (NSCollectionViewFlowLayout *)collectionViewLayout;
        NSEdgeInsets insets = flowLayout.sectionInset;

        // TODO: we don't need this if srollers aren't visible (aka overlay)
        CGFloat scrollerWidth = [NSScroller scrollerWidthForControlSize: NSRegularControlSize
                                                          scrollerStyle: [NSScroller preferredScrollerStyle]];

        CGFloat maxAllowedWidth = collectionView.window.minSize.width - scrollerWidth - (insets.left + insets.right);
        proposedSize.width = (proposedSize.width > maxAllowedWidth) ? maxAllowedWidth : proposedSize.width;
    }
    // Sanitize an item's height: it should be a bit taller than the default coz emoticons
    // tend to grow up and down the baseline
    proposedSize.height *= kItemSizeHeightMultiplier;

    return proposedSize;
}

@end
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
#import "FeelContainer.h"
#import "Functional.h"

@interface BrowserCoordinator()
@property (strong) FeelContainer *feelsContainer;
@end

@implementation BrowserCoordinator

- (instancetype)initWithFeelsContainerURL: (NSURL *)containerURL
{
    if ((self = [super init])) {
        // TODO: create a DataSource object
        _feelsContainer = [[FeelContainer alloc] initWithURL: containerURL];
    }
    return self;
}

- (void)start
{
    self.browserWindowController = [BrowserWindowController new];
    self.browserWindowController.coordinator = self;
    [self.browserWindowController showWindow: self];
}

#pragma mark Pasteboard actions

#warning TODO: refactor all this stuff into a separate pasteboard manager class

- (NSString *)mergedContentsForItemsAtIndexPaths: (NSSet <NSIndexPath *> *)indexPaths
{
    NSArray *sortedByItemIndex = [indexPaths.allObjects sortedArrayUsingSelector: @selector(compare:)];
    NSArray *emoticons = [sortedByItemIndex rd_map: ^NSString *_Nonnull(NSIndexPath *_Nonnull path) {
        return [[self.feelsContainer objectAtIndexPath: path] emoticon];
    }];
    NSString *single_whitespace = @" ";
    return [emoticons componentsJoinedByString: single_whitespace];
}

// browserWindowController calls this from its copy: method
- (void)writeToPasteboardItemsAtIndexPaths: (NSSet <NSIndexPath *> *)indexPaths
{
    NSString *contents = [self mergedContentsForItemsAtIndexPaths: indexPaths];
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] writeObjects: @[contents]];
}
// NSCollectionView will call us about this (because we're the delegate)
- (BOOL)collectionView: (NSCollectionView *)collectionView
writeItemsAtIndexPaths: (NSSet<NSIndexPath *> *)indexPaths
          toPasteboard: (NSPasteboard *)pasteboard
{
    [pasteboard declareTypes: @[NSStringPboardType] owner: nil];
    [pasteboard setString: [self mergedContentsForItemsAtIndexPaths: indexPaths]
                  forType: NSStringPboardType];
    return YES;
}

#pragma mark - NSCollectionViewDataSource's

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView
{
    // TODO: we don't have any sections *yet*
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // TODO: we don't have any sections *yet*
    return self.feelsContainer.count;
}

- (NSCollectionViewItem *)collectionView: (NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath: (NSIndexPath *)indexPath
{
    NSCollectionViewItem *item = [collectionView makeItemWithIdentifier: @"FeelEmoticon"
                                                           forIndexPath: indexPath];
    item.representedObject = [self.feelsContainer objectAtIndexPath: indexPath];
    return item;
}

#pragma mark - NSCollectionViewDelegateFlowLayout

- (NSSize)collectionView: (NSCollectionView *)collectionView
                  layout: (NSCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath: (NSIndexPath *)indexPath
{
    NSString *emoticon = [self.feelsContainer objectAtIndexPath: indexPath].emoticon;
    // FIXME: why hardcoded font size?
    NSSize f = [emoticon sizeWithAttributes: @{NSFontAttributeName: [NSFont systemFontOfSize: 23]}];
    
    // TODO: sanitize the width: is must be less than the width of the collection view plus left and right section insets:
    // [(NSCollectionViewFlowLayout *)collectionView.collectionViewLayout sectionInset].left
    // [(NSCollectionViewFlowLayout *)collectionView.collectionViewLayout sectionInset].right
    
    // FIXME: why 1.5?
    f.height *= 1.5;
    return f;
}

@end

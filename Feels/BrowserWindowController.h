//
//  BrowserWindowController.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;


@protocol BrowserCoordinatorProtocol <NSCollectionViewDataSource, NSCollectionViewDelegate>

- (void)writeToPasteboardItemsAtIndexPaths: (nonnull NSSet <NSIndexPath *> *)indexPaths;

- (void)searchField: (nonnull NSSearchField *)searchField didReportPredicate: (nonnull NSString *)newPredicate;
- (void)searchFieldDidCompleteSearch: (nonnull NSSearchField *)searchField;

@end

@interface BrowserWindowController : NSWindowController <NSSearchFieldDelegate>
// UI
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSCollectionView *collectionView;
// Delegation
@property (weak) id <BrowserCoordinatorProtocol> coordinator;

- (nonnull instancetype)init;

- (IBAction)copy: (nullable id)sender;

@end

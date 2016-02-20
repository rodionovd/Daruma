//
//  BrowserWindowController.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;


@protocol BrowserCoordinatorProtocol <NSCollectionViewDataSource, NSCollectionViewDelegate>

@required
- (void)writeItemsToPasteboard: (nonnull NSSet <NSIndexPath *> *)indexPaths;
- (void)setupSearchFieldBindings: (nonnull NSSearchField *)searchField;

@end

@interface BrowserWindowController : NSWindowController <NSSearchFieldDelegate>
// UI
@property (weak, nullable) IBOutlet NSSearchField *searchField;
@property (weak, nullable) IBOutlet NSCollectionView *collectionView;
// Delegation
@property (weak, nullable) id <BrowserCoordinatorProtocol> coordinator;

- (nonnull instancetype)init;

- (IBAction)copy: (nullable id)sender;
- (void)reloadCollectionView: (nullable id)sender;

@end

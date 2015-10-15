//
//  BrowserWindowController.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface BrowserWindowController : NSWindowController
// UI
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSCollectionView *collectionView;
// Delegation
@property (weak) id coordinator;

- (nonnull instancetype)init;

- (IBAction)copy: (nullable id)sender;

@end

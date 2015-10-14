//
//  BrowserCoordinator.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;

@class BrowserWindowController;

@interface BrowserCoordinator : NSObject
<NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout>

@property (strong, nullable) BrowserWindowController *browserWindowController;

- (nullable instancetype)initWithFeelsContainerURL: (nonnull NSURL *)containerURL;
- (void)start;
@end

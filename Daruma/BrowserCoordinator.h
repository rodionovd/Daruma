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

- (nullable instancetype)initWithFeelsContainerURL: (nonnull NSURL *)containerURL;
- (void)start;
@end

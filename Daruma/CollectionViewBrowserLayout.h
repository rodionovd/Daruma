//
//  WrappedLayout.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface CollectionViewBrowserLayout : NSCollectionViewFlowLayout

- (void)invalidateLayoutUponNotification: (NSNotification *)notification;

@end

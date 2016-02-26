//
//  RespondableCollectionView.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/21/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResponsiveCollectionView : NSCollectionView

- (BOOL)selectFirstItemAndScrollIfNeeded;

@end

//
//  FeelsContainer.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Foundation;

@class Feel;

@interface FeelContainer : NSObject

- (nullable instancetype)initWithURL: (nonnull NSURL *)containerURL;
// Accessors
- (NSInteger)count;
- (nullable Feel *)objectAtIndexPath: (nonnull NSIndexPath *)indexPath;
@end

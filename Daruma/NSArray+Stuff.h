//
//  NSSet+Functional.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface NSArray <ObjectType> (Functional)

- (nonnull NSArray *)rd_map: (nonnull id _Nonnull (^)(id _Nonnull obj))mapper;
- (nullable ObjectType)rd_randomItem;

@end

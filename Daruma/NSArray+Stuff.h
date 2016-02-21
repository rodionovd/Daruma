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
- (nonnull NSArray *)rd_filterWithBlock: (nonnull BOOL (^)(id _Nonnull obj))block;
- (void)rd_each: (nonnull void (^)(id _Nonnull obj))block;
- (nonnull NSArray *)rd_distinct;
- (nullable ObjectType)rd_randomItem;

@end

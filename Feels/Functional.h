//
//  NSSet+Functional.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface NSSet (Functional)
- (nonnull NSSet *)rd_map: (nonnull id _Nonnull (^)(id _Nonnull obj))mapper;
@end

@interface NSArray (Functional)
- (nonnull NSArray *)rd_map: (nonnull id _Nonnull (^)(id _Nonnull obj))mapper;
- (nonnull NSArray *)rd_shuffledArray;
@end

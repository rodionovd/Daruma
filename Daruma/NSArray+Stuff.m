//
//  NSSet+Functional.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "NSArray+Stuff.h"

@implementation NSArray (Functional)

- (nonnull NSArray *)rd_map: (nonnull id (^)(id obj))mapper
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity: self.count];
    [self enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject: mapper(obj)];
    }];
    return result;
}

- (nullable id)rd_randomItem
{
    return self.count == 0 ? nil : self[arc4random_uniform((uint32_t)self.count)];
}

@end

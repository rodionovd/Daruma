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

- (nonnull NSArray *)rd_flatMap: (nonnull NSArray *_Nonnull (^)(id _Nonnull obj))mapper
{
    NSMutableArray *result = [NSMutableArray array];
    [self enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObjectsFromArray: mapper(obj)];
    }];
    return result;
}

- (NSArray *)rd_filter:(BOOL (^)(id))block
{
    NSMutableArray *new = [NSMutableArray array];
    [self enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) [new addObject: obj];
    }];
    return new;
}

- (void)rd_each: (nonnull void (^)(id _Nonnull obj))block
{
    [self enumerateObjectsUsingBlock: ^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (nonnull NSArray *)rd_distinct
{
    return [[NSOrderedSet orderedSetWithArray: self] array];
}

- (nullable id)rd_randomItem
{
    return self.count == 0 ? nil : self[arc4random_uniform((uint32_t)self.count)];
}

@end

//
//  NSSet+Functional.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "Functional.h"

@implementation NSArray (Functional)

- (nonnull NSArray *)rd_map: (nonnull id (^)(id obj))mapper
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity: self.count];
    [self enumerateObjectsUsingBlock: ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject: mapper(obj)];
    }];
    return result;
}

- (nonnull NSArray *)rd_shuffledArray
{
    NSUInteger count = self.count;
    NSMutableArray *tmp = [self mutableCopy];
    
    for(NSUInteger i = count; i > 1; i--) {
        NSUInteger j = random_below(i);
        [tmp exchangeObjectAtIndex: (i-1) withObjectAtIndex: j];
    }
    return [tmp copy];
}

static inline NSUInteger random_below(NSUInteger n)
{
    NSUInteger m = 1;
    do {
        m <<= 1;
    } while(m < n);
    NSUInteger ret;
    do {
        ret = random() % m;
    } while(ret >= n);
    return ret;
}

@end
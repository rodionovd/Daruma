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

@end
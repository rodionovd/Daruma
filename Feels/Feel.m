//
//  Feel.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "Feel.h"

@implementation Feel

- (nonnull instancetype)initWithEmoticon: (nonnull NSString *)emoticon label: (nullable NSString *)label
{
    if ((self = [super init])) {
        _emoticon = [emoticon copy];
        _label = [label copy];
    }
    return self;
}

+ (nullable instancetype)feelFromDictionary: (nonnull NSDictionary *)dictionary
{
    NSString *emoticon = dictionary[@"emoticon"];
    NSString *label = dictionary[@"label"];
    if (emoticon == nil) {
        return nil;
    } else {
        return [[[self class] alloc] initWithEmoticon: emoticon label: label];
    }
}

@end

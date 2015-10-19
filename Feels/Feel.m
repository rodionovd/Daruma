//
//  Feel.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "Feel.h"

const static NSString *kFeelLabelKey = @"label";
const static NSString *kFeelEmoticonKey = @"emoticon";

@implementation Feel

- (nonnull instancetype)initWithEmoticon: (nonnull NSString *)emoticon label: (nullable NSString *)label
{
    if ((self = [super init])) {
        _emoticon = [emoticon copy];
        _label = [label copy];
    }
    return self;
}

+ (BOOL)_validateDictionaryRepresentation: (nonnull NSDictionary *)dictionaryRepresentation
{
    return !![dictionaryRepresentation objectForKey: kFeelEmoticonKey];
}

+ (nullable instancetype)deserialize: (nonnull NSDictionary *)dictionary
{
    if ([self _validateDictionaryRepresentation: dictionary] == NO) {
        return nil;
    }

    NSString *emoticon = dictionary[kFeelEmoticonKey];
    NSString *label = dictionary[kFeelLabelKey];
    if (emoticon == nil) {
        return nil;
    } else {
        return [[[self class] alloc] initWithEmoticon: emoticon label: label];
    }
}

@end

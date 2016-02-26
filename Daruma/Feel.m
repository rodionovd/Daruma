//
//  Feel.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

#import "Feel.h"

static NSString * const kFeelLabelKey = @"label";
static NSString * const kFeelEmoticonKey = @"emoticon";

@implementation Feel

+ (nullable instancetype)deserialize: (nonnull NSDictionary *)dictionaryRepresentation
{
    if ([self _validateDictionaryRepresentation: dictionaryRepresentation] == NO) {
        [NSException exceptionWithName: @"Invalid dictionary representation for Feel object"
                                reason: dictionaryRepresentation.descriptionInStringsFileFormat
                              userInfo:nil];
        return nil;
    }

    NSString *emoticon = dictionaryRepresentation[kFeelEmoticonKey];
    NSString *label = dictionaryRepresentation[kFeelLabelKey];
    if (emoticon == nil) {
        return nil;
    } else {
        return [[[self class] alloc] initWithEmoticon: emoticon label: label];
    }
}

+ (BOOL)_validateDictionaryRepresentation: (nonnull NSDictionary *)dictionaryRepresentation
{
    id rawEmoticon = dictionaryRepresentation[kFeelEmoticonKey];
    BOOL emoticonIsValid = [rawEmoticon isKindOfClass: [NSString class]] && [rawEmoticon length] > 0;

    id rawLabel = dictionaryRepresentation[kFeelLabelKey];
    BOOL labelIsValid = (rawLabel == nil) ? YES : [rawLabel isKindOfClass: [NSString class]];

    return (emoticonIsValid && labelIsValid);
}

- (nonnull instancetype)initWithEmoticon: (nonnull NSString *)emoticon label: (nullable NSString *)label
{
    if ((self = [super init])) {
        _emoticon = [emoticon copy];
        _label = [label copy];
    }
    return self;
}

- (NSString *)description
{
    if (self.label) {
        return [NSString stringWithFormat: @"<%@: %p, emoticon: %@, label: '%@'>",
                NSStringFromClass([self class]), (void *)self, self.emoticon, self.label];
    } else {
        return [NSString stringWithFormat: @"<%@: %p, emoticon: %@>",
                NSStringFromClass([self class]), (void *)self, self.emoticon];
    }
}

@end

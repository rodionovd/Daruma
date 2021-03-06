//
//  Section.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

#import "Section.h"
#import "Feel.h"
#import "NSArray+Stuff.h"

const static NSString *kSectionTitleKey = @"title";
const static NSString *kSectionItemsKey = @"items";
const static NSString *kSectionKeywordsKey = @"keywords";


@interface Section()
@property (strong, readwrite) NSString *title;
@property (strong, readwrite) NSSet *keywords;
@property (strong, readwrite) NSArray <Feel *> *items;
@end

@implementation Section

+ (nullable instancetype)deserialize: (nonnull NSDictionary *)dictionaryRepresentation
{
    if ([[self class] _validateDictionaryRepresentation: dictionaryRepresentation] == NO) {
        [NSException exceptionWithName: @"Invalid dictionary representation for Section object"
                                reason: dictionaryRepresentation.descriptionInStringsFileFormat
                              userInfo:nil];
        return nil;
    }
    return [[self alloc] initWithDictionaryRepresentation: dictionaryRepresentation];
}

+ (BOOL)_validateDictionaryRepresentation: (nonnull NSDictionary *)dictionaryRepresentation
{
    id rawTitle = dictionaryRepresentation[kSectionTitleKey];
    BOOL titleIsValid = [rawTitle isKindOfClass: [NSString class]];

    id rawKeywords = dictionaryRepresentation[kSectionKeywordsKey];
    BOOL keywordsAreValid = (rawKeywords == nil) ? YES : [rawKeywords isKindOfClass: [NSArray class]];

    id rawItems = dictionaryRepresentation[@"items"];
    BOOL itemsAreValid = [rawItems isKindOfClass: [NSArray class]] && [rawItems count] > 0;

    return (titleIsValid && keywordsAreValid && itemsAreValid);
}

- (nullable instancetype)initWithDictionaryRepresentation: (nonnull NSDictionary *)dictionary
{
    if ((self = [super init])) {
        _title = dictionary[kSectionTitleKey];
        _keywords = [NSSet setWithArray: dictionary[kSectionKeywordsKey] ?: @[]];
        _items = [(NSArray *)dictionary[kSectionItemsKey] rd_map: ^Feel *(NSDictionary *item) {
            return [Feel deserialize: item];
        }];
    }
    return self;
}

- (BOOL)matchesDescription: (nonnull NSString *)description
{
    if ([self.title.lowercaseString containsString: description.lowercaseString]) {
        return YES;
    }
    __block BOOL matches = NO;
    [self.keywords enumerateObjectsUsingBlock: ^(NSString *keyword, BOOL *stop) {
        if ([keyword hasPrefix: description]) {
            matches = YES;
            *stop = YES;
        }
    }];
    return matches;
}

- (NSString *)description
{
    const int kMaxItemsToDisplay = 5;
    if (self.items.count <= kMaxItemsToDisplay) {
        return [NSString stringWithFormat: @"<%@: %p, title: '%@', items: %@>",
                NSStringFromClass([self class]), (void *)self, self.title, self.items];
    } else {
        return [NSString stringWithFormat: @"<%@: %p, title: '%@', items: %lu>",
                NSStringFromClass([self class]), (void *)self, self.title, self.items.count];
    }
}

@end

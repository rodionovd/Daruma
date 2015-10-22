//
//  Section.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "Section.h"
#import "Feel.h"
#import "NSArray+Stuff.h"

const static NSString *kSectionTitleKey = @"title";
const static NSString *kSectionItemsKey = @"items";
const static NSString *kSectionKeywordsKey = @"keywords";


@interface Section()
@property (strong, readwrite) NSString *title;
@property (strong, readwrite) NSArray *keywords;
@property (strong, readwrite) NSArray <Feel *> *items;
@end

@implementation Section

+ (nullable instancetype)deserialize: (nonnull NSDictionary *)dictionaryRepresentation
{
    if ([self.class _validateDictionaryRepresentation: dictionaryRepresentation] == NO) {
        [NSException exceptionWithName: @"Invalid dictionary representation for Section object"
                                reason: [dictionaryRepresentation descriptionInStringsFileFormat]
                              userInfo:nil];
        return nil;
    }
    return [[self alloc] initWithDictionaryRepresentation: dictionaryRepresentation];
}

+ (BOOL)_validateDictionaryRepresentation: (nonnull NSDictionary *)dictionaryRepresentation
{
    id rawTitle = [dictionaryRepresentation objectForKey: kSectionTitleKey];
    BOOL titleIsValid = [rawTitle isKindOfClass: [NSString class]];

    id rawKeywords = [dictionaryRepresentation objectForKey: kSectionKeywordsKey];
    BOOL keywordsAreValid = (rawKeywords == nil) ? YES : [rawKeywords isKindOfClass: [NSArray class]];

    id rawItems = [dictionaryRepresentation objectForKey: @"items"];
    BOOL itemsAreValid = [rawItems isKindOfClass: [NSArray class]] && [rawItems count] > 0;

    return (titleIsValid && keywordsAreValid && itemsAreValid);
}

- (nullable instancetype)initWithDictionaryRepresentation: (nonnull NSDictionary *)dictionary
{
    if ((self = [super init])) {
        self.title = dictionary[kSectionTitleKey];
        self.keywords = dictionary[kSectionKeywordsKey] ?: @[];
        self.items = [(NSArray *)dictionary[kSectionItemsKey] rd_map: ^Feel *(NSDictionary *item) {
            return [Feel deserialize: item];
        }];
    }
    return self;
}

- (BOOL)matchesDescription: (nonnull NSString *)description
{
    return [self.title.lowercaseString containsString: description.lowercaseString];
}

- (NSString *)description
{
    const int kMaxItemsToDisplay = 5;
    if (self.items.count <= kMaxItemsToDisplay) {
        return [NSString stringWithFormat: @"<%@: %p, title: '%@', items: %@>",
                NSStringFromClass(self.class), (void *)self, self.title, self.items];
    } else {
        return [NSString stringWithFormat: @"<%@: %p, title: '%@', items: %lu>",
                NSStringFromClass(self.class), (void *)self, self.title, self.items.count];
    }
}

@end

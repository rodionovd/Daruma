//
//  Section.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "Section.h"
#import "Feel.h"
#import "Functional.h"

const static NSString *kSectionTitleKey = @"title";
const static NSString *kSectionItemsKey = @"items";
const static NSString *kSectionKeywordsKey = @"keywords";


@interface Section()
@property (strong, readwrite) NSString *title;
@property (strong, readwrite) NSString *keywords;
@property (strong, readwrite) NSArray <Feel *> *items;
@end

@implementation Section

+ (nullable instancetype)deserialize: (nonnull NSDictionary *)dictionaryRepresentation
{
    if ([self.class _validateDictionaryRepresentation: dictionaryRepresentation] == NO) {
        return nil;
    }
    return [[self alloc] initWithDictionaryRepresentation: dictionaryRepresentation];
}

+ (BOOL)_validateDictionaryRepresentation: (nonnull NSDictionary *)dictionaryRepresentation
{
    BOOL hasTitleKey = !![dictionaryRepresentation objectForKey: kSectionTitleKey];
    BOOL hasItems = [(NSArray *)[dictionaryRepresentation objectForKey: @"items"] count] > 0;

    return (hasTitleKey && hasItems);
}

- (nullable instancetype)initWithDictionaryRepresentation: (nonnull NSDictionary *)dictionary
{
    if ((self = [super init])) {
        self.title = dictionary[kSectionTitleKey];
        self.keywords = dictionary[kSectionKeywordsKey] ?: @"";
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

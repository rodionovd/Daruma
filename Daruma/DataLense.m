//
//  DataLense.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import <AppKit/NSCollectionView.h> // for UIKit-style NSIndexPath accessors (section, item)
#import "DataLense.h"
#import "Feel.h"
#import "Section.h"
#import "NSArray+Stuff.h"
#import "EmoticonValueTransformer.h"

@interface DataLense()
@property (strong) NSArray <Section *> *allSections;
@property (strong) NSArray <Section *> *view;
@property (strong) NSArray *searchDomain;
@end

@implementation DataLense

- (nullable instancetype)initWithContentsOfURL: (NSURL *)contentsURL
{
    if ((self = [super init])) {
        [self loadDataFromURL: contentsURL];
        _predicate = [@"" copy];
        self.view = self.allSections;
    }
    return self;
}

- (void)loadDataFromURL: (NSURL *)fileURL
{
    NSDictionary *contents = [NSDictionary dictionaryWithContentsOfURL:fileURL];
    NSAssert(contents != nil, @"Invalid storage resource");
    
    NSMutableArray <Section *> *sections =
        [NSMutableArray arrayWithCapacity: [contents[@"sections"] count]];
    [contents[@"sections"] enumerateObjectsUsingBlock:
        ^(NSDictionary *sectionDescription, NSUInteger idx, BOOL *stop)
    {
        Section *tmp = [Section deserialize: sectionDescription];
        NSAssert(tmp != nil, @"Could not deserialize the section no. %lu from a dictionary", idx);
        [sections addObject: tmp];
    }];
    self.allSections = sections;
}

#pragma mark - Data Access

- (Feel *)objectAtIndexPath: (NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section < self.view.count);
    NSParameterAssert(indexPath.item < self.view[indexPath.section].items.count);
    
    return self.view[indexPath.section].items[indexPath.item];
}

- (NSString *)contentsForItemsAtIndexPaths: (nonnull NSSet <NSIndexPath *> *)indexPaths
{
    NSArray *sortedByItemIndex = [indexPaths.allObjects sortedArrayUsingSelector: @selector(compare:)];
    EmoticonValueTransformer *transformer = [EmoticonValueTransformer new];
    NSArray *emoticons = [sortedByItemIndex rd_map: ^NSString *_Nonnull(NSIndexPath *_Nonnull path) {
        return [transformer transformedValueForCopying: [[self objectAtIndexPath: path] emoticon]];
    }];
    
    NSString *single_whitespace = @" ";
    return [emoticons componentsJoinedByString: single_whitespace];
}

#pragma mark - Filtering

- (void)setPredicate: (nullable NSString *)newPredicate
{
    if (newPredicate == nil && [_predicate isNotEqualTo: @""]) {
        _predicate = @"";
        self.view = self.allSections;
    } else if ([newPredicate isNotEqualTo: _predicate]) {
        // TODO: use even more sophisticated logic here?
        if ([newPredicate hasPrefix: _predicate]) {
            // Search in previous results
            self.searchDomain = self.view;
        } else {
            // Search everywhere
            self.searchDomain = self.allSections;
        }
        _predicate = [newPredicate copy];
        self.view = nil;
    }
}

- (NSArray <Section *> *)view
{
    if (_view != nil) {
        return _view;
    }

    NSArray *searchResults =  [self.searchDomain filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:
    ^BOOL(Section *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings)
    {
        return [evaluatedObject matchesDescription: _predicate];
    }]];
    _view = [searchResults copy];

    return _view;
}

#pragma mark - KVC helpers

#define KVOKeyForClass(cls, key) ([(cls *)nil key], @#key)

+ (nonnull NSString *)observableContentsKey
{
    return KVOKeyForClass(DataLense, view);
}

+ (nonnull NSString *)observablePredicateKey
{
    return KVOKeyForClass(DataLense,predicate);
}

#pragma mark - Description

- (NSString *)description
{
    const int kMaxItemsToDisplay = 10;
    if (self.view.count <= kMaxItemsToDisplay) {
        return [NSString stringWithFormat: @"<%@: %p, predicate: '%@', view: %@>",
                NSStringFromClass(self.class), (void *)self, self.predicate, self.view];
    } else {
        return [NSString stringWithFormat: @"<%@: %p, predicate: '%@', view size: %lu>",
                NSStringFromClass(self.class), (void *)self, self.predicate, self.view.count];
    }
}
@end

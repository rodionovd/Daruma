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

@interface DataLense()
@property (strong) NSArray <Section *> *allSections;
@property (strong) NSArray <Section *> *sections;
@property (strong) NSArray *searchDomain;
@end

@implementation DataLense

- (nullable instancetype)initWithContentsOfURL: (NSURL *)contentsURL
{
    if ((self = [super init])) {
        [self loadDataFromURL: contentsURL];
        _predicate = [@"" copy];
        self.sections = self.allSections;
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

- (Feel *)objectAtIndexPath: (NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section < self.sections.count);
    NSParameterAssert(indexPath.item < self.sections[indexPath.section].items.count);
    
    return self.sections[indexPath.section].items[indexPath.item];
}

- (NSString *)contentsForItemsAtIndexPaths: (nonnull NSSet <NSIndexPath *> *)indexPaths
{
    NSArray *sortedByItemIndex = [indexPaths.allObjects sortedArrayUsingSelector: @selector(compare:)];
    NSArray *emoticons = [sortedByItemIndex rd_map: ^NSString *_Nonnull(NSIndexPath *_Nonnull path) {
        return [[self objectAtIndexPath: path] emoticon];
    }];
    
    NSString *single_whitespace = @" ";
    return [emoticons componentsJoinedByString: single_whitespace];
}

- (void)setPredicate: (nullable NSString *)newPredicate
{
    if (newPredicate == nil && [_predicate isNotEqualTo: @""]) {
        _predicate = @"";
        [self willChangeValueForKey: @"sections"];
        self.sections = self.allSections;
        [self didChangeValueForKey: @"sections"];
    } else if ([newPredicate isNotEqualTo: _predicate]) {
        // TODO: use even more sophisticated logic here?
        if ([newPredicate hasPrefix: _predicate]) {
            // Search in previous results
            self.searchDomain = self.sections;
        } else {
            // Search everywhere
            self.searchDomain = self.allSections;
        }
        _predicate = [newPredicate copy];
        self.sections = nil;
        // Get ready!
        [self willChangeValueForKey: @"sections"];
        [self didChangeValueForKey: @"sections"];
    }
}

- (NSArray <Section *> *)sections
{
    if (_sections != nil) {
        return _sections;
    }

    NSArray *searchResults =  [self.searchDomain filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:
    ^BOOL(Section *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings)
    {
        return [evaluatedObject matchesDescription: _predicate];
    }]];
    _sections = [searchResults copy];

    return _sections;
}

- (NSString *)description
{
    const int kMaxItemsToDisplay = 10;
    if (self.sections.count <= kMaxItemsToDisplay) {
        return [NSString stringWithFormat: @"<%@: %p, predicate: '%@', view: %@>",
                NSStringFromClass(self.class), (void *)self, self.predicate, self.sections];
    } else {
        return [NSString stringWithFormat: @"<%@: %p, predicate: '%@', view size: %lu>",
                NSStringFromClass(self.class), (void *)self, self.predicate, self.sections.count];
    }
}
@end

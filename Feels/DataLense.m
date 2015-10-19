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

@interface DataLense()
@property (strong) NSOrderedSet <Section *> *allSections;
@property (strong) NSOrderedSet <Section *> *sections;
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
    
    NSMutableOrderedSet <Section *> *sections =
        [NSMutableOrderedSet orderedSetWithCapacity: [contents[@"sections"] count]];
    [contents[@"sections"] enumerateObjectsUsingBlock: ^(NSDictionary *sectionDescription, NSUInteger idx, BOOL *stop) {
        Section *tmp = [Section deserialize: sectionDescription];
        NSAssert(tmp != nil, @"Could not serialize a section [%lu] from dictionary", idx);
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

- (void)setPredicate: (nullable NSString *)predicate
{
    if (predicate == nil) {
        _predicate = @"";
    } else if ([predicate isNotEqualTo: _predicate]) {
        _predicate = [predicate copy];
        NSLog(@"Got new predicate: %@", _predicate);
        // TODO: actually use this predicate to create a lense
    }
}
@end

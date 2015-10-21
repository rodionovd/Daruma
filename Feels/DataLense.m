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
@property (strong) NSArray <Section *> *allSections;
@property (strong) NSArray <Section *> *sections;
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
        NSAssert(tmp != nil, @"Could not deserialize a section [%lu] from dictionary", idx);
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

- (void)setPredicate: (nullable NSString *)newPredicate
{
    if (newPredicate == nil) {
        _predicate = @"";
        self.sections = self.allSections;
    } else if ([newPredicate isNotEqualTo: _predicate]) {
        // Apply this new predicate to the lense
        NSArray *source = nil;
        // TODO: more sophisticated logic here
        if ([newPredicate hasPrefix: _predicate]) {
            // Don't bother searching everything then
            source = self.sections;
        } else {
            source = self.allSections;
        }

        _predicate = [newPredicate copy];

        self.sections = [source filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:
            ^BOOL(Section *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings)
        {
            return [evaluatedObject matchesDescription: _predicate];
        }]];        
    }
}
@end

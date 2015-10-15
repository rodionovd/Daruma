//
//  FeelsContainer.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import <AppKit/NSCollectionView.h> // for UIKit-style NSIndexPath accessors (section and item)
#import "FeelContainer.h"
#import "Feel.h"
#import "Functional.h"

@interface FeelContainer()
@property NSOrderedSet<Feel *>* internalContainer;
@end

@implementation FeelContainer

- (instancetype)initWithURL: (NSURL *)containerURL
{
    if ((self = [super init])) {
        [self setupInternalContainerFromURL: containerURL];
    }
    return self;
}

- (NSInteger)count
{
    return self.internalContainer.count;
}

- (Feel *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.internalContainer objectAtIndex: indexPath.item];
}

#pragma mark - Internal

- (void)setupInternalContainerFromURL: (nonnull NSURL *)url
{
    NSDictionary *database = [NSDictionary dictionaryWithContentsOfURL: url];
    NSAssert(database != nil, @"Invalid container URL");
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity: [database[@"feels"] count]];
    [database[@"feels"] enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * stop) {
        id feel = [Feel feelFromDictionary: item];
        if (feel) [tmp addObject: feel];
    }];
    // FIXME: don't shuffle in Release
    // NOTE: the seed is hardcoded here for reproducibility
    srandom(1337);
    self.internalContainer = [NSOrderedSet orderedSetWithArray: [tmp rd_shuffledArray]];
}

@end

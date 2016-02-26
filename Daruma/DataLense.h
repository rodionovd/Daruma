//
//  DataLense.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import Foundation;

@class Feel;
#import "Section.h"

@interface DataLense : NSObject

- (nullable instancetype)initWithContentsOfURL: (nonnull NSURL *)contentsURL;

@property (readonly, strong, nonnull) NSArray <Section *> *allSections;
@property (copy, null_resettable, nonatomic) NSString *predicate;
@property (readonly, nullable, nonatomic) NSArray <Section *> *view;

- (nullable Feel *)objectAtIndexPath: (nonnull NSIndexPath *)indexPath;
- (nonnull NSString *)contentsForItemsAtIndexPaths: (nonnull NSSet <NSIndexPath *> *)indexPaths;

// KVO helpers
+ (nonnull NSString *)observableContentsKey;
+ (nonnull NSString *)observablePredicateKey;

@end

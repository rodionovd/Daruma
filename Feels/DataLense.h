//
//  DataLense.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Foundation;

@class Feel;
#import "Section.h"

@interface DataLense : NSObject

- (nullable instancetype)initWithContentsOfURL: (nonnull NSURL *)contentsURL;

@property (readonly, strong, nonnull) NSArray <Section *> *allSections;
@property (copy, null_resettable, nonatomic) NSString *predicate;
@property (readonly, nullable) NSArray <Section *> *sections;

- (nullable Feel *)objectAtIndexPath: (nonnull NSIndexPath *)indexPath;

@end

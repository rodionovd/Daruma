//
//  Section.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import Foundation;
@class Feel;

@interface Section : NSObject

@property (readonly, nonnull) NSString *title;
@property (readonly, nonnull) NSSet *keywords;
@property (readonly, nonnull) NSArray <Feel *> *items;

+ (nullable instancetype)deserialize: (nonnull NSDictionary *)dictionaryRepresentation;
- (BOOL)matchesDescription: (nonnull NSString *)description;
@end

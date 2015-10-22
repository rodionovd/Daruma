//
//  Feel.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Foundation;

@interface Feel : NSObject

@property (readonly, nonnull) NSString *emoticon;
@property (readonly, nullable) NSString *label;

+ (nullable instancetype)deserialize: (nonnull NSDictionary *)dictionaryRepresentation;

@end

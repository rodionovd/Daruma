//
//  EmoticonValueTransformer.h
//  Daruma
//
//  Created by Dmitry Rodionov on 10/26/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import Foundation;

/// Inserts newlines as appropriate for the better look.
/// This tranformer is utilized by the FeelEmoticonView <-> model binding
@interface EmoticonValueTransformer : NSValueTransformer

- (NSString *)transformedValueForCopying: (NSString *)value;

@end

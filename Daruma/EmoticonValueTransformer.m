//
//  EmoticonValueTransformer.m
//  Daruma
//
//  Created by Dmitry Rodionov on 10/26/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "EmoticonValueTransformer.h"

@implementation EmoticonValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

+ (NSString *)newLineFlag
{
    return @"<!nl!>";
}

- (NSString *)transformedValue: (NSString *)value
{
    if (NO == [value isKindOfClass: [NSString class]]) return value;
    return [value stringByReplacingOccurrencesOfString: [self.class newLineFlag]
                                            withString: @"\n"];
}

- (NSString *)transformedValueForCopying: (NSString *)value
{
    if (NO == [value isKindOfClass: [NSString class]]) return value;
    return [value stringByReplacingOccurrencesOfString: [self.class newLineFlag]
                                            withString: @""];
}

@end

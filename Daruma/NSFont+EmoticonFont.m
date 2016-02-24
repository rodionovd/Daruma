//
//  NSFont+Emoticons.m
//  Daruma
//
//  Created by Dmitry Rodionov on 10/26/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "NSFont+EmoticonFont.h"

static NSString * const kDarumaDefaultEmoticonFontName = @".SFNSText-Light";
static CGFloat const kDarumaDefaultEmoticonFontSize = 27.f;

@implementation NSFont (Emoticons)

+ (NSFont *)rd_emoticonFont
{
    static NSFont *chosenFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Well. If we try to use -[NSFont systemFontOfSize:weight:] here
        // we'll got *so many* leaks when trying to calculate an emoticon size with
        // -[NSString boundingRectWithSize:options:attributes:context:], because for some reason it
        // creates a new font on every call if we pass -systemFontOfSize:weight: as a value to the
        // NSFontAttributeName attribute ¯\_(ツ)_/¯
        chosenFont = [NSFont fontWithName: kDarumaDefaultEmoticonFontName size: kDarumaDefaultEmoticonFontSize];
        // We could also fallback to Helvetica or something else, but I don't care since
        // Daruma requires 10.11+ anyway
        NSAssert(chosenFont != nil, @"oops, where's my San Francisco?!");
    });
    return chosenFont;
}

@end

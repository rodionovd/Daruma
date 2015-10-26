//
//  NSFont+Emoticons.m
//  Daruma
//
//  Created by Dmitry Rodionov on 10/26/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "NSFont+EmoticonFont.h"

@implementation NSFont (Emoticons)


// TODO: these dispatch_once()s will hurt so much when I implement dynamic fonts…

+ (NSFont *)rd_emoticonFont
{
    static NSFont *chosenFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Well. If we try to use [NSFont systemFontOfSize: 25 weight: NSFontWeightLight] here
        // we'll got *so many* leaks when trying to calculate an emoticon size with
        // -[NSString boundingRectWithSize:options:attributes:context:], because for some reason it
        // creates a new font on every call if we pass -systemFontOfSize:weight: as a value to the
        // NSFontAttributeName attribute ¯\_(ツ)_/¯
        chosenFont = [NSFont fontWithName: @".SFNSText-Light" size: 25];
        // We could also fallback to Helvetica or something else, but I don't care since
        // Daruma requires 10.11+ anyway
        NSAssert(chosenFont != nil, @"oops, where's my San Francisco?!");
    });
    return chosenFont;
}

+ (NSFont *)rd_emoticonFontForMeasurements
{
#define kEmoticonFontSizeMultiplier (1.15)
    static NSFont *fontForMeasurements = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFont *baseFont = [self rd_emoticonFont];
        // Make more room for huge emoticons
        fontForMeasurements = [NSFont fontWithName: baseFont.fontName
                                       size: baseFont.pointSize * kEmoticonFontSizeMultiplier];
    });
    return fontForMeasurements;
}

@end

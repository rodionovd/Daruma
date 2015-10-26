//
//  NSFont+Emoticons.m
//  Daruma
//
//  Created by Dmitry Rodionov on 10/26/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "NSFont+EmoticonFont.h"

@implementation NSFont (Emoticons)

+ (NSFont *)rd_emoticonFont
{
    return [NSFont systemFontOfSize: 25 weight: NSFontWeightRegular];
}

@end

//
//  NSString+EmoticonSize.m
//  Daruma
//
//  Created by Dmitry Rodionov on 10/26/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "NSString+EmoticonSize.h"
#import "NSFont+Emoticons.h"

@implementation NSString (EmoticonSize)

/// Welcome to a font nightmare, stranger.
/// The code below is responsible for calculating a size of an emoticon inside
/// a text field, so this textfield's bounds can be adjusted by a collection view layout later on.
- (NSSize)rd_emoticonSize
{
// Emoticons could be huge and we have to deal with it
#define kEmoticonFontSizeMultiplier (1.15)
#define kItemSizeHeightMultiplier (1.3)

    NSFont *emoticonFont = [NSFont rd_emoticonFont];
    NSDictionary *fontAttributes = @{
        NSFontAttributeName: [NSFont fontWithName: emoticonFont.fontName
                                             // Make more room for huge emoticons
                                             size: emoticonFont.pointSize * kEmoticonFontSizeMultiplier]
    };
    NSStringDrawingOptions drawingOptions =
    NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics;
    NSSize proposedSize = [self boundingRectWithSize: NSZeroSize
                                                 options: drawingOptions
                                              attributes: fontAttributes
                                                 context: nil].size;

    // Round up since we don't neeed all the precision CGFloat has
    // (it actually causes items popping, so just remove everything after the decimal point/comma)
    proposedSize.width = ceil(proposedSize.width);
    proposedSize.height = ceil(proposedSize.height);

    // Sanitize an item's height: it should be a bit taller than the default coz emoticons
    // tend to grow up and down the baseline
    proposedSize.height *= kItemSizeHeightMultiplier;
    
    return proposedSize;
}

@end

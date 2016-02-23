//
//  EmoticonPainter.m
//  Daruma
//
//  Created by Dmitry Rodionov on 10/27/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "EmoticonRenderer.h"
#import "NSFont+EmoticonFont.h"

@interface EmoticonRenderer()
@property (strong) NSTextStorage *textStorage;
@property (assign) NSRange glyphRange;
@end

@implementation EmoticonRenderer

- (instancetype)initWithEmoticon: (NSString *)emoticon
{
    if ((self = [super init])) {

        NSDictionary *attrs = @{
            NSFontAttributeName: [NSFont rd_emoticonFont]
        };
        _textStorage = [[NSTextStorage alloc] initWithString: emoticon
                                                  attributes: attrs];
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        NSTextContainer *textContainer = [NSTextContainer new];
        [layoutManager addTextContainer: textContainer];
        [_textStorage addLayoutManager: layoutManager];

        // Force glyph generation and layout
        _glyphRange = [layoutManager glyphRangeForTextContainer: textContainer];
    }
    return self;
}

+ (instancetype)rendererForEmoticon: (NSString *)emoticon
{
    return [[self alloc] initWithEmoticon: emoticon];
}

- (void)drawEmoticonInRect: (NSRect)rect
{
    NSLayoutManager *layoutManager = [self.textStorage.layoutManagers firstObject];
    [layoutManager drawGlyphsForGlyphRange: self.glyphRange atPoint: rect.origin];
}

- (NSSize)calculateEmoticonSize
{
    NSLayoutManager *layoutManager = [self.textStorage.layoutManagers firstObject];
    NSRect usedRect = [layoutManager usedRectForTextContainer: layoutManager.textContainers.firstObject];
    // Round up since we don't neeed all the precision CGFloat has
    // (it actually causes items popping, so just remove everything after the decimal point/comma)
    return NSMakeSize(ceil(usedRect.size.width), ceil(usedRect.size.height));
}

@end

//
//  EmoticonPainter.m
//  Daruma
//
//  Created by Dmitry Rodionov on 10/27/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "EmoticonPainter.h"
#import "NSFont+EmoticonFont.h"

@interface EmoticonPainter()
@property (strong) NSTextStorage *textStorage;
@property (assign) NSRange glyphRange;
@end

@implementation EmoticonPainter

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

+ (instancetype)painterForEmoticon: (NSString *)emoticon
{
    return [[self alloc] initWithEmoticon: emoticon];
}

- (void)drawEmoticonInRect: (NSRect)rect
{
    NSLayoutManager *layoutManager = [self.textStorage.layoutManagers firstObject];
    [layoutManager drawGlyphsForGlyphRange: self.glyphRange atPoint: rect.origin];
}

@end

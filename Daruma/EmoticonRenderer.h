//
//  EmoticonPainter.h
//  Daruma
//
//  Created by Dmitry Rodionov on 10/27/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface EmoticonRenderer : NSObject

- (instancetype)initWithEmoticon: (NSString *)emoticon;
+ (instancetype)rendererForEmoticon: (NSString *)emoticon;

- (void)drawEmoticonInRect: (NSRect)rect;
- (NSSize)calculateEmoticonSize;

@end

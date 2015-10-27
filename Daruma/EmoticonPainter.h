//
//  EmoticonPainter.h
//  Daruma
//
//  Created by Dmitry Rodionov on 10/27/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface EmoticonPainter : NSObject

- (instancetype)initWithEmoticon: (NSString *)emoticon;
+ (instancetype)painterForEmoticon: (NSString *)emoticon;

- (void)drawEmoticonInRect: (NSRect)rect;

@end

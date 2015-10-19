//
//  HeaderView.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView()
@end

@implementation HeaderView

+ (NSSize)baseSize
{
    return NSMakeSize(
        0  /*width will be automatically adjusted by an enclosing collection view */,
        25
    );
}

- (void)setTitle: (NSString *)title
{
    NSTextField *textField = nil;
    for (NSView *view in self.subviews) {
        if ([view isKindOfClass: [NSTextField class]]) {
            textField = (NSTextField *)view;
        }
    }
    if (!textField) return;

    _title = [title copy];
    textField.stringValue = _title;
}

// Source: Apple's CocoaSlideCollection demo
- (void)drawRect: (NSRect)dirtyRect
{
    // Fill with semitransparent white.
    [[NSColor colorWithCalibratedWhite:0.95 alpha: .4] set];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);

    // Fill bottom and top edges with semitransparent gray.
    [[NSColor colorWithCalibratedWhite:0.75 alpha: .4] set];

    NSRect bottomEdgeRect = self.bounds;
    bottomEdgeRect.size.height = .5f;
    NSRectFillUsingOperation(bottomEdgeRect, NSCompositeSourceOver);

    NSRect topEdgeRect = bottomEdgeRect;
    topEdgeRect.origin.y = NSMaxY(self.bounds) - 1.0;
    NSRectFillUsingOperation(topEdgeRect, NSCompositeSourceOver);
}

@end

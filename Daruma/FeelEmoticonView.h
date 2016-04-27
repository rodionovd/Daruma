//
//  FeelEmoticonView.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/14/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

@class EmoticonRenderer;

typedef void(^EmoticonDoubleClickAction)(void);

@interface FeelEmoticonView : NSView
{
@protected
    dispatch_queue_t _actionsQueue;
}

@property (nonatomic) NSCollectionViewItemHighlightState highlightState;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (copy, nullable) EmoticonDoubleClickAction doubleClickAction;
// We don't rely on something like NSTextField's own rendering since its results can't be cached,
// so instead we use an external rendered and draw emoticions ourselves in drawRect:.
@property (weak, nullable) EmoticonRenderer *renderer;

@end

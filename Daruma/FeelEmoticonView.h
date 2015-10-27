//
//  FeelEmoticonView.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/14/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;

@class EmoticonPainter;

@interface FeelEmoticonView : NSView

@property (nonatomic) NSCollectionViewItemHighlightState highlightState;
@property (nonatomic, getter=isSelected) BOOL selected;

//
@property (weak) EmoticonPainter *painter;

@end

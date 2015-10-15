//
//  FeelViewItem.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "FeelViewItem.h"
#import "FeelEmoticonView.h"

@interface FeelViewItem ()
@end

@implementation FeelViewItem

#pragma mark Selection and Highlighting

- (void)setHighlightState: (NSCollectionViewItemHighlightState)newHighlightState
{
    [super setHighlightState: newHighlightState];
    [(FeelEmoticonView *)self.view setHighlightState: newHighlightState];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected: selected];
    [(FeelEmoticonView *)self.view setSelected: selected];
}

@end

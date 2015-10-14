//
//  FeelViewItem.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "FeelViewItem.h"

@interface FeelViewItem ()

@end

@implementation FeelViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}


#pragma mark Selection and Highlighting Support

- (void)setHighlightState:(NSCollectionViewItemHighlightState)newHighlightState
{
    [super setHighlightState:newHighlightState];

}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

@end

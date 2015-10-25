//
//  VerticallyCenteredTextCell.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/17/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "VerticallyCenteredTextCell.h"

@implementation VerticallyCenteredTextCell

- (void)awakeFromNib
{
    // XXX: goodbye, Mac App Store
    _cFlags.vCentered = 1;
}

@end

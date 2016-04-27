//
//  RectanglePulseLayer.h
//  Daruma
//
//  Created by Dmitry Rodionov on 27/04/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Cocoa;
@import QuartzCore;

@interface BorderPulseLayer : CALayer

+ (instancetype)layerForBorder: (CALayer *)borderLayer;

- (void)pulse;

@end

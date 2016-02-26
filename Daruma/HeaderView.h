//
//  HeaderView.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/19/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface HeaderView : NSView <NSCollectionViewElement>

@property (copy, nonatomic) NSString *title;

+ (NSSize)genericSize;
@end

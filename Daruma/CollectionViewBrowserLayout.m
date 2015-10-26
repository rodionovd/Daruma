//
//  WrappedLayout.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/15/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "CollectionViewBrowserLayout.h"

#define kMinimumInteritemSpacing (20)
#define kMinimumLineSpacing (20)
#define kSectionInset NSEdgeInsetsMake(10, 10, 10, 10)

@implementation CollectionViewBrowserLayout

- (instancetype)init
{
    if ((self = [super init])) {
        [self setMinimumInteritemSpacing: kMinimumInteritemSpacing];
        [self setMinimumLineSpacing: kMinimumLineSpacing];
        [self setSectionInset: kSectionInset];
    }
    return self;
}

- (void)invalidateLayoutUponNotification: (NSNotification *)notification
{
    [self invalidateLayout];
}

@end

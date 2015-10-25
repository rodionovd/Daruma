//
//  FeelsApp.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "App.h"
#import "BrowserCoordinator.h"

@interface App()
@property (strong) BrowserCoordinator *browserCoordinator;
@end

@implementation App

- (instancetype)init
{
    if ((self = [super init])) {
        _browserCoordinator =
            [[BrowserCoordinator alloc] initWithFeelsContainerURL: [self.class defaultFeelsURL]];
    }
    return self;
}

+ (NSURL *)defaultFeelsURL
{
    return [[NSBundle mainBundle] URLForResource: @"Feels" withExtension: @"plist"];
}

- (void)run
{
    [self.browserCoordinator start];
}

@end

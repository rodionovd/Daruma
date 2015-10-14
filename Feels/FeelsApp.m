//
//  FeelsApp.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "FeelsApp.h"
#import "BrowserCoordinator.h"

@interface FeelsApp()
@property (strong) BrowserCoordinator *browserCoordinator;
@end

@implementation FeelsApp

- (instancetype)init
{
    if ((self = [super init])) {
        _browserCoordinator = [[BrowserCoordinator alloc] initWithFeelsContainerURL:
                               [self.class defaultFeelsURL]];
    }
    return self;
}

#warning TODO: copy the default database into Application Support, then use this copy so a user could do changes (add/delete emoticons, assign lables)
+ (NSURL *)defaultFeelsURL
{
    return [[NSBundle mainBundle] URLForResource: @"Feels" withExtension: @"plist"];
}


- (void)run
{
    NSLog(@"App is running!");
    // TODO: setup the coordinator
    [self.browserCoordinator start];
}

@end

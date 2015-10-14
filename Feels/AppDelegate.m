//
//  AppDelegate.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "AppDelegate.h"
#import "FeelsApp.h"

@interface AppDelegate ()
@property (strong) FeelsApp *app;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.app = [FeelsApp new];
    [self.app run];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end

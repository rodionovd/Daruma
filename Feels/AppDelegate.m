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


- (void)sendBrowserWindowShouldAppearNotification
{
    // TOOD: make this string a constant in a separate header file maybe?
    [[NSNotificationCenter defaultCenter] postNotificationName: @"BrowserWindowShouldAppear" object: nil];
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
    self.app = [FeelsApp new];
    [self.app run];
}

- (BOOL)applicationShouldHandleReopen: (NSApplication *)sender hasVisibleWindows: (BOOL)flag
{
    // Make the browser window appear when user clicks on the app's icon in Dock
    [self sendBrowserWindowShouldAppearNotification];
    return YES;
}

- (void)applicationDidBecomeActive: (NSNotification *)notification
{
    // Make the browser window appear when the app gets focus
    [self sendBrowserWindowShouldAppearNotification];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSApplication *)sender
{
    return NO;
}

- (void)applicationWillTerminate: (NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

@end

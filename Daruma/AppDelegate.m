//
//  AppDelegate.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015-2016 Internals Exposed. All rights reserved.
//

#import "AppDelegate.h"
#import "App.h"

@interface AppDelegate ()
@property (strong) App *app;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
    self.app = [App new];
    [self.app run];
}

- (BOOL)applicationShouldHandleReopen: (NSApplication *)sender hasVisibleWindows: (BOOL)flag
{
    [self.app activate];
    return YES;
}

- (void)applicationDidBecomeActive: (NSNotification *)notification
{
    [self.app activate];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSApplication *)sender
{
    return NO;
}

#pragma mark Custom actions

- (IBAction)openAboutPanel: (id)sender
{
    [self.app showAboutPanel];
}

// CMD+F action handler
- (IBAction)performFindPanelAction: (id)sender
{
    [self.app toggleSearch];
}

@end

//
//  AppDelegate.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "AppDelegate.h"
#import "App.h"

@interface AppDelegate ()
@property (strong) App *app;
@end

@implementation AppDelegate

- (void)sendBrowserWindowShouldAppearNotification
{
    // TOOD: make this string a constant in a separate header file maybe?
    [[NSNotificationCenter defaultCenter] postNotificationName: @"BrowserWindowShouldAppear" object: nil];
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
    self.app = [App new];
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

#pragma mark Custom actions

- (IBAction)openAboutPanel:(id)sender
{
    // Load Credits.rtf into memory
    static NSData *RTFData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RTFData = [NSData dataWithContentsOfURL:
                   [[NSBundle mainBundle] URLForResource: @"Credits" withExtension: @"rtf"]];
    });
    NSAssert(RTFData != nil, @"Credits.rtf is missing from the app's bundle!");

    // then replace the "{you}" placeholder with an actual user name
    NSMutableAttributedString *credits = [[NSMutableAttributedString alloc] initWithRTF: RTFData
                                                                     documentAttributes: NULL];
    [credits.mutableString replaceOccurrencesOfString: @"{you}"
                                           withString: NSFullUserName()
                                              options: 0
                                                range: NSMakeRange(0, credits.mutableString.length)];
    // and show the default about panel
    NSDictionary *options = @{
        @"Credits" : credits
    };
    [[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions: options];
}

@end

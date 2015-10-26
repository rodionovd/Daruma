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

- (void)showAboutPanel
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
    NSDictionary *options = @{@"Credits" : credits};
    [[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions: options];
}

@end

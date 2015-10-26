//
//  FeelsApp.h
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

@import Cocoa;

@interface App : NSObject

- (void)run;
/// Shows the About panel with custom Credits inside
- (void)showAboutPanel;
/// Makes the browser window appear
- (void)activate;
/// Moves focus to the search bar
- (void)toggleSearch;

@end

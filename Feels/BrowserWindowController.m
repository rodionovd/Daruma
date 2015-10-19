//
//  BrowserWindowController.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "BrowserWindowController.h"
#import "CollectionViewBrowserLayout.h"

@interface BrowserWindowController ()

@end

@implementation BrowserWindowController

- (instancetype)init
{
    self = [super initWithWindowNibName: @"BrowserWindow"];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(showWindow:)
                                                     name: @"BrowserWindowShouldAppear" object: nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.collectionView.delegate = self.coordinator;
    self.collectionView.dataSource = self.coordinator;
    self.collectionView.collectionViewLayout = [CollectionViewBrowserLayout new];
    // Enable dragging items from the collection view to other apps
    [self.collectionView setDraggingSourceOperationMask: NSDragOperationEvery forLocal: NO];
}

- (IBAction)copy: (id)sender
{
    SEL selector = NSSelectorFromString(@"writeToPasteboardItemsAtIndexPaths:");
    [self.coordinator performSelector: selector
                           withObject: self.collectionView.selectionIndexPaths];
}

- (BOOL)validateMenuItem: (NSMenuItem *)menuItem
{
    // Disable the Copy menu item if the current selection is empty
    if (menuItem.action == NSSelectorFromString(@"copy:")) {
        return self.collectionView.selectionIndexPaths.count != 0;
    }
    return [super validateMenuItem: menuItem];
}


@end

//
//  BrowserWindowController.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "BrowserWindowController.h"
#import "ResponsiveCollectionView.h"
#import "CollectionViewBrowserLayout.h"

@interface BrowserWindowController ()

@end

@implementation BrowserWindowController

- (instancetype)init
{
    if ((self = [super initWithWindowNibName: @"BrowserWindow"])) {
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

    self.searchField.delegate = self;

    self.collectionView.delegate = self.coordinator;
    self.collectionView.dataSource = self.coordinator;
    self.collectionView.collectionViewLayout = [CollectionViewBrowserLayout new];
    // Enable dragging items from the collection view to other apps
    [self.collectionView setDraggingSourceOperationMask: NSDragOperationEvery forLocal: NO];
}

- (void)copy: (id)sender
{
    [self.coordinator writeToPasteboardItemsAtIndexPaths: self.collectionView.selectionIndexPaths];
}

- (BOOL)validateMenuItem: (NSMenuItem *)menuItem
{
    // Disable the Copy menu item if the current selection is empty
    if (menuItem.action == NSSelectorFromString(@"copy:")) {
        return self.collectionView.selectionIndexPaths.count != 0;
    }
    return [super validateMenuItem: menuItem];
}

- (void)insertTab: (id)sender
{
    [self.window selectNextKeyView: sender];
}
- (void)insertBacktab: (id)sender
{
    [self.window selectPreviousKeyView: sender];
}

- (void)controlTextDidChange: (NSNotification *)obj
{
    if (self.searchField.stringValue.length == 0) {
        [self.coordinator searchFieldDidCompleteSearch: obj.object];
    } else {
        [self.coordinator searchField: obj.object
                   didReportPredicate: [(NSSearchField *)obj.object stringValue]];
    }
    [self.collectionView reloadData];
}

- (void)controlTextDidEndEditing: (NSNotification *)obj
{
    if ([[obj.userInfo objectForKey: @"NSTextMovement"] integerValue] == 0) {
        // The (x) button pressed inside a search field, resetting it's state
        return;
    }
    // Move focus to the collection view and select the first item in results
    [(ResponsiveCollectionView *)self.collectionView selectFirstItemAndScrollIfNeeded];
    [self.window selectNextKeyView: nil];
}

@end

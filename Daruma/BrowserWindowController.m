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
#import "NSArray+Stuff.h"

@interface BrowserWindowController ()
@property (strong) CollectionViewBrowserLayout *collectionViewLayout;
@property (strong) NSArray *placeholders;

- (void)_activateSearchField: (NSNotification *)notification;
@end

@implementation BrowserWindowController

- (instancetype)init
{
    if ((self = [super init])) {

        _collectionViewLayout = [CollectionViewBrowserLayout new];

        // Load some (kinda) funny placeholders for the search field
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [[NSBundle mainBundle] URLForResource: @"FunnyPlaceholders"
                                                 withExtension: @"plist"];
            _placeholders = [NSArray arrayWithContentsOfURL: url];
        });

        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(showWindow:)
                                                     name: @"BrowserWindowShouldAppear"
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(_activateSearchField:)
                                                     name: @"BrowserWindowActivateSearchField"
                                                   object: nil];

        // Update the collection view layout on a system-wide scroller style change:
        // a legacy-styled scrollers take a few pixels from a scroll view width for a slot view
        // (and thus reducing this scroll view's contents frame) while overlay-styled ones don't
        [[NSNotificationCenter defaultCenter] addObserver: _collectionViewLayout
                                                 selector: @selector(invalidateLayoutUponNotification:)
                                                     name: NSPreferredScrollerStyleDidChangeNotification
                                                   object: nil];
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"BrowserWindow";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self.collectionViewLayout];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    self.searchField.delegate = self;
    self.searchField.placeholderString = [self.placeholders rd_randomItem];
    [self.coordinator setupSearchFieldBindings: self.searchField];
    // Wait until next (?) run loop iteration; otherwise we'll see no effect
    [self.window performSelector: @selector(makeFirstResponder:)
                      withObject: self.searchField
                      afterDelay: 0.0];

    self.collectionView.delegate = self.coordinator;
    self.collectionView.dataSource = self.coordinator;
    self.collectionView.collectionViewLayout = self.collectionViewLayout;
    // Enable dragging items from the collection view to other apps
    [self.collectionView setDraggingSourceOperationMask: NSDragOperationEvery forLocal: NO];
}

- (void)copy: (id)sender
{
    [self.coordinator writeItemsToPasteboard: self.collectionView.selectionIndexPaths];
}

- (void)reloadCollectionView: (nullable id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (BOOL)validateMenuItem: (NSMenuItem *)menuItem
{
    // Disable the Copy menu item if the current selection is empty
    if (menuItem.action == @selector(copy:)) {
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

- (void)controlTextDidEndEditing: (NSNotification *)obj
{
    if ([[obj.userInfo objectForKey: @"NSTextMovement"] integerValue] != NSReturnTextMovement) {
        // Pick new random placeholder
        self.searchField.placeholderString = [self.placeholders rd_randomItem];
        return;
    }
    // Move focus to the collection view and select the first item in results
    if ([(ResponsiveCollectionView *)self.collectionView selectFirstItemAndScrollIfNeeded]) {
        self.searchField.refusesFirstResponder = YES;
        [self.window selectNextKeyView: nil];
        self.searchField.refusesFirstResponder = NO;
    }
}

#pragma mark - Internal

- (void)_activateSearchField: (NSNotification *)notification
{
    [self.window performSelector: @selector(makeFirstResponder:)
                      withObject: self.searchField
                      afterDelay: 0.0];
}

@end

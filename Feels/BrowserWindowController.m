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
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.collectionView.delegate = self.coordinator;
    self.collectionView.dataSource = self.coordinator;
    self.collectionView.collectionViewLayout = [CollectionViewBrowserLayout new];
    // Enable dragging items from the collection view to other apps
    [self.collectionView setDraggingSourceOperationMask: NSDragOperationEvery forLocal: NO];
    
    // XXX:
    // Add ourselves to the the responder chain in place of a root view (and just before the window),
    // so we'll receive all the missing messages such as copy: or paste:
    NSResponder *responder = self.collectionView.nextResponder;
    while (responder.nextResponder.class != NSView.class) {
        responder = responder.nextResponder;
    }
    responder.nextResponder = self;
}

- (IBAction)copy:(id)sender
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

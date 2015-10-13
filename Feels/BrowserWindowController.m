//
//  BrowserWindowController.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "BrowserWindowController.h"

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
    
    // setup the collection view layout
    NSCollectionViewFlowLayout *layout = [NSCollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(80, 60);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = NSEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView.collectionViewLayout = layout;
    // assign collection view delegate and data source
    self.collectionView.delegate = self.coordinator;
    self.collectionView.dataSource = self.coordinator;
    // set a background view for the collection view???
    #warning What about this background view?
}

@end

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
    
    self.collectionView.delegate = self.coordinator;
    self.collectionView.dataSource = self.coordinator;
    
    self.collectionView.collectionViewLayout = ({
        NSCollectionViewFlowLayout *layout = [NSCollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = NSEdgeInsetsMake(10, 10, 10, 10);
        layout;
    });
}

@end

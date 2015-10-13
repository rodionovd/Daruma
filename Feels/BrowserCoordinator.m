//
//  BrowserCoordinator.m
//  Feels
//
//  Created by Dmitry Rodionov on 10/13/15.
//  Copyright © 2015 Internals Exposed. All rights reserved.
//

#import "BrowserCoordinator.h"
#import "BrowserWindowController.h"
#import "FeelContainer.h"

@interface BrowserCoordinator()
@property (strong) FeelContainer *feelsContainer;
@end

@implementation BrowserCoordinator

- (instancetype)initWithFeelsContainerURL: (NSURL *)containerURL
{
    if ((self = [super init])) {
        _feelsContainer = [[FeelContainer alloc] initWithURL: containerURL];
    }
    return self;
}

- (void)start
{
    NSLog(@"Browser coordinator is here!");
    self.browserWindowController = [BrowserWindowController new];
    self.browserWindowController.coordinator = self;
    [self.browserWindowController showWindow: self];
}

#pragma mark - NSCollectionViewDataSource's

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView
{
    // TODO: we don't have any sections *yet*
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // TODO: we don't have any sections *yet*
    return self.feelsContainer.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSCollectionViewItem *item = [collectionView makeItemWithIdentifier: @"FeelViewItem"
                                                           forIndexPath: indexPath];
    item.representedObject = [self.feelsContainer objectAtIndexPath: indexPath];
    return item;
}

@end

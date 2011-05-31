//
//  SearchViewController.h
//  AppMon
//
//  Created by Chong Francis on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BCCollectionView.h"
#import "AppStoreApi.h"

//  Handle search actions and response
@interface SearchViewController : NSViewController <BCCollectionViewDelegate> {
    AppStoreApi* api;
}

@property (nonatomic, retain) IBOutlet NSView* searchNotFoundView;
@property (nonatomic, retain) IBOutlet NSScrollView* searchScrollView;
@property (nonatomic, retain) IBOutlet NSProgressIndicator* progressIndicator;
@property (nonatomic, retain) IBOutlet NSTextField* txtProgress;
@property (nonatomic, retain) IBOutlet BCCollectionView* searchResultCollectionView;

@property (nonatomic, retain) AppStoreApi* api;

-(void) setNotFound:(BOOL)isNotFound;

-(void) setLoading:(BOOL)isLoading;

-(void) search:(NSString*)query;

@end

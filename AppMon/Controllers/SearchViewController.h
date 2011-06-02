//
//  SearchViewController.h
//  AppMon
//
//  Created by Chong Francis on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JASectionedListView.h"
#import "JAListView.h"
#import "AppStoreApi.h"
#import "AppService.h"

//  Handle search actions and response
@interface SearchViewController : NSViewController <JAListViewDelegate, JASectionedListViewDataSource> {
@private
    BOOL _loading;
    
    NSView* _searchNotFoundView;
    NSScrollView* _searchScrollView;
    NSProgressIndicator* _progressIndicator;
    JASectionedListView* _searchResultList;
    
    AppService* _appService;
    AppStoreApi* _api;
    NSArray* _results;
}

@property (nonatomic, retain) IBOutlet NSView* searchNotFoundView;
@property (nonatomic, retain) IBOutlet NSScrollView* searchScrollView;
@property (nonatomic, retain) IBOutlet NSProgressIndicator* progressIndicator;
@property (nonatomic, retain) IBOutlet JASectionedListView* searchResultList;

@property (nonatomic, retain) AppService* appService;
@property (nonatomic, retain) AppStoreApi* api;
@property (nonatomic, retain) NSArray* results;

-(void) setNotFound:(BOOL)isNotFound;

-(void) setLoading:(BOOL)isLoading;

-(void) search:(NSString*)query;

@end

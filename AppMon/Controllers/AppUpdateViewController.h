//
//  AppUpdateViewController.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JAListView.h"
#import "JASectionedListView.h"

#import "AppService.h"
#import "AppStoreApi.h"
#import "App.h"
#import "LoadingViewItem.h"

@interface AppUpdateViewController : NSViewController <JAListViewDataSource, JAListViewDelegate, AppServiceDelegate> {
@private
    
    AppService* _service;
    
    App* _app;
    NSArray* _reviews;
    
    BOOL _loading;
    BOOL _loaded;
}

@property (nonatomic, retain) IBOutlet NSProgressIndicator* progressView;
@property (nonatomic, retain) IBOutlet JAListView* listUpdates;
@property (nonatomic, retain) App* app;
@property (nonatomic, retain) NSArray* reviews;

-(void) loadAppReviews:(App*)app;

-(void) setLoading:(BOOL)newLoading;

-(void) setLoaded:(BOOL)newLoaded;

@end

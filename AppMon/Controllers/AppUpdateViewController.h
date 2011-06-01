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
#import "Timeline.h"

#import "LoadingViewItem.h"

@interface AppUpdateViewController : NSViewController <JAListViewDataSource, JAListViewDelegate, AppServiceDelegate> {
@private
    
    AppService* _service;
    Timeline* _timeline;

}

@property (nonatomic, retain) IBOutlet NSProgressIndicator* progressView;
@property (nonatomic, retain) IBOutlet JAListView* listUpdates;
@property (nonatomic, retain) Timeline* timeline;

// load app reviews from an app
-(void) loadAppReviews:(App*)app;

// load more app reviews from currently selected app
-(void) loadMoreAppReviews;

-(void) setLoading:(BOOL)newLoading;

-(void) setLoaded:(BOOL)newLoaded;

@end

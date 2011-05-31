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

#import "AppStoreApi.h"
#import "App.h"
#import "LoadingViewItem.h"

@interface AppUpdateViewController : NSViewController <JASectionedListViewDataSource, JAListViewDelegate> {
@private
    AppStoreApi* _api;
    NSArray* _reviews;
    App* _app;
    BOOL _loading;
    BOOL _loaded;
}

@property (nonatomic, retain) IBOutlet JAListView* listUpdates;

-(void) loadAppReviews:(App*)app;

-(void) setLoading:(BOOL)newLoading;

-(void) setLoaded:(BOOL)newLoaded;

@end

//
//  AppListViewController.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "App.h"
#import "JAListView.h"
#import "AppUpdateViewController.h"

// manage the list of all followed apps

@interface AppListViewController : NSViewController <JAListViewDataSource> {
@private
    AppUpdateViewController* _appUpdateViewController;
    JAListView* _listApps;
    AppService* _appService;
    
    NSMutableDictionary* _appViews;
    App* _selectedApp;
}

@property (assign) IBOutlet AppUpdateViewController* appUpdateViewController;
@property (nonatomic, retain) IBOutlet JAListView* listApps;
@property (nonatomic, retain) AppService* appService;
@property (nonatomic, retain) NSMutableDictionary* appViews;
@property (nonatomic, retain) App* selectedApp;

// Update all apps on the app list. 
// param: includeSelectedApp - By default the function update all apps, if this param is NO,
//        it will skip 'selectedApp'
-(void) updateAllApps:(BOOL)includeSelectedApp;

// selected supplied app
-(void) selectApp:(App*)app;

@end

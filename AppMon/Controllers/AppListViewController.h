//
//  AppListViewController.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAListView.h"
#import "AppUpdateViewController.h"

@interface AppListViewController : NSViewController <JAListViewDataSource> {
@private
}

@property (assign) IBOutlet AppUpdateViewController* appUpdateViewController;
@property (nonatomic, retain) IBOutlet JAListView* listApps;
@property (nonatomic, retain) AppService* appService;

@end

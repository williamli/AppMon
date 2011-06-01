//
//  AppListViewController.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppListViewController.h"

#import "AppMonAppDelegate.h"
#import "App.h"
#import "AppListViewCell.h"
#import "AppUpdateViewController.h"

#define kAppListCellReuseIdentifier @"AppListViewCell"

@implementation AppListViewController

@synthesize listApps=_listApps, appUpdateViewController=_appUpdateViewController, appService=_appService;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.listApps.backgroundColor = [NSColor colorWithCalibratedRed:0.855 green:0.875 blue:0.902 alpha:1.];
    self.appService = [AppService sharedAppService];
}

#pragma mark JAListViewDelegate

- (void)listView:(JAListView *)list willSelectView:(JAListViewItem *)view {
    if(list == self.listApps) {
        AppListViewCell* cell = (AppListViewCell *) view;
        cell.selected = YES;
        [self.appUpdateViewController loadAppReviews:cell.app];
    }
}

#pragma mark - JAListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JAListView *)listView {
    NSUInteger count = [[self.appService followedApps] count];
    return count;
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
    App* app = [[self.appService followedApps] objectAtIndex:index];

    AppListViewCell* cell = [AppListViewCell appListViewCell];
    [cell setApp:app];
    return cell;
}

@end

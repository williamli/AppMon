//
//  AppListViewController.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppListViewController.h"
#import "AppService.h"
#import "AppMonAppDelegate.h"
#import "App.h"
#import "AppListViewCell.h"
#import "AppUpdateViewController.h"

#define kAppListCellReuseIdentifier @"AppListViewCell"

@interface AppListViewController (Private)
-(void) appListDidUpdated:(NSNotification*)notification;
-(void) timelineDidUpdated:(NSNotification*)notification;
@end

@implementation AppListViewController

@synthesize listApps=_listApps, appUpdateViewController=_appUpdateViewController, appService=_appService;
@synthesize appViews=_appViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    self.appViews = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appListDidUpdated:) 
                                                 name:AppServiceNotificationAppListChanged 
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timelineDidUpdated:) 
                                                 name:AppServiceNotificationTimelineChanged 
                                               object:nil];

    self.appViews = [NSMutableDictionary dictionary];
    self.listApps.backgroundColor = [NSColor colorWithCalibratedRed:0.855 green:0.875 blue:0.902 alpha:1.];
    self.appService = [AppService sharedAppService];
}

#pragma mark - Private

-(void) appListDidUpdated:(NSNotification*)notification {
    [self.listApps reloadDataAnimated:YES];
}

-(void) timelineDidUpdated:(NSNotification*)notification {
    Timeline* timeline = [notification object];
    if (!timeline) return;
    
    AppListViewCell* cell = [self.appViews objectForKey:timeline.app.itemId];
    if (cell) {
        [cell setUnreadCount:timeline.unread];
    }

    NSLog(@"  timeline updated, update app list view: %@", timeline.app.title);
    
}

#pragma mark JAListViewDelegate

- (void)listView:(JAListView *)list willSelectView:(JAListViewItem *)view {
    if(list == self.listApps) {
        AppListViewCell* cell = (AppListViewCell *) view;
        cell.selected = YES;
        [self.appUpdateViewController loadAppReviews:cell.app];
    }
}

- (void)listView:(JAListView *)list didDeselectView:(JAListViewItem *)view {
    if(list == self.listApps) {
        AppListViewCell* cell = (AppListViewCell *) view;
        Timeline* timeline = [self.appService timelineWithApp:cell.app];
        timeline.unread = 0;
        [cell setUnreadCount:0];
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
    [self.appViews setValue:cell forKey:app.itemId];
    return cell;
}

@end

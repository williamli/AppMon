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
#import "AppMonConfig.h"

#define kAppListCellReuseIdentifier @"AppListViewCell"

@interface AppListViewController (Private)
-(void) appListDidUpdated:(NSNotification*)notification;
-(void) timelineDidUpdated:(NSNotification*)notification;
-(void) followedApp:(NSNotification*)notification;
-(void) resetUnreadCount;
@end

@implementation AppListViewController

@synthesize listApps=_listApps, appUpdateViewController=_appUpdateViewController, appService=_appService;
@synthesize appViews=_appViews;
@synthesize selectedApp=_selectedApp;

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
    self.selectedApp = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unfollowedApp:) 
                                                 name:AppServiceNotificationUnfollowedApp 
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(timelineDidUpdated:) 
                                                 name:AppServiceNotificationTimelineChanged 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeDidChanged:) 
                                                 name:AppServiceNotificationStoreChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(followedApp:) 
                                                 name:AppServiceNotificationFollowedApp
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userReadAppTimeline:) 
                                                 name:AppServiceNotificationReadApp
                                               object:nil];
    
    

    self.appViews = [NSMutableDictionary dictionary];
    self.listApps.backgroundColor = [NSColor colorWithCalibratedRed:0.855 green:0.875 blue:0.902 alpha:1.];
    self.appService = [AppService sharedAppService];
}

-(void) updateAllApps:(BOOL)includeSelectedApp {
    NSArray* allApps = [self.appService followedApps];
    for (App* theApp in allApps) {
        if (!includeSelectedApp && [theApp isEqual:self.selectedApp]) {
            // skipped
        } else {
            [self.appService fetchTimelineWithApp:theApp];
        }
    }
    
    // setup auto refresh
    NSLog(@"auto refresh after %ld minutes", [AppMonConfig sharedAppMonConfig].autoRefreshIntervalMinute);
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self 
                                              selector:@selector(updateAllApps) 
                                                object:nil];
    [self performSelector:@selector(updateAllApps) 
               withObject:nil 
               afterDelay:60*[AppMonConfig sharedAppMonConfig].autoRefreshIntervalMinute];
}
     
-(void) updateAllApps {
    [self updateAllApps:YES];
}

-(void) updateAllAppsExceptSelected {
    [self updateAllApps:NO];
}

-(void) selectApp:(App*)app {
    JAListViewItem* item = [self.appViews objectForKey:app.itemId];
    self.selectedApp = app;
    [self.listApps selectView:item];
    [self.appUpdateViewController loadAppReviews:app];
}

#pragma mark - Private

-(void) followedApp:(NSNotification*)notification {
    [self.listApps reloadDataAnimated:YES];
    
    App* app = [notification object];
    [self.appService fetchTimelineWithApp:app];
}

-(void) unfollowedApp:(NSNotification*)notification {
    [self.listApps reloadDataAnimated:YES];
}

-(void) storeDidChanged:(NSNotification*)notification {
    NSLog(@"store did changed, reset unread count in app list");
    [self resetUnreadCount];
}

-(void) timelineDidUpdated:(NSNotification*)notification {
    Timeline* timeline = [notification object];
    if (!timeline) return;
    
    AppListViewCell* cell = [self.appViews objectForKey:timeline.app.itemId];
    if (cell) {
        [cell setUnreadCount:timeline.unread];
    }
    [cell setNeedsDisplay:YES];
    NSLog(@"  timeline updated, update app list view: %@", timeline.app.title);
    
}

-(void) userReadAppTimeline:(NSNotification*)notification {
    App* app = [notification object];
    AppListViewCell* cell = [self.appViews objectForKey:app.itemId];
    if (cell) {
        [cell setUnreadCount:0];
    }
}

-(void) resetUnreadCount {
    for (AppListViewCell* cell in [self.appViews allValues]) {
        [cell setUnreadCount:0];
        [cell setNeedsDisplay:YES];
    }
}

#pragma mark JAListViewDelegate

- (void)listView:(JAListView *)list willSelectView:(JAListViewItem *)view {
    if(list == self.listApps) {       
        // mark all previously selected app as read
        for (AppListViewCell * item in [list selectedViews]) {
            [self.appService markAppAsRead:item.app];
        }

        // show review lists of selected app
        AppListViewCell* cell = (AppListViewCell *) view;
        if (cell.selected != YES) {
            cell.selected = YES;
            [self.appUpdateViewController loadAppReviews:cell.app];
            self.selectedApp = cell.app;
        }
    }
}

#pragma mark - JAListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JAListView *)listView {
    NSUInteger count = [[self.appService followedApps] count];
    return count;
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
    App* app = [[self.appService followedApps] objectAtIndex:index];
    Timeline* timeline = [self.appService timelineWithApp:app];
    AppListViewCell* cell = [AppListViewCell appListViewCell];
    [cell setApp:app];
    [cell setUnreadCount:timeline.unread];
    [self.appViews setValue:cell forKey:app.itemId];
    return cell;
}

@end

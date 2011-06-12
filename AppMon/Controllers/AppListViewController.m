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
-(void) recalculateTotalUnreadCount;
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

    [self setAutoRefreshTime:0];
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

-(void) setAutoRefreshTime:(NSUInteger)seconds {
    NSLog(@"set auto refresh time: %ld", seconds);
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self 
                                              selector:@selector(updateAllApps) 
                                                object:nil];

    if (seconds > 0) {
        [self performSelector:@selector(updateAllApps) 
                   withObject:nil 
                   afterDelay:seconds];
    }
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
    NSUInteger interval = [AppMonConfig sharedAppMonConfig].autoRefreshIntervalMinute*60;
    NSLog(@"auto refresh after %ld seconds", interval);
    [self setAutoRefreshTime:interval];
}
     
-(void) updateAllApps {
    [self updateAllApps:YES];
}

-(void) updateAllAppsExceptSelected {
    [self updateAllApps:NO];
}

-(void) selectApp:(App*)app {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        JAListViewItem* item = [self.appViews objectForKey:app.itemId];
        item.selected = YES;
        self.selectedApp = app;
        [self.listApps selectView:item];
        [self.appUpdateViewController loadAppReviews:app];
        [pool release];
    });
}

#pragma mark - Notifications

-(void) followedApp:(NSNotification*)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        [self.listApps reloadDataAnimated:YES];
        [pool release];
    });
    
    App* app = [notification object];
    [self.appService fetchTimelineWithApp:app];
}

-(void) unfollowedApp:(NSNotification*)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        App* app = [notification object];
        NSLog(@"unfollowed app: %@", app);

        // select next app if possible, otherwise, select previous app
        // if no other apps, clear the review list
        NSArray* followedApps = [self.appService followedApps];
        if (app) {
            JAListViewItem* item = [self.appViews objectForKey:app.itemId];
            if (item) {
                NSInteger index = [self.listApps indexForView:item];
                JAListViewItem* newItem = nil;
                if (index < [followedApps count]) {
                    newItem = [self.listApps viewAtIndex:index];
                } else if (index > 1) {
                    newItem = [self.listApps viewAtIndex:index-1];
                }
                

                if (newItem) {
                    App* newApp = [(AppListViewCell*)newItem app];
                    [self selectApp:newApp];
                } else {
                    [self.appUpdateViewController unloadReviews];
                }
            } else {
                [self.appUpdateViewController unloadReviews];
            }
        }

        // refresh the app list
        [self.listApps reloadData];
        [pool release];
    });
}

-(void) storeDidChanged:(NSNotification*)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        [self resetUnreadCount];
        [pool release];
    });
}

-(void) timelineDidUpdated:(NSNotification*)notification {
    Timeline* timeline = [notification object];
    if (!timeline) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        AppListViewCell* cell = [self.appViews objectForKey:timeline.app.itemId];
        if (cell) {
            [cell setUnreadCount:timeline.unread];
            [cell setApp:timeline.app timeline:timeline];
        }
        [self recalculateTotalUnreadCount];
        [pool release];
    });
   
}

-(void) userReadAppTimeline:(NSNotification*)notification {
    App* app = [notification object];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        AppListViewCell* cell = [self.appViews objectForKey:app.itemId];
        if (cell) {
            [cell setUnreadCount:0];
        }
        [self recalculateTotalUnreadCount];
        [pool release];
    });
}

#pragma mark - Private

-(void) resetUnreadCount {
    for (AppListViewCell* cell in [self.appViews allValues]) {
        [cell setUnreadCount:0];
        [cell setNeedsDisplay:YES];
    }
    [self recalculateTotalUnreadCount];
}

-(void) recalculateTotalUnreadCount {
    NSInteger unreadCount = [self.appService unreadCount];
    NSDockTile* tile = [NSApp dockTile];
    if (unreadCount > 0) {
        if (![NSApp isActive]) {
            [NSApp requestUserAttention:NSInformationalRequest];
        }
        [tile setBadgeLabel:[NSString stringWithFormat:@"%qi", unreadCount]];        
    } else {
        [tile setBadgeLabel:nil];
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
    [cell setApp:app timeline:timeline];
    [cell setUnreadCount:timeline.unread];
    [self.appViews setValue:cell forKey:app.itemId];
    return cell;
}

@end

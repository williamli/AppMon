//
//  AppService.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "App.h"
#import "Timeline.h"
#import "Store.h"
#import "ReviewResponse.h"

// followed an app
extern NSString * const AppServiceNotificationFollowedApp;

// unfollowed an app
extern NSString * const AppServiceNotificationUnfollowedApp;

// a timeline content or meta data is changed
// the timeline is pass as Object
extern NSString * const AppServiceNotificationTimelineChanged;

// app store is changed
extern NSString * const AppServiceNotificationStoreChanged;

// user read the specific app
extern NSString * const AppServiceNotificationReadApp;


extern NSString * const AppServiceNotificationFetchNoUpdate;
extern NSString * const AppServiceNotificationFetchFinished;
extern NSString * const AppServiceNotificationFetchFailed;

@interface AppService : NSObject {
    NSMutableArray* _apps;
    NSMutableDictionary* _timelines;
    dispatch_queue_t _queue;
    NSArray* _stores;
}

@property (nonatomic, retain) NSArray*  stores;

+ (AppService *)sharedAppService;

-(void) follow:(App*)app;

-(void) unfollow:(App*)app;

-(BOOL) isFollowed:(App*)app;

-(NSArray*) followedApps;

-(NSUInteger) unreadCount;

@end

@interface AppService (Timeline)

// return the timeline object of the app, the object contains downloaded reviews.
// to start download, call fetchTimelineWithApp:
-(Timeline*) timelineWithApp:(App*)app;

// start fetch a specific timeline and check if newer reviews exists
-(void) fetchTimelineWithApp:(App*)app;

// start fetch a specific timeline, optionally download more pages since last fetch
-(void) fetchTimelineWithApp:(App*)app more:(BOOL)loadMore;

// user has READ the timeline of specific app
-(void) markAppAsRead:(App*)app;

@end

@interface AppService (Persistence)

// save app services
-(void) save;

// load app services
-(void) load;

@end

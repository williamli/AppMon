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

// the content of application list is changed
// the AppService is pass as Object
extern NSString * const AppServiceNotificationAppListChanged;

// a timeline content or meta data is changed
// the timeline is pass as Object
extern NSString * const AppServiceNotificationTimelineChanged;

// app store is changed
extern NSString * const AppServiceNotificationStoreChanged;

@protocol AppServiceDelegate

// invoke when timeline is changed
-(void) fetchTimelineFinished:(App*)app timeline:(Timeline*)timeline loadMore:(BOOL)isLoadMore;

// invoke when timeline update has failed
-(void) fetchTimelineFailed:(App*)app timeline:(Timeline*)timeline error:(NSError*)error;

// invoke when timeline has no update
-(void) fetchTimelineNoUpdate:(App*)app timeline:(Timeline*)timeline;

// invoke when timeline reach end
-(void) fetchTimelineNoMore:(App*)app timeline:(Timeline*)timeline;

@end

@interface AppService : NSObject {
    NSMutableArray* _apps;
    NSMutableDictionary* _timelines;
    dispatch_queue_t _queue;
    
    id<AppServiceDelegate, NSObject> _delegate;
    NSString* _store;
}

@property (nonatomic, assign) id<AppServiceDelegate, NSObject> delegate;
@property (nonatomic, retain) NSString* store;

+ (AppService *)sharedAppService;

-(void) follow:(App*)app;

-(void) unfollow:(App*)app;

-(BOOL) isFollowed:(App*)app;

-(NSArray*) followedApps;

@end

@interface AppService (Timeline)

-(void) fetchTimelineWithApp:(App*)app;

-(void) fetchTimelineWithApp:(App*)app more:(BOOL)loadMore;

-(Timeline*) timelineWithApp:(App*)app;

@end

@interface AppService (Persistence)

// save app services
-(void) save;

// load app services
-(void) load;

@end

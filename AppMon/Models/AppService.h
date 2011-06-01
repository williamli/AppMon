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

@protocol AppServiceDelegate

// invoke when timeline is changed
-(void) fetchTimelineFinished:(App*)app timeline:(Timeline*)timeline;

// invoke when timeline update has failed
-(void) fetchTimelineFailed:(App*)app timeline:(Timeline*)timeline error:(NSError*)error;

// invoke when timeline reach end
-(void) fetchTimelineNoMore:(App*)app timeline:(Timeline*)timeline;

@end

@interface AppService : NSObject {   
    NSMutableArray* _apps;
    NSMutableDictionary* _timelines;
}

@property (nonatomic, assign) id<AppServiceDelegate> delegate;

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

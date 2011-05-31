//
//  AppService.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"

@interface AppService : NSObject {   
    NSMutableArray* _apps;
}

-(void) follow:(App*)app;

-(void) unfollow:(App*)app;

-(BOOL) isFollowed:(App*)app;

-(NSArray*) followedApps;

@end

@interface AppService (Persistence)

// save app services
-(void) save;

// load app services
-(void) load;

@end

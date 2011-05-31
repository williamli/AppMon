//
//  AppService.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppService.h"

@implementation AppService

- (id)init
{
    self = [super init];
    if (self) {
        _apps = [[NSMutableArray array] retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_apps release];
    _apps = nil;

    [super dealloc];
}

-(void) follow:(App*)app {
    if (![_apps containsObject:app]) {
        [_apps addObject:app];
    }
}

-(void) unfollow:(App*)app {
    [_apps removeObject:app];
}

-(NSArray*) followedApps {
    return _apps;
}

@end

@implementation AppService (Persistence)

-(void) save {
}

-(void) load {
}

@end

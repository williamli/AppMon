//
//  AppUpdateViewController.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppUpdateViewController.h"


@implementation AppUpdateViewController

@synthesize listUpdates=_listUpdates;

- (id)init
{
    self = [super init];
    if (self) {
        _loading = NO;
        _loaded = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [_app release];
    _app = nil;
    [super dealloc];
}

-(void) loadApp:(App*)app {
    
}

-(void) setLoading:(BOOL)newLoading {
    _loading = newLoading;
    _loaded = !newLoading;
}

-(void) setLoaded:(BOOL)newLoaded {
    _loaded = newLoaded;
    _loading = !newLoaded;
}

@end

//
//  AppMonAppDelegate.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonAppDelegate.h"

@implementation AppMonAppDelegate

@synthesize window, mainController;
@synthesize appService;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.appService = [[[AppService alloc] init] autorelease];
    
    window.titleBarHeight = 45.0;
    [window.titleBarView addSubview:mainController.titleBar];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    self.appService = nil;
}

+(AppMonAppDelegate*) instance {
    return (AppMonAppDelegate*) [NSApplication sharedApplication].delegate;
}

@end

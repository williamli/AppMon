//
//  AppMonAppDelegate.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonAppDelegate.h"
#import "AppService.h"
#import "AppStoreApi.h"

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@implementation AppMonAppDelegate

@synthesize window, mainController;
@synthesize appStoreApi;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];

    [self.mainController.appListViewController.listApps reloadData];

    window.titleBarHeight = 45.0;
    [window.titleBarView addSubview:mainController.titleBar];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    self.appStoreApi = nil;
}

- (void) windowDidResize:(NSNotification *)notification {
    [self.mainController.appUpdateViewController.listUpdates reloadDataAnimated:YES];
}

+(AppMonAppDelegate*) instance {
    return (AppMonAppDelegate*) [NSApplication sharedApplication].delegate;
}

@end

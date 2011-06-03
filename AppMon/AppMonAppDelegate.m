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

@synthesize window, mainController, configController;
@synthesize appStoreApi;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    window.titleBarHeight = 45.0;
    [window.titleBarView addSubview:mainController.titleBar];
    
    [self.mainController.appListViewController.listApps reloadData];
    NSArray* apps = [[AppService sharedAppService] followedApps];
    if ([apps count] > 0) {
        [self.mainController.appListViewController selectApp:[apps objectAtIndex:0]];
        [self.mainController.appListViewController updateAllApps:NO];
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    self.appStoreApi = nil;
}

- (void) windowDidResize:(NSNotification *)notification {
    [self.mainController.appUpdateViewController.listUpdates reloadDataAnimated:YES];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.window makeKeyAndOrderFront:self];
    return YES;
}

-(IBAction) showConfigurationScreen:(id)sender {
    NSLog(@"show config: %@ %@", self.configController, self.configController.window);
    [self.configController.window makeKeyAndOrderFront:self];
}

+(AppMonAppDelegate*) instance {
    return (AppMonAppDelegate*) [NSApplication sharedApplication].delegate;
}

@end

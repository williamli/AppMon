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
#import "SDImageCache.h"

@implementation AppMonAppDelegate

@synthesize window, mainController, configController;
@synthesize appStoreApi;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // setup cache
    ASIDownloadCache* cache = [ASIDownloadCache sharedCache];
    SDImageCache* imageCache = [SDImageCache sharedImageCache];
    NSString* cachePath = [AppMonAppDelegate cachePath];
    [cache setStoragePath:cachePath];
    [imageCache setDiskCachePath:cachePath];
    [ASIHTTPRequest setDefaultCache:cache];

    window.titleBarHeight = 45.0;
    [window.titleBarView addSubview:mainController.titleBar];
    
    [self.mainController.appListViewController.listApps reloadData];
    NSArray* apps = [[AppService sharedAppService] followedApps];
    if ([apps count] > 0) {
        [self.mainController.appListViewController selectApp:[apps objectAtIndex:0]];
        [self.mainController.appListViewController performSelector:@selector(updateAllAppsExceptSelected) 
                                                        withObject:nil
                                                        afterDelay:1.0];
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

+(NSString*) cachePath {
    NSBundle* bundle = [NSBundle mainBundle];
    NSDictionary* info = [bundle infoDictionary];
    NSString* bundleName = [info objectForKey:@"CFBundleName"];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true);
    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSError* error = nil;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"ERROR: Cannot create config file path: %@, error=%@", path, error);
            return nil;
        }
    }
    return path;   
}
@end

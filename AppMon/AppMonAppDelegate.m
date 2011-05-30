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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    window.titleBarHeight = 45.0;
    [window.titleBarView addSubview:mainController.titleBar];
}

@end

//
//  AppMonAppDelegate.h
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppMonMainController.h"
#import "INAppStoreWindow.h"

#import "AppMonConfigWindowController.h"
#import "AppService.h"
#import "AppStoreApi.h"

@interface AppMonAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
@private
    INAppStoreWindow *window;
    
    AppStoreApi* appStoreApi;
    AppMonMainController* mainController;
    AppMonConfigWindowController* configController;
}

@property (nonatomic, retain) AppStoreApi* appStoreApi;

@property (assign) IBOutlet INAppStoreWindow *window;
@property (retain) IBOutlet AppMonMainController* mainController;
@property (retain) IBOutlet AppMonConfigWindowController* configController;

+(AppMonAppDelegate*) instance;

-(IBAction) showConfigurationScreen:(id)sender;

@end

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

@interface AppMonAppDelegate : NSObject <NSApplicationDelegate> {
@private
    INAppStoreWindow *window;
}

@property (assign) IBOutlet INAppStoreWindow *window;
@property (retain) IBOutlet AppMonMainController* mainController;

@end

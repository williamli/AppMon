//
//  AppMonConfigWindowController.h
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAListView.h"

@interface AppMonConfigWindowController : NSWindowController {
@private
    NSWindow*           window;
    NSPopUpButton*      popAutoRefresh;
    JAListView*         listCountries;
}

@property (nonatomic, retain) IBOutlet NSWindow* window;
@property (nonatomic, retain) IBOutlet NSPopUpButton* popAutoRefresh;
@property (nonatomic, retain) IBOutlet JAListView* listCountries;

@end

//
//  AppMonConfigWindowController.h
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAListView.h"
#import "CountryListItem.h"

@interface AppMonConfigWindowController : NSObject <JAListViewDataSource, JAListViewDelegate> {
@private
    NSWindow*           window;
    NSPopUpButton*      popAutoRefresh;
    JAListView*         listCountries;
    
    NSDictionary*       countries;
    NSArray*            countriesList;
}

@property (nonatomic, retain) IBOutlet NSWindow* window;
@property (nonatomic, retain) IBOutlet NSPopUpButton* popAutoRefresh;
@property (nonatomic, retain) IBOutlet JAListView* listCountries;
@property (nonatomic, retain) NSDictionary* countries;
@property (nonatomic, retain) NSArray* countriesList;

@end

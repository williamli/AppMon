//
//  AppMonConfigWindowController.h
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAListView.h"
#import "JASectionedListView.h"
#import "CountryListItem.h"

@interface AppMonConfigWindowController : NSObject <JASectionedListViewDataSource, JAListViewDelegate> {
@private
    NSWindow*           window;
    NSPopUpButton*      popAutoRefresh;
    JASectionedListView* listCountries;
}

@property (nonatomic, retain) IBOutlet NSWindow* window;
@property (nonatomic, retain) IBOutlet NSPopUpButton* popAutoRefresh;
@property (nonatomic, retain) IBOutlet JASectionedListView* listCountries;

-(IBAction) clickedItemCheckbox:(id)sender;
-(IBAction) clickedHeaderCheckbox:(id)sender;
-(IBAction) clickedHeader:(id)sender;
-(IBAction) changedRefreshTime:(id)sender;

@end

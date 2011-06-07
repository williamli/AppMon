//
//  AppMonMainController.h
//  AppMon
//
//  Created by Chong Francis on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SearchViewController.h"
#import "AppListViewController.h"
#import "AppUpdateViewController.h"

//  Top level controller that handle main window logic, it delegate jobs to underlying 
//  controllers (SearchViewController, AppListViewController)
@interface AppMonMainController : NSViewController <NSSplitViewDelegate> {
@private    
    NSView* _titleBar;
    NSSearchField* _searchField;
    NSPopUpButton* _btnCountry;
    NSMenu* _menuCountry;
    
    NSView* _searchView;
    NSSplitView* _splitView;
    
    SearchViewController* _searchController;
    AppListViewController* _appListViewController;
    AppUpdateViewController* _appUpdateViewController;
}

@property (nonatomic, retain) IBOutlet NSView*          titleBar;
@property (nonatomic, retain) IBOutlet NSSearchField*   searchField;
@property (nonatomic, retain) IBOutlet NSPopUpButton*   btnCountry;
@property (nonatomic, retain) IBOutlet NSMenu*          menuCountry;

@property (nonatomic, retain) IBOutlet NSView*          searchView;
@property (nonatomic, retain) IBOutlet NSSplitView*     splitView;

@property (nonatomic, retain) IBOutlet SearchViewController* searchController;
@property (nonatomic, retain) IBOutlet AppListViewController* appListViewController;
@property (nonatomic, retain) IBOutlet AppUpdateViewController* appUpdateViewController;

// begin search app store using text in searchField
-(IBAction) performSearch:(id)sender;

// Set if search mode enabled
-(void) setSearchModeEnabled:(BOOL)searchViewEnabled;

@end

//
//  AppMonMainController.h
//  AppMon
//
//  Created by Chong Francis on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppMonMainController : NSViewController <NSSplitViewDelegate> {
@private
    
}

@property (nonatomic, retain) IBOutlet NSView* titleBar;
@property (nonatomic, retain) IBOutlet NSSearchField* searchField;

@property (nonatomic, retain) IBOutlet NSView* searchView;
@property (nonatomic, retain) IBOutlet NSSplitView* splitView;

// begin search app store using text in searchField
-(IBAction) performSearch:(id)sender;

// Set if search mode enabled
-(void) setSearchModeEnabled:(BOOL)searchViewEnabled;

@end

//
//  AppMonMainController.m
//  AppMon
//
//  Created by Chong Francis on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonMainController.h"
#import "AppMonAppDelegate.h"
#import "AppMonConfig.h"

@interface AppMonMainController (Private)
@end

@implementation AppMonMainController

@synthesize titleBar=_titleBar, searchField=_searchField;
@synthesize searchView=_searchView, splitView=_splitView;

@synthesize searchController=_searchController;
@synthesize appListViewController=_appListViewController;
@synthesize appUpdateViewController=_appUpdateViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectSearch:) 
                                                 name:AppMonSearchEvent
                                               object:nil];
    
    
}


#pragma mark - Public

-(IBAction) performSearch:(id)sender {
    NSString* query = [_searchField stringValue];
    if ([query isEqualToString:@""]) {
        NSLog(@"Clear Text");
        [self setSearchModeEnabled:NO];

    } else {
        NSLog(@"Perform Search");
        [self setSearchModeEnabled:YES];
        [self.searchController search:query];
    }
}

-(IBAction) selectSearch:(id)sender {
    [_searchField becomeFirstResponder];
}

-(void) setSearchModeEnabled:(BOOL)searchViewEnabled {
    [self.searchView setHidden:!searchViewEnabled];
    [self.splitView setHidden:searchViewEnabled];
    
    if (searchViewEnabled) {
        [self.searchController setLoading:YES];
    } else {
        [self.appListViewController.listApps reloadData];
    }
}

#pragma mark - NSSplitViewDelegate

-(void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize: (NSSize)oldSize {
    CGFloat dividerThickness = [sender dividerThickness];
    NSRect leftRect = [[[sender subviews] objectAtIndex:0] frame];
    NSRect rightRect = [[[sender subviews] objectAtIndex:1] frame];
    NSRect newFrame = [sender frame];

	leftRect.size.height = newFrame.size.height;
	leftRect.origin = NSMakePoint(0, 0);
	rightRect.size.width = newFrame.size.width - leftRect.size.width - dividerThickness;
	rightRect.size.height = newFrame.size.height;
	rightRect.origin.x = leftRect.size.width + dividerThickness;

	[[[sender subviews] objectAtIndex:0] setFrame:leftRect];
	[[[sender subviews] objectAtIndex:1] setFrame:rightRect];
}


@end

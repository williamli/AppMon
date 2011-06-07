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
-(void) loadConfig;
-(void) countryMenuClicked:(id)sender;
@end

@implementation AppMonMainController

@synthesize titleBar=_titleBar, searchField=_searchField;
@synthesize menuCountry=_menuCountry, btnCountry=_btnCountry;
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
    
    [self loadConfig];
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

// load configuration
-(void) loadConfig {
    AppMonConfig* config = [AppMonConfig sharedAppMonConfig];
    [config load];
    
    NSString* selectedCountry = [config selectedCountry];
    NSString* selectedCode = [config selectedCountryCode];
    for (NSMenuItem* menuItem in [self.menuCountry itemArray]) {
        if ([[menuItem title] isEqualToString:selectedCountry]) {
            [menuItem setState:NSOnState];
            [self.btnCountry selectItem:menuItem];
        } else {
            [menuItem setState:NSOffState];   
        }
    }
    [[AppService sharedAppService] setStore:selectedCode];
}

#pragma mark - Action

-(void) countryMenuClicked:(id)sender {
    NSString* country = [sender title];
    AppMonConfig* config = [AppMonConfig sharedAppMonConfig];
    Store* store = [[config allCountries] objectForKey:country];
    [[AppService sharedAppService] setStore:store.storefront];
    
    [config setSelectedCountry:store.name];
    [config setSelectedCountryCode:store.storefront];
    [config save];
}

@end

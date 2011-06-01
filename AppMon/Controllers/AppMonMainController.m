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
-(void) buildMenu;

-(void) loadConfig;
-(void) countryMenuClicked:(id)sender;
@end

@implementation AppMonMainController

@synthesize titleBar, searchField;
@synthesize menuCountry, btnCountry;
@synthesize searchView, splitView;

@synthesize searchController;
@synthesize appListViewController;
@synthesize appUpdateViewController;

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
    
    [self buildMenu];
    [self loadConfig];
}


#pragma mark - Public

-(IBAction) performSearch:(id)sender {
    NSString* query = [searchField stringValue];
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

#pragma mark - Private
-(void) buildMenu {
    // remove existing menu items
    [self.menuCountry removeAllItems];
    
    // open country config file, read country lists
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"country" 
                                                         ofType:@"plist"];

    NSDictionary* configCountries = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSMutableDictionary* countries = [NSMutableDictionary dictionary];

    // build a menu and a name->storeid dictionary based on country list
    NSArray* sortedCountries = [[configCountries allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString* countryName in sortedCountries) {
        NSDictionary* countrySetting = [configCountries objectForKey:countryName];
        NSString* storeFront = [countrySetting objectForKey:@"id"];
        NSString* iconName = [countrySetting objectForKey:@"image"];

        NSMenuItem* item = [[[NSMenuItem alloc] initWithTitle:countryName
                                                       action:@selector(countryMenuClicked:) 
                                                keyEquivalent:@""] autorelease];
        [item setTarget:self];
        [item setImage:[NSImage imageNamed:iconName]];
        [item setEnabled:YES];        
        [self.menuCountry addItem:item];
        
        [countries setValue:storeFront forKey:countryName];
    }

    [_countries release];
    _countries = [countries retain];
    
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
    NSString* countryCode = [_countries objectForKey:[sender title]];
    NSLog(@"country selected: %@, countryCode: %@", country, countryCode);

    [[AppService sharedAppService] setStore:countryCode];
}

@end

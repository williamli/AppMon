//
//  AppMonConfigWindowController.m
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonConfigWindowController.h"
#import "CountryListHeaderItem.h"
#import "CountryListItem.h"

#import "JASectionedListView.h"

@interface AppMonConfigWindowController (Private)
-(NSString*) keyForCode:(NSString*)countryCode;
@end

@implementation AppMonConfigWindowController

@synthesize window, popAutoRefresh, listCountries, countries, topCountries, countriesInfo;

- (void)dealloc
{
    self.countriesInfo = nil;
    self.countries = nil;
    self.topCountries = nil;
    
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];

    self.listCountries.backgroundColor = [NSColor whiteColor];

    // open country config file, read country lists
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"country" 
                                                         ofType:@"plist"];
    self.topCountries = [NSArray arrayWithObjects:@"United States", @"United Kingdom", @"Canada", @"Deutschland",
                         @"España", @"France", @"Australia", @"日本", nil];
    
    self.countriesInfo = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray* baseCountryList = [[self.countriesInfo allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray* workingCountriesList = [NSMutableArray arrayWithArray:baseCountryList];
    for (NSString* topCountry in self.topCountries) {
        [workingCountriesList removeObject:topCountry];
    }
    self.countries = workingCountriesList;
    [self.listCountries reloadData];
}

#pragma mark - JASectionedListViewDataSource
- (NSUInteger)numberOfSectionsInListView:(JASectionedListView *)listView {
    return 3;
}

- (NSUInteger)listView:(JASectionedListView *)listView numberOfViewsInSection:(NSUInteger)section {
    switch (section) {
        case 0:
            return 0;
        case 1:
            return [self.topCountries count];
        case 2:
            return [self.countries count];
        default:
            return 0;
    }
}

- (JAListViewItem *)listView:(JAListView *)listView sectionHeaderViewForSection:(NSUInteger)section {
    CountryListHeaderItem* header = [CountryListHeaderItem item];
    NSUserDefaults* setting = [NSUserDefaults standardUserDefaults];
    switch (section) {
        case 0:
            [header.lblHeader setStringValue:@"All Country"];
            [header.lblHeader setTag:0];
            [header.btnCheckbox setAction:@selector(clickedHeaderCheckbox:)];
            [header.btnCheckbox setTarget:self];
            [header.btnCheckbox setState:[setting boolForKey:@"appstore.enabled.all"]? NSOnState : NSOffState];
            break;
        case 1:
            [header.lblHeader setStringValue:@"Top Countries"];
            [header.lblHeader setTag:1];
            [header.btnCheckbox setAction:@selector(clickedHeaderCheckbox:)];
            [header.btnCheckbox setTarget:self];
            [header.btnCheckbox setState:[setting boolForKey:@"appstore.enabled.top"] ? NSOnState : NSOffState];
            break;
        case 2:
            [header.lblHeader setStringValue:@"Other Countries"];
            [header.lblHeader setTag:2];
            [header.btnCheckbox setAction:@selector(clickedHeaderCheckbox:)];
            [header.btnCheckbox setTarget:self];
            [header.btnCheckbox setState:[setting boolForKey:@"appstore.enabled.others"]? NSOnState : NSOffState];
            break;
        default:
            break;
    }
    return header;
}

- (JAListViewItem *)listView:(JAListView *)listView viewForSection:(NSUInteger)section index:(NSUInteger)index {
    NSString* countryName = nil;
    NSString* iconName = nil;
    NSString* countryCode = nil;

    switch (section) {
        case 0:
            return nil;
        case 1:
            countryName = [self.topCountries objectAtIndex:index];
            iconName = [[self.countriesInfo objectForKey:countryName] objectForKey:@"image"];
            countryCode = [[self.countriesInfo objectForKey:countryName] objectForKey:@"id"];
            break;
        case 2:
            countryName = [self.countries objectAtIndex:index];
            iconName = [[self.countriesInfo objectForKey:countryName] objectForKey:@"image"];
            countryCode = [[self.countriesInfo objectForKey:countryName] objectForKey:@"id"];
            break;
        default:
            break;
    }

    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    NSString* key = [self keyForCode:countryCode];
    BOOL selected = [settings boolForKey:key];
    CountryListItem* item = [CountryListItem item];
    [item setCountryName:countryName];
    [item setFlagName:iconName];
    [item.btnCheckbox setTag:section];
    [item.btnCheckbox setState:(selected? NSOnState : NSOffState)]; 
    [item.btnCheckbox setAction:@selector(clickedItemCheckbox:)];
    [item.btnCheckbox setTarget:self];
    return item;
}

#pragma mark - JAListViewDelegate

- (void)listView:(JAListView *)listView didSelectView:(JAListViewItem *)view {
    if ([view isMemberOfClass:[CountryListHeaderItem class]]) {
        [self clickedHeader:view];

    } else if ([view isMemberOfClass:[CountryListItem class]]) {
        CountryListItem* item = (CountryListItem*) view;
        BOOL selected = ([item.btnCheckbox state] == NSOnState);

        if (selected) {
            [item.btnCheckbox setState:NSOffState];
        } else {
            [item.btnCheckbox setState:NSOnState];        
        }

        [self clickedItemCheckbox:item.btnCheckbox];
    }
}

-(NSString*) keyForCode:(NSString*)countryCode {
    return [NSString stringWithFormat:@"appstore.enabled.%@", countryCode];
}

-(IBAction) clickedItemCheckbox:(id)sender {
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    NSButton* btnCheckbox = (NSButton*) sender;
    CountryListItem* item = (CountryListItem*) [btnCheckbox superview];
    BOOL selected = ([btnCheckbox state] == NSOnState);
    NSString* countryName = [item.lblCountry stringValue];
    NSString* countryCode = [[self.countriesInfo objectForKey:countryName] objectForKey:@"id"];
    NSString* key = [self keyForCode:countryCode];
    [settings setBool:selected forKey:key];
    [settings synchronize];
}


-(IBAction) clickedHeaderCheckbox:(id)sender {
    CountryListHeaderItem* header = (CountryListHeaderItem*) [sender superview];
    [self clickedHeader:header];
}

-(IBAction) clickedHeader:(id)sender {
    CountryListHeaderItem* header = (CountryListHeaderItem*) sender;
    NSInteger section = [header.lblHeader tag];
    BOOL selected = ([header.btnCheckbox state] == NSOnState);
    
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    if (section == 0) {
        [settings setBool:selected forKey:@"appstore.enabled.all"];
        [settings setBool:selected forKey:@"appstore.enabled.top"];
        [settings setBool:selected forKey:@"appstore.enabled.others"];
        NSArray* allCountries = [self.countriesInfo allKeys];
        for (NSString* countryName in allCountries) {
            NSString* countryCode = [[self.countriesInfo objectForKey:countryName] objectForKey:@"id"];
            NSString* key = [self keyForCode:countryCode];            
            [settings setBool:selected
                       forKey:key];
        }
    } else if (section == 1) {
        [settings setBool:selected forKey:@"appstore.enabled.top"];
        
        for (NSString* countryName in self.topCountries) {
            NSString* countryCode = [[self.countriesInfo objectForKey:countryName] objectForKey:@"id"];
            NSString* key = [self keyForCode:countryCode];            
            [settings setBool:selected
                       forKey:key];
        }
    } else if (section == 2) {
        [settings setBool:selected forKey:@"appstore.enabled.others"];

        for (NSString* countryName in self.countries) {
            NSString* countryCode = [[self.countriesInfo objectForKey:countryName] objectForKey:@"id"];
            NSString* key = [self keyForCode:countryCode];            
            [settings setBool:selected
                       forKey:key];
        }
    }
    
    [settings synchronize];
    
    [self.listCountries reloadData];

}

@end

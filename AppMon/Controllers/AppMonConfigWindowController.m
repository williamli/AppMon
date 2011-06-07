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
#import "AppMonConfig.h"
#import "Store.h"

@interface AppMonConfigWindowController (Private)
@end

@implementation AppMonConfigWindowController

@synthesize window, popAutoRefresh, listCountries;

- (void)dealloc
{    
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.listCountries.backgroundColor  = [NSColor whiteColor];

    AppMonConfig* config = [AppMonConfig sharedAppMonConfig];
    [config load];

    [self.listCountries reloadData];
}

#pragma mark - JASectionedListViewDataSource
- (NSUInteger)numberOfSectionsInListView:(JASectionedListView *)listView {
    return 3;
}

- (NSUInteger)listView:(JASectionedListView *)listView numberOfViewsInSection:(NSUInteger)section {
    AppMonConfig* config = [AppMonConfig sharedAppMonConfig];
    switch (section) {
        case 0:
            return 0;
        case 1:
            return [[config topCountryNames] count];
        case 2:
            return [[config othersCountyNames] count];
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
    Store* store = nil;
    NSString* countryName = nil;
    AppMonConfig* config = [AppMonConfig sharedAppMonConfig];

    switch (section) {
        case 0:
            return nil;
        case 1:
            countryName = [[config topCountryNames] objectAtIndex:index];
            store = [[config topCountries] objectForKey:countryName];
            break;
        case 2:
            countryName = [[config othersCountyNames] objectAtIndex:index];
            store = [[config topCountries]  objectForKey:countryName];
            break;
        default:
            break;
    }

    BOOL selected = [config storeEnabledWithCountryName:countryName];
    CountryListItem* item = [CountryListItem item];
    [item setCountryName:countryName];
    [item setFlagName:store.code];
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

-(IBAction) clickedItemCheckbox:(id)sender {
    NSButton* btnCheckbox = (NSButton*) sender;
    CountryListItem* item = (CountryListItem*) [btnCheckbox superview];
    BOOL selected = ([btnCheckbox state] == NSOnState);
    NSString* countryName = [item.lblCountry stringValue];
    
    AppMonConfig* config = [AppMonConfig sharedAppMonConfig];
    [config setStoreEnabled:selected withCountryName:countryName];    
    if (!selected) {
        [config setAllStoresSelected:NO];
        if ([btnCheckbox tag] == 1) {
            [config setTopStoresSelected:NO];
        } else if ([btnCheckbox tag] == 2) {
            [config setOtherStoresSelected:NO];
        }
        [self.listCountries reloadData];
    }
}


-(IBAction) clickedHeaderCheckbox:(id)sender {
    CountryListHeaderItem* header = (CountryListHeaderItem*) [sender superview];
    [self clickedHeader:header];
}

-(IBAction) clickedHeader:(id)sender {
    CountryListHeaderItem* header = (CountryListHeaderItem*) sender;
    NSInteger section = [header.lblHeader tag];
    BOOL selected = ([header.btnCheckbox state] == NSOnState);

    AppMonConfig* config = [AppMonConfig sharedAppMonConfig];
    if (section == 0) {
        [config setAllStoresSelected:selected];
        [config setTopStoresSelected:selected];
        [config setOtherStoresSelected:selected];
        for (NSString* countryName in [config allCountryNames]) {
            [config setStoreEnabled:selected 
                    withCountryName:countryName];
        }
    } else if (section == 1) {
        [config setTopStoresSelected:selected];
        for (NSString* countryName in [config topCountryNames]) {
            [config setStoreEnabled:selected 
                    withCountryName:countryName];

        }
    } else if (section == 2) {
        [config setOtherStoresSelected:selected];
        for (NSString* countryName in [config othersCountyNames]) {
            [config setStoreEnabled:selected 
                    withCountryName:countryName];
        }
    }
    [self.listCountries reloadData];

}

@end

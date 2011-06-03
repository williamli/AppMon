//
//  AppMonConfigWindowController.m
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonConfigWindowController.h"

#import "CountryListItem.h"

@implementation AppMonConfigWindowController

@synthesize window, popAutoRefresh, listCountries, countries, countriesList;

- (void)dealloc
{
    self.countriesList = nil;
    self.countries = nil;
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.listCountries.backgroundColor = [NSColor whiteColor];

    // open country config file, read country lists
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"country" 
                                                         ofType:@"plist"];

    self.countries = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.countriesList = [[self.countries allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.listCountries reloadData];
}

#pragma mark - JAListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JAListView *)listView {
    return [self.countriesList count];
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
    NSString* countryName = [self.countriesList objectAtIndex:index];
    NSString* iconName = [[self.countries objectForKey:countryName] objectForKey:@"image"];

    CountryListItem* item = [CountryListItem item];
    [item setCountryName:countryName];
    [item setFlagName:iconName];
    return item;
}

#pragma mark - JAListViewDelegate

- (void)listView:(JAListView *)listView didSelectView:(JAListViewItem *)view {
    CountryListItem* item = (CountryListItem*) view;
    if ([item.btnCheckbox state] == NSOnState) {
        [item.btnCheckbox setState:NSOffState];
    } else {
        [item.btnCheckbox setState:NSOnState];        
    }
}

@end

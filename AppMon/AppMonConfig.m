//
//  AppMonConfig.m
//  AppMon
//
//  Created by Chong Francis on 11年6月1日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonConfig.h"
#import "SynthesizeSingleton.h"
#import "Store.h"

#define kAppStoreEnabledAllKey @"appstore.enabled.all"
#define kAppStoreEnabledTopKey @"appstore.enabled.top"
#define kAppStoreEnabledOthersKey @"appstore.enabled.others"

@interface AppMonConfig (Private)
-(void) loadCountries;
@end

@implementation AppMonConfig

@synthesize selectedCountry=_selectedCountry, selectedCountryCode=_selectedCountryCode, autoRefreshIntervalMinute=_autoRefreshIntervalMinute;
@synthesize allCountries=_allCountries, topCountries=_topCountries, othersCountries=_othersCountries;
@synthesize allCountryNames=_allCountryNames, topCountryNames=_topCountryNames, othersCountyNames=_othersCountyNames;

SYNTHESIZE_SINGLETON_FOR_CLASS(AppMonConfig);

- (id)init
{
    self = [super init];
    if (self) {
        self.autoRefreshIntervalMinute = 5;
    }
    
    return self;
}

- (void)dealloc
{
    self.topCountries = nil;
    self.allCountries = nil;
    self.othersCountries = nil;
    self.topCountryNames = nil;
    self.allCountryNames = nil;
    self.othersCountyNames = nil;
    self.selectedCountry = nil;
    self.selectedCountryCode = nil;
    [super dealloc];
}

#pragma mark - Stores

-(NSDictionary*) allCountries {
    return _allCountries;
}

-(NSDictionary*) topCountries {
    return _topCountries;
}

-(NSDictionary*) othersCountries {
    return _othersCountries;
}

-(NSArray*) allCountryNames {
    return _allCountryNames;
}

-(NSArray*) topCountryNames {
    return _topCountryNames;
}

-(NSArray*) othersCountryNames {
    return _othersCountyNames;
}

-(NSArray*) enabledStores {
    NSMutableArray* array = [NSMutableArray array];
    
    for (NSString* name in self.allCountryNames) {
        if ([self storeEnabledWithCountryName:name]) {
            Store* store = [self.allCountries objectForKey:name];
            [array addObject:store];
        }
    }
    
    return array;
}

-(BOOL) storeEnabledWithCountryName:(NSString*)countryName {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    Store* store = [self.allCountries objectForKey:countryName];
    NSString* key = [store key];
    return [[defaults objectForKey:key] boolValue];
}

-(void) setStoreEnabled:(BOOL)enabled withCountryName:(NSString*)countryName {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    Store* store = [self.allCountries objectForKey:countryName];
    NSString* key = [store key];
    [defaults setBool:enabled forKey:key];
    [defaults synchronize];
}

-(void) setAllStoresSelected:(BOOL)allStoresSelected {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:allStoresSelected forKey:kAppStoreEnabledAllKey];
    [defaults synchronize];
}

-(void) setTopStoresSelected:(BOOL)topStoresSelected {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:topStoresSelected forKey:kAppStoreEnabledTopKey];
    [defaults synchronize];
}

-(void) setOtherStoresSelected:(BOOL)othersStoresSelected {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:othersStoresSelected forKey:kAppStoreEnabledOthersKey];
    [defaults synchronize];
}

-(BOOL) allStoresSelected {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:kAppStoreEnabledAllKey] boolValue];
}

-(BOOL) topStoresSelected {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:kAppStoreEnabledTopKey] boolValue];
}

-(BOOL) otherStoresSelected {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:kAppStoreEnabledOthersKey] boolValue];
}

#pragma Save/Load

-(AppMonConfig*) save {
    NSUserDefaults* setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:self.selectedCountry forKey:@"selectedCountry"];
    [setting setObject:self.selectedCountryCode forKey:@"selectedCountryCode"];
    [setting setInteger:self.autoRefreshIntervalMinute forKey:@"autoRefreshIntervalMinute"];
    [setting synchronize];
    return self;
}

-(AppMonConfig*) load {
    [self loadCountries];

    NSUserDefaults* setting = [NSUserDefaults standardUserDefaults];
    self.selectedCountry = [setting objectForKey:@"selectedCountry"];
    self.selectedCountryCode = [setting objectForKey:@"selectedCountryCode"];
    self.autoRefreshIntervalMinute = [setting integerForKey:@"autoRefreshIntervalMinute"];

    if (!self.selectedCountry) {
        self.selectedCountry = @"United States";
    }
    
    if (!self.selectedCountryCode) {
        self.selectedCountryCode = @"143441";
    }

    if (self.autoRefreshIntervalMinute <= 0) {
        self.autoRefreshIntervalMinute = 5;
    }

    return self;
}

#pragma mark - Private

-(void) loadCountries {
    // open country config file, read country lists
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"country" 
                                                         ofType:@"plist"];
    
    NSDictionary* configCountries = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSMutableDictionary* allCountries = [NSMutableDictionary dictionary];
    NSMutableDictionary* topCountries = [NSMutableDictionary dictionary];
    NSMutableDictionary* othersCountries = [NSMutableDictionary dictionary];
    NSMutableArray* othersCountryNames = [NSMutableArray array];
    
    // build all country list
    NSArray* sortedCountries = [[configCountries allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString* countryName in sortedCountries) {
        NSDictionary* countrySetting = [configCountries objectForKey:countryName];
        NSString* storeFront = [countrySetting objectForKey:@"id"];
        NSString* code = [countrySetting objectForKey:@"image"];

        Store* store = [[[Store alloc] initWithName:countryName storefront:storeFront code:code] autorelease];
        [allCountries setValue:store forKey:countryName];
    }
    self.allCountries = allCountries;
    self.allCountryNames = sortedCountries;
    
    // build top country list
    NSArray* topCountryNames = [NSArray arrayWithObjects:@"United States", @"United Kingdom", @"Canada", @"Deutschland",
                         @"España", @"France", @"Australia", @"日本", nil];
    for (NSString* countryName in topCountryNames) {
        Store* store = [allCountries objectForKey:countryName];
        [topCountries setValue:store forKey:countryName];
    }
    self.topCountries = topCountries;
    self.topCountryNames = topCountryNames;

    // build non-top country list
    for (NSString* countryName in [allCountries allKeys]) {
        Store* store = [allCountries objectForKey:countryName];
        if (![self.topCountries objectForKey:countryName]) {
            [othersCountries setValue:store forKey:countryName];
            [othersCountryNames addObject:countryName];
        }
    }
    self.othersCountries = othersCountries;
    self.othersCountyNames = [othersCountryNames sortedArrayUsingSelector:@selector(compare:)];
    
}

@end

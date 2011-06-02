//
//  AppMonConfig.m
//  AppMon
//
//  Created by Chong Francis on 11年6月1日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonConfig.h"
#import "SynthesizeSingleton.h"

@interface AppMonConfig (Private)
@end

@implementation AppMonConfig

@synthesize selectedCountry=_selectedCountry, selectedCountryCode=_selectedCountryCode, autoRefreshIntervalMinute=_autoRefreshIntervalMinute;

SYNTHESIZE_SINGLETON_FOR_CLASS(AppMonConfig);

- (id)init
{
    self = [super init];
    if (self) {
        self.autoRefreshIntervalMinute = 15;
    }
    
    return self;
}

- (void)dealloc
{
    self.selectedCountry = nil;
    self.selectedCountryCode = nil;
    [super dealloc];
}

-(AppMonConfig*) save {
    NSUserDefaults* setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:self.selectedCountry forKey:@"selectedCountry"];
    [setting setObject:self.selectedCountryCode forKey:@"selectedCountryCode"];
    [setting setInteger:self.autoRefreshIntervalMinute forKey:@"autoRefreshIntervalMinute"];
    [setting synchronize];
    return self;
}

-(AppMonConfig*) load {
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
        self.autoRefreshIntervalMinute = 15;
    }
    
    return self;
}

#pragma mark - Private

@end

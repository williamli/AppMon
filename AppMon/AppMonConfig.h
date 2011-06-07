//
//  AppMonConfig.h
//  AppMon
//
//  Created by Chong Francis on 11年6月1日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppMonConfig : NSObject {
@private
    NSString* _selectedCountry;
    NSString* _selectedCountryCode;
    NSUInteger _autoRefreshIntervalMinute;
    
    NSDictionary* _allCountries;
    NSDictionary* _topCountries;
    NSDictionary* _othersCountries;
    NSArray* _allCountryNames;
    NSArray* _topCountryNames;
    NSArray* _othersCountyNames;
}

@property (nonatomic, retain) NSString* selectedCountry;
@property (nonatomic, retain) NSString* selectedCountryCode;
@property (nonatomic, assign) NSUInteger autoRefreshIntervalMinute;

@property (nonatomic, retain) NSDictionary* allCountries;
@property (nonatomic, retain) NSDictionary* topCountries;
@property (nonatomic, retain) NSDictionary* othersCountries;
@property (nonatomic, retain) NSArray* allCountryNames;
@property (nonatomic, retain) NSArray* topCountryNames;
@property (nonatomic, retain) NSArray* othersCountyNames;

+ (AppMonConfig *)sharedAppMonConfig;

-(NSDictionary*) allCountries;

-(NSDictionary*) topCountries;

-(NSDictionary*) othersCountries;

-(NSArray*) allCountryNames;

-(NSArray*) topCountryNames;

-(NSArray*) othersCountryNames;

-(BOOL) storeEnabledWithCountryName:(NSString*)countryName;

-(void) setStoreEnabled:(BOOL)enabled withCountryName:(NSString*)countryName;

-(AppMonConfig*) save;

-(AppMonConfig*) load;

@end

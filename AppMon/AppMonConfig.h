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
}

@property (nonatomic, retain) NSString* selectedCountry;
@property (nonatomic, retain) NSString* selectedCountryCode;
@property (nonatomic, assign) NSUInteger autoRefreshIntervalMinute;

+ (AppMonConfig *)sharedAppMonConfig;

-(AppMonConfig*) save;

-(AppMonConfig*) load;

@end

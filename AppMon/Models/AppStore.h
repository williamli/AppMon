//
//  AppStore.h
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"

extern NSString * const kAppStoreSoftwareUrl;
extern NSString * const kAppStoreSearchUrl;
extern NSString * const kAppStoreCountryUrl;
extern NSString * const kAppStoreReviewUrl;

@interface AppStore : NSObject {
@private
    
}

-(App*) fetchAppById:(NSString*)appid;

-(NSArray*) search:(NSString*)query;

-(NSArray*) stores;

-(NSArray*) reviews:(NSString*)app_id page:(NSInteger)page store:(NSString*)store;


@end

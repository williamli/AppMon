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

@property (nonatomic, retain) NSString* storeFront;

-(App*) fetchAppById:(NSString*)appid error:(NSError**)error;

-(NSArray*) search:(NSString*)query resultCount:(NSInteger*)resultCount error:(NSError**)error;

-(NSArray*) search:(NSString*)query page:(NSInteger)page resultCount:(NSInteger*)resultCount error:(NSError**)error;

-(NSArray*) stores:(NSError**)error;

-(NSArray*) reviews:(NSString*)app_id page:(NSInteger)page store:(NSString*)store error:(NSError**)error;


@end

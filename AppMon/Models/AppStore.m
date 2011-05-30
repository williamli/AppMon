//
//  AppStore.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppStore.h"

NSString * const kAppStoreSoftwareUrl   = @"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware";
NSString * const kAppStoreSearchUrl     = @"http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search";
NSString * const kAppStoreCountryUrl    = @"";
NSString * const kAppStoreReviewUrl     = @"";

@implementation AppStore

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(App*) fetchAppById:(NSString*)appid {
    return nil;
}  

-(NSArray*) search:(NSString*)query {
    return nil;
}  

-(NSArray*) stores {
    return nil;
}  

-(NSArray*) reviews:(NSString*)app_id page:(NSInteger)page store:(NSString*)store {
    return nil;
}  


@end

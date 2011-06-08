//
//  AppStore.h
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "App.h"
#import "Timeline.h"
#import "ReviewResponse.h"

extern NSString * const kAppStoreSoftwareUrl;
extern NSString * const kAppStoreSearchUrl;
extern NSString * const kAppStoreCountryUrl;
extern NSString * const kAppStoreReviewUrl;

#define kSearchResultPerPage    24

@interface AppStoreApi : NSObject {
    
@private
    
}

+ (AppStoreApi *)sharedAppStoreApi;

// TODO: Hints API
// http://ax.search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints?q=term


// Find an App by store and id
// Parameters: 
//  store   - app store front id
//  appid   - App Id
//  error   - if error occurred, error is set to non nil
// Return: App, or nil if error
-(App*) fetchAppByStore:(NSString*)store appId:(NSString*)appid error:(NSError**)error;

// Search a specific query on App Store
// Parameters: 
//  store   - app store front id
//  query   - terms to search
//  page    - number of page, 0 based
//  total   - if succeed, return the total number of search result on servers
//  error   - if error occurred, error is set to non nil
// Return: Array of Apps
-(NSArray*) searchByStore:(NSString*)store query:(NSString*)query page:(NSInteger)page total:(NSInteger*)total error:(NSError**)error;

// Search a specific query on multiple App Stores
// Parameters: 
//  stores  - array of Store
//  query   - terms to search
//  page    - number of page, 0 based
//  total   - if succeed, return the total number of search result on servers
// Return: Array of Apps
-(NSArray*) searchByStores:(NSArray*)stores query:(NSString*)query page:(NSInteger)page total:(NSInteger*)total;

// Find reviews of an app
// Parameters: 
//  store   - app store front id
//  appid   - App Id
//  page    - number of page, 0 based
// Return: ReviewResponse - repsone object
-(ReviewResponse*) reviewsByStore:(NSString*)store appId:(NSString*)appid page:(NSInteger)page;

// Find reviews of an app by review URL
// Parameters: 
//  store   - app store front id
//  url     - review URL
// Return: ReviewResponse - repsone object
-(ReviewResponse*) reviewsByStore:(NSString*)store url:(NSString*)url;

// Find reviews of an app on multiple stores
// Parameters: 
//  stores  - array of Store
//  appid   - App Id
// Return: array of ReviewResponse - repsone objects
-(NSArray*) reviewsByStores:(NSArray*)stores appId:(NSString*)appId;

// Find more reviews of an app on multiple stores, based on previous response objects
// Parameters: 
//  responses  - array of ReviewResponse object, they should contains store and moreUrl
// Return: array of ReviewResponse - repsone objects
-(NSArray*) reviewsByResponses:(NSArray*)responses;

@end

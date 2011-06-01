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

extern NSString * const kAppStoreSoftwareUrl;
extern NSString * const kAppStoreSearchUrl;
extern NSString * const kAppStoreCountryUrl;
extern NSString * const kAppStoreReviewUrl;

#define kSearchResultPerPage    24

@interface AppStoreApi : NSObject {
    
@private
    
}

@property (nonatomic, retain) NSString* storeFront;

// Find an App by id
// Parameters: 
//  appid   - App Id
//  error   - if error occurred, error is set to non nil
// Return: App, or nil if error
-(App*) fetchAppById:(NSString*)appid error:(NSError**)error;

// Search a specific quert on App Store
// Parameters: 
//  query   - terms to search
//  page    - number of page, 0 based
//  total   - if succeed, return the total number of search result on servers
//  error   - if error occurred, error is set to non nil
// Return: Array of Apps
-(NSArray*) search:(NSString*)query page:(NSInteger)page total:(NSInteger*)total error:(NSError**)error;

// Find reviews of an app
// Parameters: 
//  appid   - App Id
//  page    - number of page, 0 based
//  total   - if succeed, return the total number of search result on servers
//  error   - if error occurred, error is set to non nil
// Return: Array of Reviews
-(NSArray*) reviews:(NSString*)appid page:(NSInteger)page total:(NSInteger*)total lastReviewDate:(NSDate**)lastReviewDate  error:(NSError**)error;

// Find list of available App Stores
// Parameters: 
//  error   - if error occurred, error is set to non nil
// Return: Array of Stores
-(NSArray*) stores:(NSError**)error;

@end

//
//  AppStore.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppStore.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Review.h"
#define kSearchResultPerPage 24

NSString * const kAppStoreSearchUrl     = @"http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search";
NSString * const kAppStoreSoftwareUrl   = @"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware";
NSString * const kAppStoreCountryUrl    = @"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/countrySelectorPage";
NSString * const kAppStoreReviewUrl     = @"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews";


@interface AppStore (Private)
-(ASIHTTPRequest*) request:(NSString*)urlStr;
-(ASIFormDataRequest*) postRequest:(NSString*)urlStr;
@end

@implementation AppStore

@synthesize storeFront=_storeFront;

- (id)init
{
    self = [super init];
    if (self) {
        self.storeFront = @"143441"; // US
    }    
    return self;
}

- (void)dealloc
{
    self.storeFront = nil;
    [super dealloc];
}

-(App*) fetchAppById:(NSString*)appid error:(NSError**)error {
    App* app = nil;
    ASIHTTPRequest* req = [self request:[NSString stringWithFormat:@"%@?id=%@", kAppStoreSoftwareUrl, appid]];
    [req setRequestMethod:@"GET"];
    [req startSynchronous];
    
    if ([req responseStatusCode] == 200) {
        NSPropertyListFormat format;
        NSString *errorDesc;

        NSDictionary* dictionary = [NSPropertyListSerialization propertyListFromData:[req responseData]
                                                                    mutabilityOption:NSPropertyListImmutable
                                                                              format:&format
                                                                    errorDescription:&errorDesc];

        if (errorDesc) {
            *error = [NSError errorWithDomain:@"PlistSerializationError" 
                                         code:1 
                                     userInfo:[NSDictionary dictionaryWithObject:errorDesc 
                                                                          forKey:@"Description"]];
        } else {
            app = [[[App alloc] initWithPlist:dictionary] autorelease];

        }

    } else {
        *error = [req error];

    }

    return app;
} 

// search a specific quert on App Store
// Parameters: 
//  query   - terms to search
//  total   - if succeed, will set the total number of search result on servers
//  error   - if error occurred, error is set non nil
// Return: Array of Apps
-(NSArray*) search:(NSString*)query total:(NSInteger*)total error:(NSError**)error {    
    return [self search:query page:0 total:total error:error];
}

// search a specific quert on App Store
// Parameters: 
//  query   - terms to search
//  page    - number of page, 0 based
//  total   - if succeed, will set the total number of search result on servers
//  error   - if error occurred, error is set non nil
// Return: Array of Apps
-(NSArray*) search:(NSString*)query page:(NSInteger)page total:(NSInteger*)total error:(NSError**)error {
    NSMutableArray* searchResult = [NSMutableArray array];
    ASIFormDataRequest* req = [self postRequest:kAppStoreSearchUrl];
    [req setRequestMethod:@"POST"];    
    [req setPostValue:[NSString stringWithFormat:@"%ld", page*kSearchResultPerPage] forKey:@"startIndex"];
    [req setPostValue:[NSString stringWithFormat:@"%ld", page*kSearchResultPerPage] forKey:@"displayIndex"];
    [req setPostValue:@"software" forKey:@"media"];
    [req setPostValue:query forKey:@"term"];
    [req startSynchronous];
    
    if ([req responseStatusCode] == 200) {
        NSPropertyListFormat format;
        NSString *errorDesc;
        
        NSDictionary* dictionary = [NSPropertyListSerialization propertyListFromData:[req responseData]
                                                                    mutabilityOption:NSPropertyListImmutable
                                                                              format:&format
                                                                    errorDescription:&errorDesc];
        
        if (errorDesc) {
            *error = [NSError errorWithDomain:@"PlistSerializationError" 
                                         code:1 
                                     userInfo:[NSDictionary dictionaryWithObject:errorDesc 
                                                                          forKey:@"Description"]];
        } else {
            NSArray* items = [dictionary objectForKey:@"items"];
            for (NSDictionary* itemDict in items) {
                if ([[itemDict objectForKey:@"type"] isEqualToString:@"link"]) {
                    App* app = [[[App alloc] initWithPlist:itemDict] autorelease];
                    [searchResult addObject:app];
                    
                } else if ([[itemDict objectForKey:@"type"] isEqualToString:@"more"]) {
                    *total = [[itemDict objectForKey:@"total-items"] intValue];

                    NSString* moreUrl = [itemDict objectForKey:@"url"];
                    NSLog(@"Total Result: %ld, More: %@", *total, moreUrl);
                    
                }
            }
        }
        
    } else {
        *error = [req error];
        
    }
    
    return searchResult;
}  

-(NSArray*) stores:(NSError**)error {
    return nil;
}  

-(NSArray*) reviews:(NSString*)appid page:(NSInteger)page total:(NSInteger*)total error:(NSError**)error{
    NSMutableArray* reviews = [NSMutableArray array];
    ASIHTTPRequest* req = [self request:[NSString stringWithFormat:@"%@?id=%@&type=Purple+Software&displayable-kind=11&pageNumber=%ld", 
                                         kAppStoreReviewUrl, appid, page]];
    [req setRequestMethod:@"GET"];
    [req startSynchronous];
    
    if ([req responseStatusCode] == 200) {
        NSPropertyListFormat format;
        NSString *errorDesc;
        
        NSDictionary* dictionary = [NSPropertyListSerialization propertyListFromData:[req responseData]
                                                                    mutabilityOption:NSPropertyListImmutable
                                                                              format:&format
                                                                    errorDescription:&errorDesc];
        
        if (errorDesc) {
            *error = [NSError errorWithDomain:@"PlistSerializationError" 
                                         code:1 
                                     userInfo:[NSDictionary dictionaryWithObject:errorDesc 
                                                                          forKey:@"Description"]];
        } else {
            NSArray* items = [dictionary objectForKey:@"items"];
            for (NSDictionary* itemDict in items) {
                if ([[itemDict objectForKey:@"type"] isEqualToString:@"review"]) {
                    Review* review = [[[Review alloc] initWithPlist:itemDict] autorelease];
                    [reviews addObject:review];
                    
                } else if ([[itemDict objectForKey:@"type"] isEqualToString:@"more"]) {
                    *total = [[itemDict objectForKey:@"total-items"] intValue];
                    NSString* moreUrl = [itemDict objectForKey:@"url"];
                    NSLog(@"Total Result: %ld, More: %@", *total, moreUrl);
                    
                }
            }
        }
        
    } else {
        *error = [req error];
        
    }
    
    return reviews;
} 

#pragma mark - Private

-(ASIHTTPRequest*) request:(NSString*)urlStr {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:@"X-Apple-Store-Front" 
                        value:[NSString stringWithFormat:@"%@-1,2", self.storeFront]];
    [request setUserAgent:@"iTunes-iPhone/3.0"];
    return request;
}

-(ASIFormDataRequest*) postRequest:(NSString*)urlStr {
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:@"X-Apple-Store-Front" 
                         value:[NSString stringWithFormat:@"%@-1,2", self.storeFront]];
    [request setUserAgent:@"iTunes-iPhone/3.0"];
    return request;
}
@end

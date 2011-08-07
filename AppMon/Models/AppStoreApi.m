    //
//  AppStore.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "SynthesizeSingleton.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "XPathQuery.h"
#import "RegexKitLite.h"

#import "AppStoreApi.h"
#import "Review.h"
#import "Store.h"

#define kStoreFrontRegexp @"storeFrontId=([0-9]+)"
#define kReviewCountRegexp @"Reviews \\(([0-9]+)\\)"

NSString * const kAppStoreSearchUrl     = @"http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search";
NSString * const kAppStoreSoftwareUrl   = @"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware";
NSString * const kAppStoreCountryUrl    = @"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/countrySelectorPage";
NSString * const kAppStoreReviewUrl     = @"http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews";


@interface AppStoreApi (Private)
-(ASIHTTPRequest*) request:(NSString*)urlStr store:(NSString*)store;
-(ASIFormDataRequest*) iTunesRequest:(NSString*)urlStr store:(NSString*)store;
-(ASIFormDataRequest*) postRequest:(NSString*)urlStr store:(NSString*)store;
-(NSArray*) storesFromNodes:(NSArray*)nodes;
-(NSArray*) reviewsByStores:(NSArray*)stores url:(NSString*)url;
@end

@implementation AppStoreApi

SYNTHESIZE_SINGLETON_FOR_CLASS(AppStoreApi);

- (id)init
{
    self = [super init];
    if (self) {
    }    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(App*) fetchAppByStore:(NSString*)store appId:(NSString*)appid error:(NSError**)error {
    App* app = nil;
    ASIHTTPRequest* req = [self request:[NSString stringWithFormat:@"%@?id=%@", kAppStoreSoftwareUrl, appid] store:store];
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
            if (error != NULL){
                *error = [NSError errorWithDomain:@"PlistSerializationError" 
                                             code:1 
                                         userInfo:[NSDictionary dictionaryWithObject:errorDesc 
                                                                              forKey:@"Description"]];
            }
        } else {
            NSDictionary* metadata = [dictionary objectForKey:@"item-metadata"];
            app = [[[App alloc] initWithPlist:metadata] autorelease];

        }

    } else {
        if (error) {
            *error = [req error];
        }

    }

    return app;
} 

-(App*) fetchAppByStores:(NSArray*)stores appId:(NSString*)appid {
    NSMutableArray* results = [NSMutableArray array];
    dispatch_queue_t search_queue = dispatch_queue_create("search.mutex", 0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (Store* store in [[stores copy] autorelease]) {
        dispatch_group_async(group, queue, ^{
            NSError* error = nil;
            App* app = [self fetchAppByStore:[store storefront] 
                                        appId:appid 
                                        error:&error];
            if (!error) {
                dispatch_sync(search_queue, ^{
                    if (![[[results copy] autorelease] containsObject:app]) {
                        [results addObject:app];           
                    }
                });
            } else {
                NSLog(@"ERROR: search store failed: %@ %@", store, error);
                
            }
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    dispatch_release(search_queue);
    
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    } else {
        return nil;
    }
}

-(NSArray*) searchByStore:(NSString*)store query:(NSString*)query page:(NSInteger)page total:(NSInteger*)total error:(NSError**)error {
    NSMutableArray* searchResult = [NSMutableArray array];
    ASIFormDataRequest* req = [self iTunesRequest:kAppStoreSearchUrl store:store];
    [req setRequestMethod:@"POST"];
    [req setPostValue:[NSString stringWithFormat:@"%ld", page*kSearchResultPerPage] forKey:@"startIndex"];
    [req setPostValue:[NSString stringWithFormat:@"%ld", page*kSearchResultPerPage] forKey:@"displayIndex"];
    [req setPostValue:@"software" forKey:@"media"];
    [req setPostValue:query forKey:@"term"];
    [req startSynchronous];
    
    if ([req responseStatusCode] == 200) {        
        NSArray* apps = PerformHTMLXPathQuery([req responseData], @"//div[@class='buy'] | //div[@class='buy fat-binary']");
        NSArray* counts = PerformHTMLXPathQuery([req responseData], @"//div[@class='count']");
        
        if (!apps) {
            *error = [NSError errorWithDomain:@"AppStoreSearchError" 
                                         code:1 
                                     userInfo:nil];

        } else {
            for (NSDictionary* itemDict in apps) {
                App* app = [[[App alloc] initWithDiv:itemDict] autorelease];
                [searchResult addObject:app];                
            }

            for (NSDictionary* itemDict in counts) {
                NSString* counter = [itemDict objectForKey:@"nodeContent"];
                if (counter) {
                    NSArray* match = [counter captureComponentsMatchedByRegex:@" of ([0-9]+)"];             
                    if (match) {
                        *total = [[match objectAtIndex:1] intValue];
                    }
                }
            }
        }
        
    } else {
        if (error) {
            *error = [req error];
        }
        
    }
    
    return searchResult;
}

-(NSArray*) searchByStores:(NSArray*)stores query:(NSString*)query page:(NSInteger)page total:(NSInteger*)total {
    NSMutableArray* results = [NSMutableArray array];
    dispatch_queue_t search_queue = dispatch_queue_create("search.mutex", 0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    *total = 0;
    
    for (Store* store in [[stores copy] autorelease]) {
        dispatch_group_async(group, queue, ^{
            NSError* error = nil;
            NSInteger subPage = 0;
            NSArray* apps = [self searchByStore:store.storefront 
                                          query:query 
                                           page:subPage 
                                          total:total 
                                          error:&error];
            if (!error) {
                dispatch_sync(search_queue, ^{
                    for (App* app in [[apps copy] autorelease]) {
                        if (![[[results copy] autorelease] containsObject:app]) {
                            [results addObject:app];           
                        }
                    }
                    *total += subPage;
                });
            } else {
                NSLog(@"ERROR: search store failed: %@ %@", store, error);

            }
        });
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    dispatch_release(search_queue);
    
    return results;
}

-(NSArray*) stores:(NSError**)error {
    NSArray* countries = nil;

    ASIHTTPRequest* req = [self request:kAppStoreCountryUrl store:@"143441"];
    [req startSynchronous];
    
    if ([req responseStatusCode] == 200) {
        NSArray* countryTags    = PerformXMLXPathQuery([req responseData], @"//itms:GotoURL");
        countries      = [self storesFromNodes:countryTags];

    } else {
        if (error) {
            *error = [req error];
        }
        
    }

    return countries;
}  

-(ReviewResponse*) reviewsByStore:(NSString*)store 
                            appId:(NSString*)appid 
                             page:(NSInteger)page {
    NSString* url = [NSString stringWithFormat:@"%@?id=%@&type=Purple+Software&displayable-kind=11&pageNumber=%ld", 
                     kAppStoreReviewUrl, appid, page];
    return [self reviewsByStore:store url:url];
}

-(ReviewResponse*) reviewsByStore:(NSString*)store 
                              url:(NSString*)url {
    NSLog(@"review by store: %@, url: %@", store, url);
    
    ReviewResponse* response = [[[ReviewResponse alloc] initWithStore:store] autorelease];
    NSMutableArray* reviews = [NSMutableArray array];

    ASIHTTPRequest* req = [self request:url store:store];
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
            response.error = [NSError errorWithDomain:@"PlistSerializationError" 
                                                 code:1 
                                             userInfo:[NSDictionary dictionaryWithObject:errorDesc 
                                                                                  forKey:@"Description"]];
            return response;

        } else {
            NSString* title = [dictionary objectForKey:@"title"];
            if (title) {
                NSArray* matches = [title captureComponentsMatchedByRegex:kReviewCountRegexp];
                if (matches && [matches count] > 1) {
                    response.total = [[matches objectAtIndex:1] intValue];
                }
            }
            
            NSArray* items = [dictionary objectForKey:@"items"];
            for (NSDictionary* itemDict in items) {
                if ([[itemDict objectForKey:@"type"] isEqualToString:@"review"]) {
                    Review* review = [[[Review alloc] initWithPlist:itemDict store:store] autorelease];
                    [reviews addObject:review];

                } else if ([[itemDict objectForKey:@"type"] isEqualToString:@"more"]) {
                    response.moreUrl = [itemDict objectForKey:@"url"];
                    
                } else if ([[itemDict objectForKey:@"type"] isEqualToString:@"review-header"]) {
                    response.lastReviewDate = [itemDict objectForKey:@"last-review-date"];
                    
                }
            }

            response.reviews = reviews;
            return response;
        }       
        
        
    } else {
        response.error = [req error];
        return response;
    }
}

-(NSArray*) reviewsByStores:(NSArray*)stores appId:(NSString*)appId {
    NSString* url = [NSString stringWithFormat:@"%@?id=%@&type=Purple+Software&displayable-kind=11&pageNumber=%ld", 
                     kAppStoreReviewUrl, appId, 0];
    return [self reviewsByStores:stores url:url];
}

-(NSArray*) reviewsByResponses:(NSArray*)responses {
    NSMutableArray* results = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [responses retain];

    for (ReviewResponse* origResponse in responses) {
        dispatch_group_async(group, queue, ^{
            ReviewResponse* resp = [self reviewsByStore:origResponse.store 
                                                    url:origResponse.moreUrl];
            [results addObject:resp];
        });
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    [responses release];

    return results;
}

#pragma mark - Private

-(NSArray*) reviewsByStores:(NSArray*)stores url:(NSString*)url {
    NSLog(@"review by stores: %@, url: %@", stores, url);
    NSMutableArray* results = [NSMutableArray array];
    dispatch_queue_t review_queue = dispatch_queue_create("review.mutex", 0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_apply([stores count], review_queue, ^(size_t store_index) {
        dispatch_group_async(group, queue, ^{
            Store* store = [stores objectAtIndex:store_index];
            ReviewResponse* response = [self reviewsByStore:store.storefront url:url];
            dispatch_group_async(group, queue, ^{
                [results addObject:response];
            });           
        });
        
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    dispatch_release(review_queue);
    return results;
}

-(ASIHTTPRequest*) request:(NSString*)urlStr store:(NSString*)store {    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:@"X-Apple-Store-Front" 
                        value:[NSString stringWithFormat:@"%@-1,2", store]];
    [request setUserAgent:@"iTunes-iPhone/3.0"];
    [request setTimeOutSeconds:10];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request setPersistentConnectionTimeoutSeconds:120];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    return request;
}


-(ASIFormDataRequest*) iTunesRequest:(NSString*)urlStr store:(NSString*)store {
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:@"X-Apple-Store-Front" 
                        value:[NSString stringWithFormat:@"%@-1,9", store]];
    [request setUserAgent:@"iTunes-iPad/4.3.3"];
    [request setTimeOutSeconds:10];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request setPersistentConnectionTimeoutSeconds:120];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    return request;
}

-(ASIFormDataRequest*) postRequest:(NSString*)urlStr store:(NSString*)store {    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:@"X-Apple-Store-Front" 
                         value:[NSString stringWithFormat:@"%@-1,2", store]];
    [request setUserAgent:@"iTunes-iPhone/3.0"];
    [request setTimeOutSeconds:10];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request setPersistentConnectionTimeoutSeconds:120];
    [request setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    return request;
}

@end

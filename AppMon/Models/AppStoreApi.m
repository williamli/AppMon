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
-(ASIHTTPRequest*) request:(NSString*)urlStr store:(NSString*)store ;
-(ASIFormDataRequest*) postRequest:(NSString*)urlStr store:(NSString*)store;
-(NSArray*) storesFromNodes:(NSArray*)nodes;
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

-(NSArray*) searchByStore:(NSString*)store query:(NSString*)query page:(NSInteger)page total:(NSInteger*)total error:(NSError**)error {
    NSMutableArray* searchResult = [NSMutableArray array];
    ASIFormDataRequest* req = [self postRequest:kAppStoreSearchUrl store:store];
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
            if (error) {
                *error = [NSError errorWithDomain:@"PlistSerializationError" 
                                             code:1 
                                         userInfo:[NSDictionary dictionaryWithObject:errorDesc 
                                                                              forKey:@"Description"]];
            }
        } else {
            NSArray* items = [dictionary objectForKey:@"items"];
            for (NSDictionary* itemDict in items) {
                if ([[itemDict objectForKey:@"type"] isEqualToString:@"link"]) {
                    App* app = [[[App alloc] initWithPlist:itemDict] autorelease];
                    [searchResult addObject:app];
                    
                } else if ([[itemDict objectForKey:@"type"] isEqualToString:@"more"]) {
                    *total = [[itemDict objectForKey:@"total-items"] intValue];
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

-(NSArray*) reviewsByStore:(NSString*)store 
                     appId:(NSString*)appid 
                      page:(NSInteger)page 
                     total:(NSInteger*)total
                   moreUrl:(NSString**)moreUrl
            lastReviewDate:(NSDate**)lastReviewDate 
                     error:(NSError**)error{
    NSString* url = [NSString stringWithFormat:@"%@?id=%@&type=Purple+Software&displayable-kind=11&pageNumber=%ld", 
                     kAppStoreReviewUrl, appid, page];
    return [self reviewsByStore:store url:url total:total moreUrl:moreUrl lastReviewDate:lastReviewDate error:error];
} 

-(NSArray*) reviewsByStore:(NSString*)store 
                       url:(NSString*)url
                     total:(NSInteger*)total
                   moreUrl:(NSString**)moreUrl
            lastReviewDate:(NSDate**)lastReviewDate 
                     error:(NSError**)error {
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
            if (error) {
                *error = [NSError errorWithDomain:@"PlistSerializationError" 
                                             code:1 
                                         userInfo:[NSDictionary dictionaryWithObject:errorDesc 
                                                                              forKey:@"Description"]];
            }
        } else {
            NSString* title = [dictionary objectForKey:@"title"];
            if (title) {
                NSArray* matches = [title captureComponentsMatchedByRegex:kReviewCountRegexp];
                if (matches && [matches count] > 1) {
                    *total = [[matches objectAtIndex:1] intValue];
                }
            }
            
            NSArray* items = [dictionary objectForKey:@"items"];
            for (NSDictionary* itemDict in items) {
                if ([[itemDict objectForKey:@"type"] isEqualToString:@"review"]) {
                    Review* review = [[[Review alloc] initWithPlist:itemDict store:store] autorelease];
                    [reviews addObject:review];
                    
                } else if ([[itemDict objectForKey:@"type"] isEqualToString:@"more"]) {
                    *moreUrl = [itemDict objectForKey:@"url"];
                    
                } else if ([[itemDict objectForKey:@"type"] isEqualToString:@"review-header"]) {
                    *lastReviewDate = [itemDict objectForKey:@"last-review-date"];
                    
                }
            }
        }
        
    } else {
        if (error) {
            *error = [req error];
        }
        
    }
    
    return reviews;
} 

#pragma mark - Private

-(ASIHTTPRequest*) request:(NSString*)urlStr store:(NSString*)store {    
    NSLog(@"GET %@", urlStr);

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:@"X-Apple-Store-Front" 
                        value:[NSString stringWithFormat:@"%@-1,2", store]];
    [request setUserAgent:@"iTunes-iPhone/3.0"];
    return request;
}

-(ASIFormDataRequest*) postRequest:(NSString*)urlStr store:(NSString*)store {    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addRequestHeader:@"X-Apple-Store-Front" 
                         value:[NSString stringWithFormat:@"%@-1,2", store]];
    [request setUserAgent:@"iTunes-iPhone/3.0"];
    return request;
}

// parse the nodes return by XPath and return Array of Stores
-(NSArray*) storesFromNodes:(NSArray*)nodes {
    NSMutableArray* result = [NSMutableArray array];

    for (NSDictionary* dict in nodes) {
        NSArray* nodeAttributeArray = [dict objectForKey:@"nodeAttributeArray"];
        NSString* storefront = nil;
        NSString* country = nil;
        for (NSDictionary* attr in nodeAttributeArray) {
            if ([[attr objectForKey:@"attributeName"] isEqualToString:@"url"]) {
                NSString* url = [attr objectForKey:@"nodeContent"];
                NSArray* array = [url captureComponentsMatchedByRegex:kStoreFrontRegexp];
                if ([array count] == 2) {
                    storefront = [array objectAtIndex:1];
                    break;
                }
            }
        }
        
        NSArray* nodeChildArray = [dict objectForKey:@"nodeChildArray"];
        for (NSDictionary* children in nodeChildArray) {
            NSArray* nodeChildArray2 = [children objectForKey:@"nodeChildArray"];
            for (NSDictionary* children2 in nodeChildArray2) {
                if ([[children2 objectForKey:@"nodeName"] isEqualToString:@"SetFontStyle"]) {
                    country = [children2 objectForKey:@"nodeContent"];
                    break;
                }
            }
        }

        if (country && storefront) {
            [result addObject:[[[Store alloc] initWithName:country 
                                                storefront:storefront] autorelease]];
        }
    }

    return result;
}

@end

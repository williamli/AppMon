//
//  App.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "App.h"


@implementation App

@synthesize itemId=_itemId, title=_title, url=_url, iconUrl=_iconUrl, price=_price, releaseDate=_releaseDate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id) initWithPlist:(NSDictionary*)plist {
    self = [super init];
    if (self) {
        NSDictionary* metadata = [plist objectForKey:@"item-metadata"];
        self.itemId = [metadata objectForKey:@"item-id"];
        self.title = [metadata objectForKey:@"title"];
        self.url = [metadata objectForKey:@"url"];
        self.releaseDate = [metadata objectForKey:@"release-date"];
        
        NSArray* artworkUrls = [metadata objectForKey:@"artwork-urls"];
        for (NSDictionary* imageDict in artworkUrls) {
            if ([[imageDict objectForKey:@"image-type"] isEqualToString:@"software-icon"]) {
                self.iconUrl = [[imageDict objectForKey:@"default"] objectForKey:@"url"];
            }
        }
        
        NSDictionary* offers = [metadata objectForKey:@"store-offers"];
        NSDictionary* stdq = [offers objectForKey:@"STDQ"];
        self.price = [stdq objectForKey:@"price-display"];
    }
    return self;
}

- (void)dealloc
{
    self.itemId = nil;
    self.title = nil;
    self.url = nil;
    self.iconUrl = nil;
    self.price = nil;
    self.releaseDate = nil;
    [super dealloc];
}

@end

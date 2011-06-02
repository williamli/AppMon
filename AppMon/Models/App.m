//
//  App.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "App.h"


@implementation App

@synthesize itemId=_itemId, title=_title, url=_url, iconUrl=_iconUrl, price=_price, releaseDate=_releaseDate, unread=_unread;

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
        self.itemId = [plist objectForKey:@"item-id"];
        self.title = [plist objectForKey:@"title"];
        self.url = [plist objectForKey:@"url"];
        self.releaseDate = [plist objectForKey:@"release-date"];
        
        NSArray* artworkUrls = [plist objectForKey:@"artwork-urls"];
        for (NSDictionary* imageDict in artworkUrls) {
            
            NSNumber* height = [imageDict objectForKey:@"box-height"];
            NSNumber* width = [imageDict objectForKey:@"box-width"];
            if (height && width && [width intValue] >= 57 && [height intValue] >= 57) {
                self.iconUrl = [imageDict objectForKey:@"url"];
                break;
            }
            
            if ([[imageDict objectForKey:@"image-type"] isEqualToString:@"software-icon"]) {
                self.iconUrl = [[imageDict objectForKey:@"default"] objectForKey:@"url"];
                break;
            }
        }
        
        NSDictionary* offers = [plist objectForKey:@"store-offers"];
        NSDictionary* stdq = [offers objectForKey:@"STDQ"];
        self.price = [stdq objectForKey:@"price-display"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {    
    [coder encodeObject:_itemId forKey:@"AppItemId"];
    [coder encodeObject:_title forKey:@"AppTitle"];
    [coder encodeObject:_url forKey:@"AppUrl"];
    [coder encodeObject:_iconUrl forKey:@"AppIconUrl"];
    [coder encodeObject:_price forKey:@"AppPrice"];
    [coder encodeObject:_releaseDate forKey:@"AppReleaseDate"];
    [coder encodeInteger:_unread forKey:@"AppUnreadCount"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    _itemId         = [[coder decodeObjectForKey:@"AppItemId"] retain];
    _title          = [[coder decodeObjectForKey:@"AppTitle"] retain];
    _url            = [[coder decodeObjectForKey:@"AppUrl"] retain];
    _iconUrl        = [[coder decodeObjectForKey:@"AppIconUrl"] retain];
    _price          = [[coder decodeObjectForKey:@"AppPrice"] retain];
    _releaseDate    = [[coder decodeObjectForKey:@"AppReleaseDate"] retain];
    _unread         = [coder decodeIntegerForKey:@"AppUnreadCount"];
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

-(NSString*) description {
    return [NSString stringWithFormat:@"<App:%@, title=%@>", self.itemId, self.title];
}

-(BOOL) isEqual:(id)object {
    if ([object respondsToSelector:@selector(itemId)] && self.itemId) {
        return [[self itemId] isEqual:[object itemId]];        
    } else {
        return NO;
    }
}

@end

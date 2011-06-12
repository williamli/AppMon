//
//  App.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "App.h"
#import "RegexKitLite.h"

@implementation App

@synthesize itemId=_itemId, title=_title, iconUrl=_iconUrl, unread=_unread, universal=_universal;

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
    }
    return self;
}

-(id) initWithDiv:(NSDictionary*)div {
    self = [super init];
    if (self) {        
        for (NSDictionary* attr in [div objectForKey:@"nodeAttributeArray"]) {
            NSString* attrName = [attr objectForKey:@"attributeName"];
            id object = [attr objectForKey:@"nodeContent"];
            
            if ([attrName isEqualToString:@"item-id"]) {
                self.itemId = object;
            } else if ([attrName isEqualToString:@"item-title"]) {
                self.title = object;
            } else if ([attrName isEqualToString:@"artist-name"]) {
            } else if ([attrName isEqualToString:@"artwork-url"]) {
                self.iconUrl = object;
            } else if ([attrName isEqualToString:@"icon-is-prerendered"]) {
            } else if ([attrName isEqualToString:@"class"]) {
                if ([(NSString*)object isMatchedByRegex:@"fat-binary"]){
                    self.universal = YES;
                }
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {    
    [coder encodeObject:_itemId forKey:@"AppItemId"];
    [coder encodeObject:_title forKey:@"AppTitle"];
    [coder encodeObject:_iconUrl forKey:@"AppIconUrl"];
    [coder encodeInteger:_unread forKey:@"AppUnreadCount"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    
    _itemId         = [[coder decodeObjectForKey:@"AppItemId"] retain];
    _title          = [[coder decodeObjectForKey:@"AppTitle"] retain];
    _iconUrl        = [[coder decodeObjectForKey:@"AppIconUrl"] retain];
    _unread         = [coder decodeIntegerForKey:@"AppUnreadCount"];
    return self;
}

- (void)dealloc
{
    self.itemId = nil;
    self.title = nil;
    self.iconUrl = nil;
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

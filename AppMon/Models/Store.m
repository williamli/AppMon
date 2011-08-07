//
//  Store.m
//  AppMon
//
//  Created by Chong Francis on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "Store.h"

@implementation Store

@synthesize name=_name, storefront=_storefront, code=_code;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(id)initWithName:(NSString*)theName storefront:(NSString*)theStorefront code:(NSString*)theCode
{
    self = [super init];
    if (self) {
        self.name = theName;
        self.storefront = theStorefront;
        self.code = theCode;
    }
    return self;
}

- (void)dealloc
{
    [_key release];
    _key = nil;
    
    self.code = nil;
    self.name = nil;
    self.storefront = nil;
    [super dealloc];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<Store#%ld, name=%@, flag=%@>", self.storefront, self.name, self.code];
}

-(NSString*) key {
    if (!_key) {
        _key = [[NSString stringWithFormat:@"appstore.enabled.%@", self.storefront] retain];
    }
    return _key;
}

-(BOOL) isEqual:(id)object {
    if (object == self)
        return YES;
    if (!object || ![object isKindOfClass:[self class]])
        return NO;
    return [self.storefront isEqual:[object storefront]];
}

-(NSUInteger) hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + [[self storefront] hash];
    return result;
}

@end

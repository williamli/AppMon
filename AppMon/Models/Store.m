//
//  Store.m
//  AppMon
//
//  Created by Chong Francis on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "Store.h"

@implementation Store

@synthesize name=_name, storefront=_storefront;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithName:(NSString*)name storefront:(NSString*)storefront
{
    self = [super init];
    if (self) {
        self.name = name;
        self.storefront = storefront;
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.storefront = nil;
    [super dealloc];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<Store#%ld, name=%@>", self.storefront, self.name];
}

@end

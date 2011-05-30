//
//  App.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "App.h"


@implementation App

@synthesize item_id=_item_id, title=_title, url=_url, icon_url=_icon_url, price=_price, release_date=_release_date;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.item_id = nil;
    self.title = nil;
    self.url = nil;
    self.icon_url = nil;
    self.price = nil;
    self.release_date = nil;
    [super dealloc];
}

@end

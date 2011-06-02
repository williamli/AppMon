//
//  Store.h
//  AppMon
//
//  Created by Chong Francis on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Store : NSObject {
@private
    NSString* _name;
    NSString* _storefront;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* storefront;

-(id)initWithName:(NSString*)name storefront:(NSString*)storefront;

@end

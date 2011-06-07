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
    NSString* _code;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* storefront;
@property (nonatomic, retain) NSString* code;

-(id)initWithName:(NSString*)theName storefront:(NSString*)theStorefront code:(NSString*)theCode;

@end

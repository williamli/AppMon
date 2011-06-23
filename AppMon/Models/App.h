//
//  App.h
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface App : NSObject <NSCoding> {
@private
    NSString* _itemId;
    NSString* _title;
    NSString* _iconUrl;
    NSInteger _unread;
    NSInteger _total;
    BOOL _universal;
}

@property (nonatomic, retain) NSString* itemId;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* iconUrl;
@property (nonatomic, assign) NSInteger unread;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) BOOL universal;

-(id) initWithPlist:(NSDictionary*)plist;
-(id) initWithDiv:(NSDictionary*)plist;
-(BOOL) isEqual:(id)object;

@end

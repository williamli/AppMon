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
    NSNumber* _itemId;
    NSString* _title;
    NSString* _url;
    NSString* _iconUrl;
    NSString* _price;
    NSDate* _releaseDate;
    NSInteger _unread;
}

@property (nonatomic, retain) NSNumber* itemId;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* iconUrl;
@property (nonatomic, retain) NSString* price;
@property (nonatomic, retain) NSDate* releaseDate;
@property (nonatomic, assign) NSInteger unread;

-(id) initWithPlist:(NSDictionary*)plist;
-(BOOL) isEqual:(id)object;

@end

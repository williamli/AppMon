//
//  App.h
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface App : NSObject {
@private
}

@property (nonatomic, retain) NSString* itemId;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* iconUrl;
@property (nonatomic, retain) NSString* price;
@property (nonatomic, retain) NSDate* releaseDate;

-(id) initWithPlist:(NSDictionary*)plist;

@end

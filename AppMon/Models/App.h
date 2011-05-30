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

@property (nonatomic, retain) NSString* item_id;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* icon_url;
@property (nonatomic, retain) NSString* price;
@property (nonatomic, retain) NSDate* release_date;

@end

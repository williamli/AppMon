//
//  NSDateFormatter+CustomFormat.h
//  AppMon
//
//  Created by Francis Chong on 11年6月8日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDateFormatter (Shared)

// create a thread safe, shared date formatter used by the app, with custom date format and locale
+(NSDateFormatter*) sharedDateFormatterNamed:(NSString*)formatterName format:(NSString*)format locale:(NSString*)localeName;

// create a thread safe, shared date formatter used by the app with custom date format
+(NSDateFormatter*) sharedDateFormatterNamed:(NSString*)formatterName format:(NSString*)format;

+(NSDateFormatter*) sharedUserDateFormatter;

@end

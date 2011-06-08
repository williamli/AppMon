//
//  NSDateFormatter+CustomFormat.m
//  AppMon
//
//  Created by Francis Chong on 11年6月8日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "NSDateFormatter+Shared.h"

@implementation NSDateFormatter (Shared)

+(NSDateFormatter*) sharedDateFormatterNamed:(NSString*)formatterName format:(NSString*)format locale:(NSString*)localeName {
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter* dateFormatter = [threadDictionary objectForKey:formatterName] ;
    
    if (!dateFormatter) {
        dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        
        if (localeName != nil) {
            NSLocale *theLocale = [[NSLocale alloc] initWithLocaleIdentifier:localeName];
            [dateFormatter setLocale:theLocale];
        }

        [dateFormatter setDateFormat:format];
        [threadDictionary setObject:dateFormatter forKey:formatterName] ;
    }
    
    return dateFormatter;
}

+(NSDateFormatter*) sharedDateFormatterNamed:(NSString*)formatterName format:(NSString*)format {
    return [NSDateFormatter sharedDateFormatterNamed:formatterName format:format locale:nil];
}

+(NSDateFormatter*) sharedUserDateFormatter {
    NSMutableDictionary* threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter* dateFormatter = [threadDictionary objectForKey:@"user.date.formatter"];
    
    if (!dateFormatter) {
        dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [threadDictionary setObject:dateFormatter forKey:@"user.date.formatter"] ;
    }

    return dateFormatter;
}

@end

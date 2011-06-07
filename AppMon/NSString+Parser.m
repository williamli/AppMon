//
//  NSDate+Parser.m
//  AppMon
//
//  Created by Chong Francis on 11年6月8日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "NSString+Parser.h"


@implementation NSString (DateParser)

+(NSDateFormatter*) dateFormatter1 {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
    return dateFormatter;
}

+(NSDateFormatter*) dateFormatter2 {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    return dateFormatter;
}


+(NSDateFormatter*) dateFormatter3 {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    return dateFormatter;
}

+(NSDateFormatter*) dateFormatter4 {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    return dateFormatter;
}

+(NSDateFormatter*) dateFormatter5 {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    return dateFormatter;
}


-(NSDate*) dateWithString {
    NSDate* date = nil;

    date = [[NSString dateFormatter1] dateFromString:self];
    if (date) {
        return date;
    }
    
    date = [[NSString dateFormatter2] dateFromString:self];
    if (date) {
        return date;
    }
    
    date = [[NSString dateFormatter3] dateFromString:self];
    if (date) {
        return date;
    }
    
    date = [[NSString dateFormatter4] dateFromString:self];
    if (date) {
        return date;
    }
    
    date = [[NSString dateFormatter5] dateFromString:self];
    if (date) {
        return date;
    }
    
    return nil;
}


@end

//
//  NSDate+Parser.m
//  AppMon
//
//  Created by Chong Francis on 11年6月8日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "NSString+Parser.h"
#import "NSDateFormatter+IGUtils.h"

@implementation NSString (DateParser)

+(NSDateFormatter*) dateFormatter1 {
    return [NSDateFormatter sharedDateFormatterNamed:@"dateFormatter1" format:@"dd-MMM-yyyy" locale:@"en_US"];
}

+(NSDateFormatter*) dateFormatter2 {
    return [NSDateFormatter sharedDateFormatterNamed:@"dateFormatter2" format:@"MMM dd, yyyy" locale:@"en_US"];
}


+(NSDateFormatter*) dateFormatter3 {
    return [NSDateFormatter sharedDateFormatterNamed:@"dateFormatter3" format:@"dd.MM.yyyy" locale:@"en_US"];
}

+(NSDateFormatter*) dateFormatter4 {
    return [NSDateFormatter sharedDateFormatterNamed:@"dateFormatter4" format:@"dd MMM yyyy" locale:@"fr_FR"];
}

+(NSDateFormatter*) dateFormatter5 {
    return [NSDateFormatter sharedDateFormatterNamed:@"dateFormatter5" format:@"dd-MMM-yyyy" locale:@"it_IT"];
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

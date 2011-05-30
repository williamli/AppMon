//
//  Review.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "Review.h"
#import "RegexKitLite.h"

#define kTitleRegexp    @"^([0-9]+)\\. (.*) \\(v(.*)\\)$"
#define kNameRegexp     @"^(.+) on (.+)$"

@implementation Review

@synthesize rating=_rating, text=_text, title=_title, username=_username, date=_date, position=_position, on_version=_on_version;

- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

-(id) initWithPlist:(NSDictionary*)plist {
    self = [super init];
    if (self) {
        self.rating         = [[plist objectForKey:@"average-user-rating"] doubleValue];
        self.text           = [plist objectForKey:@"text"];
        NSString* rawTitle  = [plist objectForKey:@"title"];        //  "6. Boring (v1.5.3)";               /^([0-9]+)\. (.*) \(v(.*)\)$/
        NSString* rawName   = [plist objectForKey:@"user-name"];    //  "crudbuttonsman on May 30, 2011"    /^(.+) on (.+)$/
        
        NSArray* matches = [rawTitle captureComponentsMatchedByRegex:kTitleRegexp];
        if (matches && [matches count] == 4) {
            self.position   = [[matches objectAtIndex:1] intValue];
            self.title      = [matches objectAtIndex:2];
            self.on_version = [matches objectAtIndex:3];
        }
        
        matches = [rawName captureComponentsMatchedByRegex:kNameRegexp];
        if (matches && [matches count] == 3) {
            self.username       = [matches objectAtIndex:1];
            self.date           = [matches objectAtIndex:2];
        }
    }
    return self;
}


- (void)dealloc {   
    self.text = nil;
    self.title = nil;
    self.username = nil;
    self.date = nil;
    self.on_version = nil;
    [super dealloc];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<Review#%ld>", self.position];
}

@end

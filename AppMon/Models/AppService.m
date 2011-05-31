//
//  AppService.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppService.h"

@interface AppService (Private)
-(NSString*) saveFilePath;
@end

@implementation AppService

- (id)init
{
    self = [super init];
    if (self) {
        [self load];
        
        NSLog(@"apps: %@", _apps);
    }
    
    return self;
}

- (void)dealloc
{
    [_apps release];
    _apps = nil;

    [super dealloc];
}

-(void) follow:(App*)app {
    if (![self isFollowed:app]) {
        [_apps addObject:app];
        [self save];
    }
}

-(void) unfollow:(App*)app {
    [_apps removeObject:app];
    [self save];
}

-(NSArray*) followedApps {
    return _apps;
}

-(BOOL) isFollowed:(App*)app {
    return [_apps containsObject:app];
}

@end

@implementation AppService (Persistence)

-(void) save {
    NSString* savePath = [self saveFilePath];
    BOOL result = [NSKeyedArchiver archiveRootObject:_apps 
                                              toFile:savePath];
    if (!result) {
        NSLog(@"WARN: Failed saving AppService: %@", savePath);
    }
    
}

-(void) load {
    NSString* savePath = [self saveFilePath];
    NSFileManager* manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:savePath]) {
        NSLog(@"load config file: %@", savePath);
        [_apps release];
        _apps = [[NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:savePath]] retain];
        return;
    }

    // create initial empty data record
    NSLog(@"initialize config  file");
    [_apps release];
    _apps = [[NSMutableArray array] retain];
    [self save];        

}

// save path for app mon config file
// create intermediate directories if needed
-(NSString*) saveFilePath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true);
    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"AppMon"];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSError* error;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"ERROR: cannot create config file path: %@, error=%@", path, error);
        }
    }
    
    return [path stringByAppendingFormat:@"/appservice.plist"];   
}

@end

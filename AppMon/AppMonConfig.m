//
//  AppMonConfig.m
//  AppMon
//
//  Created by Chong Francis on 11年6月1日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonConfig.h"
#import "SynthesizeSingleton.h"

@interface AppMonConfig (Private)
-(NSString*) saveFilePath;
@end

@implementation AppMonConfig

@synthesize selectedCountry=_selectedCountry, selectedCountryCode=_selectedCountryCode;

SYNTHESIZE_SINGLETON_FOR_CLASS(AppMonConfig);

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    self.selectedCountry = nil;
    self.selectedCountryCode = nil;
    [super dealloc];
}

-(AppMonConfig*) save {
    NSString* savePath = [self saveFilePath];
    BOOL result = [NSKeyedArchiver archiveRootObject:self 
                                              toFile:savePath];
    if (!result) {
        NSLog(@"WARN: Failed saving settings file: %@", savePath);
    }
    
    return self;
}

-(AppMonConfig*) load {
    NSString* savePath = [self saveFilePath];
    NSFileManager* manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:savePath]) {
        NSLog(@"load settings file: %@", savePath);
        AppMonConfig* loadedConfig = [NSKeyedUnarchiver unarchiveObjectWithFile:savePath];
        self.selectedCountry        = (loadedConfig.selectedCountry == nil) ? @"United States" : loadedConfig.selectedCountry;
        self.selectedCountryCode    = (loadedConfig.selectedCountryCode == nil) ? @"143441" : loadedConfig.selectedCountryCode;

        NSLog(@"selectedCountry=%@, selectedCountryCode=%@", self.selectedCountry, self.selectedCountryCode);
        return self;
    }

    return [self save];
}

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)coder {    
    [coder encodeObject:self.selectedCountry forKey:@"selectedCountry"];
    [coder encodeObject:self.selectedCountryCode forKey:@"selectedCountryCode"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    self.selectedCountry         = [coder decodeObjectForKey:@"selectedCountry"];
    self.selectedCountryCode     = [coder decodeObjectForKey:@"selectedCountryCode"];
    return self;
}

#pragma mark - Private

// save path for app mon config file
// create intermediate directories if needed
-(NSString*) saveFilePath {
    NSBundle* bundle = [NSBundle mainBundle];
    NSDictionary* info = [bundle infoDictionary];
    NSString* bundleName = [info objectForKey:@"CFBundleName"];

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true);
    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSError* error;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"ERROR: cannot create config file path: %@, error=%@", path, error);
        }
    }
    
    return [path stringByAppendingFormat:@"/settings.plist"];   
}


@end

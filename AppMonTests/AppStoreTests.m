//
//  AppStoreTests.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppStoreTests.h"
#import "App.h"
#import "AppStore.h"

@implementation AppStoreTests

@synthesize appStore=_appStore;

- (void)setUp {
    [super setUp];
    self.appStore = [[[AppStore alloc] init] autorelease];
}

- (void)tearDown {
    self.appStore = nil;
    [super tearDown];
}

- (void)testFetchAppById {
    NSError* error = nil;
    App* app = [self.appStore fetchAppById:@"343200656" error:&error]; // 343200656 = Angry Bird

    STAssertNil(error, @"should have no error");
    STAssertNotNil(app, @"should not nil");

    STAssertNotNil(app.title, @"title should not nil");
    STAssertNotNil(app.itemId, @"itemId should not nil");
    STAssertNotNil(app.url, @"url should not nil");
    STAssertNotNil(app.iconUrl, @"iconUrl should not nil");
    STAssertNotNil(app.price, @"price should not nil");
    STAssertNotNil(app.releaseDate, @"releaseDate should not nil");    
}

- (void)testSearchApp {
    NSError* error = nil;
    NSInteger count = 0;
    NSArray* apps = [self.appStore search:@"Camera" resultCount:&count error:&error];

    STAssertNil(error, @"should have no error");
    STAssertNotNil(apps, @"should not nil");
    STAssertTrue([apps count] > 5, @"should have at least 5 result items");
    NSLog(@"result count: %ld, total result count: %ld", [apps count], count);
//    NSArray* apps2 = [self.appStore search:@"Camera" page:1 error:&error];
//    STAssertNil(error, @"should have no error");
//    STAssertNotNil(apps2, @"should not nil");
//    STAssertTrue([apps2 count] > 5, @"should have at least 5 result items");


}


@end

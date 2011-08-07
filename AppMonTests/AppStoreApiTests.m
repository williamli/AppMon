//
//  AppStoreTests.m
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppStoreApiTests.h"
#import "App.h"
#import "Review.h"
#import "AppStoreApi.h"

@implementation AppStoreApiTests

@synthesize appStore=_appStore;

- (void)setUp {
    [super setUp];
    self.appStore = [AppStoreApi sharedAppStoreApi];
}

- (void)tearDown {
    self.appStore = nil;
    [super tearDown];
}

- (void)testFetchAppById {
    NSError* error = nil;
    App* app = [self.appStore fetchAppByStore:@"143441" appId:@"343200656" error:&error]; // 343200656 = Angry Bird

    STAssertNil(error, @"should have no error");
    STAssertNotNil(app, @"should not nil");

    STAssertNotNil(app.title, @"title should not nil");
    STAssertNotNil(app.itemId, @"itemId should not nil");
    STAssertNotNil(app.iconUrl, @"iconUrl should not nil");
}


- (void)testSearchApp {
    NSError* error = nil;
    NSInteger count = 0;
    NSArray* apps = [self.appStore searchByStore:@"143441" query:@"Camera" page:0 total:&count error:&error];

    STAssertNil(error, @"should have no error");
    STAssertNotNil(apps, @"should not nil");
    STAssertTrue([apps count] > 5, @"should have at least 5 result items");
    NSLog(@"result count: %ld, total result count: %ld", [apps count], count);
    
    App* app = [apps objectAtIndex:0];
    STAssertNotNil(app, @"should not nil");
    STAssertNotNil(app.title, @"title should not nil");
    STAssertNotNil(app.itemId, @"itemId should not nil");
    STAssertNotNil(app.iconUrl, @"iconUrl should not nil");
}


- (void)testSearchMultiple {
    NSInteger count = 0;
    Store* s1 = [[[Store alloc] initWithName:@"United States" storefront:@"143441" code:@"us"] autorelease];
    Store* s2 = [[[Store alloc] initWithName:@"Hong Kong" storefront:@"143463" code:@"hk"] autorelease];
    NSArray* stores = [NSArray arrayWithObjects:s1, s2, nil];
    
    NSArray* apps = [self.appStore searchByStores:stores query:@"Camera" page:0 total:&count];
    STAssertNotNil(apps, @"should not nil");
    STAssertTrue([apps count] > 5, @"should have at least 5 result items");
    NSLog(@"result count: %ld, total result count: %ld", [apps count], count);

    App* app = [apps objectAtIndex:0];
    STAssertNotNil(app, @"should not nil");
    STAssertNotNil(app.title, @"title should not nil");
    STAssertNotNil(app.itemId, @"itemId should not nil");
    STAssertNotNil(app.iconUrl, @"iconUrl should not nil");    
}


- (void)testSearchAppSecondPage {
    NSError* error = nil;
    NSInteger count = 0;
    NSArray* apps2 = [self.appStore searchByStore:@"143441" query:@"Camera" page:1 total:&count error:&error];
    STAssertNil(error, @"should have no error searching second page");
    STAssertNotNil(apps2, @"should not nil");
    STAssertTrue([apps2 count] > 5, @"should have at least 5 result items");
}

- (void)testReviews {
    ReviewResponse* resp = [self.appStore reviewsByStore:@"143463" appId:@"343200656" page:0];
    
    STAssertNil(resp.error, @"should have no error: %@", resp.error);
    
    STAssertNotNil(resp.reviews, @"should not nil");
    STAssertTrue([resp.reviews count] > 0, @"should have at least 1 comments");
    STAssertNotNil(resp.lastReviewDate, @"lastReviewDate should not be nil");
    STAssertTrue(resp.total > 0, @"should have total > 0");
    STAssertTrue(resp.total < 1000000, @"should have total < 1000000");
    
    Review* rev1 = [resp.reviews objectAtIndex:0];
    STAssertNotNil(rev1.title, @"should have title");
    STAssertNotNil(rev1.text, @"should have text");
    STAssertTrue(rev1.rating > 0, @"should have rating");
    
    Review* rev2 = [resp.reviews objectAtIndex:1];
    STAssertNotNil(rev2.title, @"should have title");
    STAssertNotNil(rev2.text, @"should have text");
    STAssertTrue(rev2.rating > 0, @"should have rating");
    STAssertTrue(rev2.position > rev1.position, @"position 2 should be larger than position 1");

    // HKTV
    resp = [self.appStore reviewsByStore:@"143463" appId:@"348883035" page:0];
    STAssertNil(resp.error, @"should have no error: %@", resp.error);
    STAssertTrue(resp.total > 0, @"should have total > 0");
    STAssertTrue(resp.total < 1000000, @"should have total < 1000000");
    
}

@end

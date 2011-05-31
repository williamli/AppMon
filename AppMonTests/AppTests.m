//
//  AppTests.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppTests.h"
#import "App.h"

@implementation AppTests

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)testAppEquals { 
    App* app1 = [[[App alloc] init] autorelease];
    app1.itemId = @"12345";
    App* app2 = [[[App alloc] init] autorelease];
    app2.itemId = @"12346";    
    
    STAssertFalse([app1 isEqual:app2], @"should not be equal");
    
    
    app2.itemId = @"12345";
    STAssertTrue([app1 isEqual:app2], @"should be equal");
}
@end

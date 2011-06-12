//
//  AppSearchHeaderItem.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppSearchHeaderItem.h"


@implementation AppSearchHeaderItem

@synthesize lblMessage=_lblMessage, btnProceed=_btnProceed;

+ (AppSearchHeaderItem *) item {
    static NSNib *nib = nil;
    if(nib == nil) {
        nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass(self) bundle:nil];
    }
    
    NSArray *objects = nil;
    [nib instantiateNibWithOwner:nil topLevelObjects:&objects];
    [objects makeObjectsPerformSelector:@selector(release)];

    for(id object in objects) {
        if([object isKindOfClass:self]) {
            return object;
        }
    }
    
    NSAssert1(NO, @"No view of class %@ found.", NSStringFromClass(self));
    return nil;
}

- (void)dealloc
{
    self.lblMessage = nil;
    self.btnProceed = nil;
    [super dealloc];
}

@end

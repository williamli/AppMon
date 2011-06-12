//
//  AppReviewNotFoundItem.m
//  AppMon
//
//  Created by Francis Chong on 11年6月2日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppReviewNotFoundItem.h"


@implementation AppReviewNotFoundItem

@synthesize lblMessage;

+ (AppReviewNotFoundItem *) item {
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
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor whiteColor] set];
    NSRectFill(NSMakeRect(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height));
    
    [super drawRect:dirtyRect];
}

@end

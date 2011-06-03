//
//  CountryListHeaderItem.m
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "CountryListHeaderItem.h"

@interface CountryListHeaderItem (Private)
- (void)drawBackground;
@end


@implementation CountryListHeaderItem

@synthesize gradient, btnCheckbox, lblHeader;

+ (CountryListHeaderItem*) item {
    static NSNib *nib = nil;
    if(nib == nil) {
        nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass(self) bundle:nil];
    }
    
    NSArray *objects = nil;
    [nib instantiateNibWithOwner:nil topLevelObjects:&objects];
    for(id object in objects) {
        if([object isKindOfClass:self]) {
            return object;
        }
    }
    
    NSAssert1(NO, @"No view of class %@ found.", NSStringFromClass(self));
    return nil;
}

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
    self.gradient = nil;
    [super dealloc];
}

- (NSGradient*) gradient {
    if (gradient == nil) {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.92f alpha:1.0f] 
                                                 endingColor:[NSColor colorWithDeviceWhite:0.97f alpha:1.0f]];
    }
    return gradient;
}

- (void)drawBackground {
    if (self.highlighted) {
        [self.gradient drawInRect:self.bounds angle:90.0f];
    }
    
    if (self.selected) {
        [self.gradient drawInRect:self.bounds angle:270.0f];
    }
}
@end

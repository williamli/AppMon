//
//  JAListViewItem.m
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "CountryListItem.h"

@interface CountryListItem (Private)
- (void)drawBackground;
@end

@implementation CountryListItem

@synthesize gradient, btnCheckbox, imgFlag, lblCountry;

+ (CountryListItem*) item {
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

- (void)drawRect:(NSRect)rect {
    [self drawBackground];
    [super drawRect:rect];
}

- (NSGradient*) gradient {
    if (gradient == nil) {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.92f alpha:1.0f] 
                                                 endingColor:[NSColor colorWithDeviceWhite:0.97f alpha:1.0f]];
    }
    return gradient;
}

-(void) dealloc {
    self.btnCheckbox = nil;
    self.imgFlag = nil;
    self.lblCountry = nil;
    self.gradient = nil;
    [super dealloc];
}

- (void)drawBackground {
    if (self.highlighted) {
        [self.gradient drawInRect:self.bounds angle:90.0f];
    }
    
    if (self.selected) {
        [self.gradient drawInRect:self.bounds angle:270.0f];
    }
}

-(void) setCountryName:(NSString*)countryName {
    [self.lblCountry setStringValue:countryName];
}

-(void) setFlagName:(NSString*)flagName {
    NSImage* image = [NSImage imageNamed:flagName];
    [self.imgFlag setImage:image];
}

@end

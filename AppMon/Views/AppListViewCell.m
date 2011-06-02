//
//  AppListViewCell.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppListViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface AppListViewCell (Private)
- (void)drawBackground;

@property (nonatomic, readonly) NSGradient *gradient;
@property (nonatomic, readonly) NSGradient *selectedGradient;
@end

@implementation AppListViewCell

@synthesize lblTitle=_lblTitle, lblDate=_lblDate, imgThumbnail=_imgThumbnail, backgroundView=_backgroundView;
@synthesize app=_app;

+ (AppListViewCell *) appListViewCell {
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


- (void)dealloc
{
    [selectedGradient release];
    selectedGradient = nil;

    [gradient release];
    gradient = nil;
    
    self.app = nil;
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.imgThumbnail positioned:NSWindowAbove relativeTo:self.backgroundView];
}

-(void) setApp:(App*)newApp {
    if (![_app isEqual:newApp] && newApp != nil) {
        [_app release];
        _app = [newApp retain];
        
        [self.lblTitle setStringValue:self.app.title];
        [self.imgThumbnail setHidden:NO];
        [self.imgThumbnail setImageWithURL:[NSURL URLWithString:self.app.iconUrl] 
                          placeholderImage:[NSImage imageNamed:@"app_default"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];    
        [self.lblDate setStringValue:[dateFormatter stringFromDate:self.app.releaseDate]];
        [dateFormatter release];
    } else if (newApp == nil) {
        [_app release];
        _app = [newApp retain];
    }
}

- (void)drawRect:(NSRect)rect {
    [self drawBackground];
    [super drawRect:rect];
    
    self.backgroundView.layer.backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
    self.backgroundView.layer.shadowRadius = 2.0;
    self.backgroundView.layer.shadowOffset = CGSizeMake(0, -2);
    self.backgroundView.layer.shadowOpacity = 0.5;
    self.backgroundView.layer.cornerRadius = 10.0;
    
    self.imgThumbnail.layer.masksToBounds = true;
    self.imgThumbnail.layer.cornerRadius = 10.0;
}


#pragma mark - Private

- (void)drawBackground {
    if (self.selected) {
        [self.selectedGradient drawInRect:self.bounds angle:270.0f];
        [self.lblTitle setTextColor:[NSColor colorWithCalibratedRed:0.290 green:0.494 blue:0.769 alpha:1.]];
    } else {
        [self.gradient drawInRect:self.bounds angle:90.0f];
        [self.lblTitle setTextColor:[NSColor blackColor]];
    }
    
    [[NSColor colorWithDeviceWhite:0.5f alpha:1.0f] set];
    NSRectFill(NSMakeRect(0.0f, 0.0f, self.bounds.size.width, 1.0f));
    
    [[NSColor colorWithDeviceWhite:0.93f alpha:1.0f] set];
    NSRectFill(NSMakeRect(0.0f, self.bounds.size.height - 1.0f, self.bounds.size.width, 1.0f));
}

- (NSGradient *)gradient {
    if(gradient == nil) {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.8f alpha:1.0f] 
                                                 endingColor:[NSColor colorWithDeviceWhite:0.85f alpha:1.0f]];
    }    
    return gradient;
}

- (NSGradient*) selectedGradient {
    if (selectedGradient == nil) {
        selectedGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.92f alpha:1.0f] 
                                                 endingColor:[NSColor colorWithDeviceWhite:0.97f alpha:1.0f]];
    }
    return selectedGradient;
}

@end

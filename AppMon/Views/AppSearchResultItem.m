//
//  AppSearchResultItem.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AppSearchResultItem.h"
#import "UIImageView+WebCache.h"

#import "AppMonAppDelegate.h"
#import "AppService.h"

@interface AppSearchResultItem (Private)
- (void)drawBackground;
@property (nonatomic, readonly) NSGradient *gradient;
@end


@implementation AppSearchResultItem

@synthesize app=_app;

@synthesize lblTitle=_lblTitle, lblDate=_lblDate, imgThumbnail=_imgThumbnail, 
    btnFollow=_btnFollow, btnUnfollow=_btnUnfollow, backgroundView=_backgroundView;

+ (AppSearchResultItem *) item {
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
    [gradient release];
    gradient = nil;

    self.app = nil;
    [super dealloc];
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

    CGColorRef color = CGColorCreateGenericRGB(1, 1, 1, 1);
    self.backgroundView.layer.backgroundColor = color;
    CFRelease(color);
    
    self.backgroundView.layer.shadowRadius = 2.0;
    self.backgroundView.layer.shadowOffset = CGSizeMake(0, -2);
    self.backgroundView.layer.shadowOpacity = 0.5;
    self.backgroundView.layer.cornerRadius = 10.0;
    
    self.imgThumbnail.layer.masksToBounds = true;
    self.imgThumbnail.layer.cornerRadius = 10.0;
}

-(void) setFollowed:(BOOL)isFollowed {
    [self.btnFollow setHidden:isFollowed];
    [self.btnUnfollow setHidden:!isFollowed];
}


-(void) awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.imgThumbnail positioned:NSWindowAbove relativeTo:self.backgroundView];
}


#pragma mark - Private

- (void)drawBackground {
    [self.gradient drawInRect:self.bounds angle:90.0f];

    [[NSColor colorWithDeviceWhite:0.5f alpha:1.0f] set];
    NSRectFill(NSMakeRect(0.0f, 0.0f, self.bounds.size.width, 1.0f));
    
    [[NSColor colorWithDeviceWhite:0.93f alpha:1.0f] set];
    NSRectFill(NSMakeRect(0.0f, self.bounds.size.height - 1.0f, self.bounds.size.width, 1.0f));
}

- (NSGradient *)gradient {
    if(gradient == nil) {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.95 alpha:1.0f] 
                                                 endingColor:[NSColor colorWithDeviceWhite:1.0f alpha:1.0f]];
    }
    
    return gradient;
}

@end

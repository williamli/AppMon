//
//  AppReviewHeaderItem.m
//  AppMon
//
//  Created by Francis Chong on 11年6月2日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "AppReviewHeaderItem.h"
#import "UIImageView+WebCache.h"
#import "NSDateFormatter+Shared.h"

@interface AppReviewHeaderItem (Private)
- (NSGradient*) gradient;
- (void)drawBackground;
@end

@implementation AppReviewHeaderItem

@synthesize lblTitle=_lblTitle, lblInfo=_lblInfo, imgThumbnail=_imgThumbnail, btnFollow=_btnFollow, 
    btnUnfollow=_btnUnfollow, btnAppStore=_btnAppStore, backgroundView=_backgroundView;

+ (AppReviewHeaderItem *) item {
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

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [gradient release];
    gradient = nil;

    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.imgThumbnail positioned:NSWindowAbove relativeTo:self.backgroundView];

    [self.lblInfo setDrawsBackground:YES];
    [self.lblInfo setBackgroundColor:[NSColor colorWithDeviceWhite:0.97f alpha:1.0f]];
    [self.lblTitle setDrawsBackground:YES];
    [self.lblTitle setBackgroundColor:[NSColor colorWithDeviceWhite:0.97f alpha:1.0f]];
}

-(void) setTimeline:(Timeline*)theTimeline {
    if (theTimeline.total == 0) {
        [self.lblInfo setStringValue:@"No reviews yet"];
    } else {
        NSDateFormatter* formatter = [NSDateFormatter sharedUserDateTimeFormatter];
        [self.lblInfo setStringValue:[NSString stringWithFormat:@"%ld reviews, last review at %@", 
                                      theTimeline.total, [formatter stringFromDate:theTimeline.lastReviewDate]]];
    }
    [self.lblTitle setStringValue:theTimeline.app.title];
}

- (void)drawRect:(NSRect)rect {
    [self drawBackground];
    [super drawRect:rect];
}

-(void) setFollowed:(BOOL)isFollowed {
    [self.btnFollow setHidden:isFollowed];
    [self.btnUnfollow setHidden:!isFollowed];
}

#pragma mark - Private
- (NSGradient*) gradient {
    if (gradient == nil) {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceWhite:0.92f alpha:1.0f] 
                                                 endingColor:[NSColor colorWithDeviceWhite:0.97f alpha:1.0f]];
    }
    return gradient;
}

- (void)drawBackground {
    [[NSColor colorWithDeviceWhite:0.97f alpha:1.0f] set];
    NSRectFill(self.bounds);

    CGRect gradSize = CGRectMake(0, 0, 
                                 self.bounds.size.width, 32);

    [self.gradient drawInRect:gradSize angle:90.0f];
    
    [[NSColor colorWithDeviceWhite:0.5f alpha:1.0f] set];
    NSRectFill(NSMakeRect(0.0f, 0.0f, self.bounds.size.width, 1.0f));
    
    [[NSColor colorWithDeviceWhite:0.93f alpha:1.0f] set];
    NSRectFill(NSMakeRect(0.0f, self.bounds.size.height - 1.0f, self.bounds.size.width, 1.0f));
}


@end

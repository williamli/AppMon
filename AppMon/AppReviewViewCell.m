//
//  AppReviewViewCell.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppReviewViewCell.h"
#import "Review.h"

@interface AppReviewViewCell (Private)
- (void)drawBackground;
@end

@implementation AppReviewViewCell

@synthesize lblTitle=_lblTitle, lblMessage = _lblMessage, lblExtra = _lblExtra;

+ (AppReviewViewCell *) item {
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
    [_review release];
    _review = nil;

    [super dealloc];
}

-(void) setReview:(Review*)aReview {
    if (![_review isEqual:aReview]) {
        [self.lblTitle setStringValue:aReview.title];        
        [self.lblExtra setStringValue:[NSString stringWithFormat:@"by %@ - version %@ - %@", aReview.username, aReview.on_version, aReview.date]];
        [self.lblMessage setStringValue:aReview.text];
    } else {
        [self.lblTitle setStringValue:@""];        
        [self.lblExtra setStringValue:@""];
        [self.lblMessage setStringValue:@""];        
    }

    [_review release];
    _review = [aReview retain];
}


- (void)drawRect:(NSRect)rect {
    [self drawBackground];
    [super drawRect:rect];
}


// TODO: Add Report A Concern: https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/reportUserReviewConcern?userReviewId=428648584

- (void)drawBackground {
    [[NSColor whiteColor] set];
    NSRectFill(self.bounds);
    
    [[NSColor colorWithDeviceWhite:0.5f alpha:1.0f] set];
    NSRectFill(NSMakeRect(0.0f, 0.0f, self.bounds.size.width, 1.0f));
    
    [[NSColor colorWithDeviceWhite:0.93f alpha:1.0f] set];
    NSRectFill(NSMakeRect(0.0f, self.bounds.size.height - 1.0f, self.bounds.size.width, 1.0f));
}

@end

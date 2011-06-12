//
//  AppReviewViewCell.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "NS(Attributed)String+Geometrics.h"

#import "AppReviewViewCell.h"
#import "Review.h"
#import "Store.h"

@interface AppReviewViewCell (Private)
-(void)drawBackground;
+(NSString*) stars:(NSUInteger)numberOfStar;
@end

@implementation AppReviewViewCell

@synthesize lblTitle=_lblTitle, lblMessage = _lblMessage, lblExtra = _lblExtra, lblStar=_lblStar, imgFlag=_imgFlag;
@synthesize review=_review;

+ (AppReviewViewCell *) item {
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

+ (AppReviewViewCell *) itemWithSuperView:(JAListView*)listView review:(Review*)review {
    AppReviewViewCell* cell = [self item];
    [cell setReview:review];

    CGFloat padding         = cell.frame.size.height - cell.lblTitle.frame.size.height - cell.lblExtra.frame.size.height - cell.lblMessage.frame.size.height;
    CGRect  msgFrame        = [cell.lblMessage frame];

    // This is required to properly calculate height
    // Ref: http://lists.apple.com/archives/cocoa-dev/2006/Jan//msg00160.html
	gNSStringGeometricsTypesetterBehavior = NSTypesetterBehavior_10_2_WithCompatibility ;
    CGFloat msgWidth        = [listView frame].size.width - 34;
    CGFloat msgHeight       = [cell.lblMessage.stringValue heightForWidth:msgWidth
                                                                     font:[cell.lblMessage font]];
    cell.lblMessage.frame   = CGRectMake(msgFrame.origin.x, msgFrame.origin.y + msgFrame.size.height - msgHeight,
                                         msgWidth, msgHeight);

    cell.frame              = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 
                                         [listView frame].size.width, cell.lblTitle.frame.size.height + cell.lblExtra.frame.size.height + msgHeight + padding);
    
    return cell;
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
    self.review = nil;    
    self.lblTitle = nil;
    self.lblMessage = nil;
    self.lblExtra = nil;
    self.lblStar = nil;
    self.imgFlag = nil;

    [super dealloc];
}

-(void) setReview:(Review*)aReview {
    if (![_review isEqual:aReview]) {
        if (aReview == nil) {
            [self.lblTitle setStringValue:@""];        
            [self.lblExtra setStringValue:@""];
            [self.lblMessage setStringValue:@""];
            [self.lblStar setStringValue:@""];
            
        } else {
            [self.lblTitle setStringValue:aReview.title];        
            [self.lblExtra setStringValue:[NSString stringWithFormat:@"by %@ - version %@ - %@", 
                                           aReview.username, aReview.on_version, aReview.dateStr]];
            [self.lblMessage setStringValue:aReview.text];
            
            NSUInteger ratingStar = (NSUInteger) (aReview.rating * 5.0);
            [self.lblStar setStringValue:[AppReviewViewCell stars:ratingStar]];
            AppMonConfig* conf = [AppMonConfig sharedAppMonConfig];
            Store* store = [conf storeWithStorefront:aReview.store];
            NSString* flagCode = [store code];
            [self.imgFlag setImage:[NSImage imageNamed:flagCode]];
        }

        [_review release];
        _review = [aReview retain];
    }
}


- (void)drawRect:(NSRect)rect {
    [self drawBackground];
    [super drawRect:rect];
}

-(void) sizeToFit {
    CGFloat padding         = self.frame.size.height - self.lblTitle.frame.size.height - self.lblExtra.frame.size.height - self.lblMessage.frame.size.height;
    
    CGRect msgFrame         = [self.lblMessage frame];
    CGFloat msgHeight       = [self.lblMessage.stringValue heightForWidth:msgFrame.size.width
                                                                     font:[self.lblMessage font]];
    self.lblMessage.frame   = CGRectMake(msgFrame.origin.x, msgFrame.origin.y + msgFrame.size.height - msgHeight,
                                         msgFrame.size.width, msgHeight);

    self.frame              = CGRectMake(self.frame.origin.x, self.frame.origin.y, 
                                         self.frame.size.width, self.lblTitle.frame.size.height + self.lblExtra.frame.size.height + msgHeight + padding);
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

+(NSString*) stars:(NSUInteger)numberOfStar {
    NSMutableString* star = [NSMutableString stringWithCapacity:numberOfStar];
    int i = 0;
    for (i=0; i<numberOfStar; i++) {
        [star appendString:@"★"];
    }
    return star;
}

@end

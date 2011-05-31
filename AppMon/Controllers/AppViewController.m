//
//  AppViewController.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppViewController.h"
#import "UIImageView+WebCache.h"
#import "AppMonAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@interface AppViewController (Private) 

-(void) makeDropShadow;
@end

@implementation AppViewController

@synthesize app=_app;

@synthesize lblTitle=_lblTitle, lblDate=_lblDate, imgThumbnail=_imgThumbnail, 
    btnFollow=_btnFollow, btnUnfollow=_btnUnfollow, backgroundView=_backgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.app = nil;
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];

    [self makeDropShadow];
}

-(IBAction) followApp:(id)sender {
    NSLog(@"Follow The App: %@", self.app);

    AppService* appService = [AppMonAppDelegate instance].appService;
    [appService follow:self.app];
    [self setFollowed:YES];
}

-(IBAction) unfollowApp:(id)sender {
    NSLog(@"Unfollow The App: %@", self.app);

    AppService* appService = [AppMonAppDelegate instance].appService;
    [appService unfollow:self.app];
    [self setFollowed:NO];
}

-(void) setApp:(App*)newApp {
    if (![_app isEqual:newApp] && newApp != nil) {
        [_app release];
        _app = [newApp retain];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];        
        NSString* title = self.app.title ? self.app.title : @"";
        NSString* dateStr = self.app.releaseDate ? [dateFormatter stringFromDate:self.app.releaseDate] : @"";
        dateStr = dateStr ? dateStr : @"";
        [dateFormatter release];

        [self.lblTitle setStringValue:title];
        [self.imgThumbnail setImageWithURL:[NSURL URLWithString:self.app.iconUrl] 
                          placeholderImage:[NSImage imageNamed:@"app_default"]];
        [self.lblDate setStringValue:dateStr];
        
        AppService* appService = [AppMonAppDelegate instance].appService;
        [self setFollowed:[appService isFollowed:newApp]];
    }
}

-(void) setFollowed:(BOOL)isFollowed {
    [self.btnFollow setHidden:isFollowed];
    [self.btnUnfollow setHidden:!isFollowed];
}

-(void) makeDropShadow {
    // make drop shadow
    self.backgroundView.layer.backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
    self.backgroundView.layer.shadowRadius = 2.0;
    self.backgroundView.layer.shadowOffset = CGSizeMake(0, -2);
    self.backgroundView.layer.shadowOpacity = 0.5;
    self.backgroundView.layer.cornerRadius = 10.0;
    
    self.imgThumbnail.layer.masksToBounds = true;
    self.imgThumbnail.layer.cornerRadius = 10.0;

    [self.view addSubview:self.imgThumbnail positioned:NSWindowAbove relativeTo:self.backgroundView];
}

@end

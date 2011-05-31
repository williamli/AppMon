//
//  AppViewController.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppViewController.h"
#import "UIImageView+WebCache.h"

@implementation AppViewController

@synthesize app=_app;

@synthesize lblTitle=_lblTitle, lblDate=_lblDate, imgThumbnail=_imgThumbnail, 
    btnFollow=_btnFollow, btnUnfollow=_btnUnfollow;

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

-(IBAction) followApp:(id)sender {
    NSLog(@"Follow The App: %@", self.app);
}

-(IBAction) unfollowApp:(id)sender {
    NSLog(@"Unfollow The App: %@", self.app);
}

-(void) setApp:(App*)newApp {
    [_app release];
    _app = [newApp retain];
    
    [self.lblTitle setStringValue:self.app.title];
    [self.imgThumbnail setImageWithURL:[NSURL URLWithString:self.app.iconUrl] 
                      placeholderImage:[NSImage imageNamed:@"app_default"]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];    
    [self.lblDate setStringValue:[dateFormatter stringFromDate:self.app.releaseDate]];
    [dateFormatter release];
    
    // TODO Update Follow/Unfollow button
}


@end

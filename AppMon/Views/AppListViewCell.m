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

@implementation AppListViewCell

@synthesize lblTitle=_lblTitle, lblDate=_lblDate, imgThumbnail=_imgThumbnail, backgroundView=_backgroundView;
@synthesize app=_app;

- (id)initWithReusableIdentifier: (NSString*)identifier
{
	if((self = [super initWithReusableIdentifier:identifier]))
	{
        
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
    
    self.backgroundView.layer.backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 1);
    self.backgroundView.layer.shadowRadius = 2.0;
    self.backgroundView.layer.shadowOffset = CGSizeMake(0, -2);
    self.backgroundView.layer.shadowOpacity = 0.5;
    self.backgroundView.layer.cornerRadius = 10.0;
    
    self.imgThumbnail.layer.masksToBounds = true;
    self.imgThumbnail.layer.cornerRadius = 10.0;
    
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
    }
}

#pragma mark -
#pragma mark Reuse

- (void)prepareForReuse
{
    [_app release];
    _app = nil;

    [self.lblDate setStringValue:@""];
    [self.lblTitle setStringValue:@""];
    [self.imgThumbnail setHidden:YES];
}

@end

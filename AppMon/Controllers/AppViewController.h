//
//  AppViewController.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "App.h"


//  Handle a single app view
@interface AppViewController : NSViewController {
@private
    
}

@property (nonatomic, retain) App* app;

@property (nonatomic, retain) IBOutlet NSTextField*     lblTitle;
@property (nonatomic, retain) IBOutlet NSTextField*     lblDate;
@property (nonatomic, retain) IBOutlet NSImageView*     imgThumbnail;
@property (nonatomic, retain) IBOutlet NSButton*        btnFollow;
@property (nonatomic, retain) IBOutlet NSButton*        btnUnfollow;
@property (nonatomic, retain) IBOutlet NSView*          backgroundView;

-(IBAction) followApp:(id)sender;
-(IBAction) unfollowApp:(id)sender;

-(void) setApp:(App*)app;
-(void) setFollowed:(BOOL)isFollowed;

@end

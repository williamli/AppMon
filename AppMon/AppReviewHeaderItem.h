//
//  AppReviewHeaderItem.h
//  AppMon
//
//  Created by Francis Chong on 11年6月2日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "App.h"
#import "JAListViewItem.h"

@interface AppReviewHeaderItem : JAListViewItem {
@private
    NSGradient *gradient;
}

@property (nonatomic, retain) App* app;
@property (nonatomic, retain) IBOutlet NSTextField*     lblTitle;
@property (nonatomic, retain) IBOutlet NSImageView*     imgThumbnail;
@property (nonatomic, retain) IBOutlet NSButton*        btnFollow;
@property (nonatomic, retain) IBOutlet NSButton*        btnUnfollow;
@property (nonatomic, retain) IBOutlet NSButton*        btnAppStore;
@property (nonatomic, retain) IBOutlet NSView*          backgroundView;

+ (AppReviewHeaderItem *) item;

-(void) setFollowed:(BOOL)isFollowed;

@end

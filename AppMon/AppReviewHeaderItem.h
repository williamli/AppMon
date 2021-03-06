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
#import "Timeline.h"

@interface AppReviewHeaderItem : JAListViewItem {
@private
    NSGradient *gradient;
    
    NSTextField* _lblTitle;
    NSTextField* _lblInfo;
    
    NSImageView* _imgThumbnail;
    NSButton* _btnFollow;
    NSButton* _btnUnfollow;
    NSButton* _btnAppStore;
    NSView* _backgroundView;   
}

@property (nonatomic, retain) IBOutlet NSTextField*     lblTitle;
@property (nonatomic, retain) IBOutlet NSTextField*     lblInfo;
@property (nonatomic, retain) IBOutlet NSImageView*     imgThumbnail;
@property (nonatomic, retain) IBOutlet NSButton*        btnFollow;
@property (nonatomic, retain) IBOutlet NSButton*        btnUnfollow;
@property (nonatomic, retain) IBOutlet NSButton*        btnAppStore;
@property (nonatomic, retain) IBOutlet NSView*          backgroundView;

+ (AppReviewHeaderItem *) item;

-(void) setTimeline:(Timeline*)theTimeline;
-(void) setFollowed:(BOOL)isFollowed;

@end

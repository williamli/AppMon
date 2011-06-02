//
//  AppSearchResultItem.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "App.h"
#import "JAListViewItem.h"

@interface AppSearchResultItem : JAListViewItem {
@private
    NSGradient *gradient;
    
    App* _app;
    NSTextField* _lblTitle;
    NSTextField* _lblDate;
    NSImageView* _imgThumbnail;
    
    NSButton* _btnFollow;
    NSButton* _btnUnfollow;
    NSView* _backgroundView;
}

@property (nonatomic, retain) App* app;
@property (nonatomic, retain) IBOutlet NSTextField*     lblTitle;
@property (nonatomic, retain) IBOutlet NSTextField*     lblDate;
@property (nonatomic, retain) IBOutlet NSImageView*     imgThumbnail;
@property (nonatomic, retain) IBOutlet NSButton*        btnFollow;
@property (nonatomic, retain) IBOutlet NSButton*        btnUnfollow;
@property (nonatomic, retain) IBOutlet NSView*          backgroundView;

+ (AppSearchResultItem *) item;

-(void) setFollowed:(BOOL)isFollowed;

@end

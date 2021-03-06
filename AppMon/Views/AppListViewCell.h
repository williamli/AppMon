//
//  AppListViewCell.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JAListViewItem.h"
#import "App.h"
#import "Timeline.h"

@interface AppListViewCell : JAListViewItem {
@private
    NSGradient *gradient;
    NSGradient *selectedGradient;
    
    App*             _app;
    NSTextField*     _lblTitle;
    NSTextField*     _lblDate;
    NSTextField*     _lblCount;
    NSImageView*     _imgThumbnail;
    NSView*          _backgroundView;
}

@property (nonatomic, retain) App* app;
@property (nonatomic, retain) IBOutlet NSTextField*     lblTitle;
@property (nonatomic, retain) IBOutlet NSTextField*     lblDate;
@property (nonatomic, retain) IBOutlet NSTextField*     lblCount;

@property (nonatomic, retain) IBOutlet NSImageView*     imgThumbnail;
@property (nonatomic, retain) IBOutlet NSView*          backgroundView;

+(AppListViewCell *) appListViewCell;

-(void) setUnreadCount:(NSInteger) unread;
-(void) setApp:(App*)newApp timeline:(Timeline*)theTimeline;

@end

//
//  AppReviewViewCell.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAListViewItem.h"
#import "Review.h"

@interface AppReviewViewCell : JAListViewItem {
@private
    Review* _review;    
}

@property (nonatomic, retain) IBOutlet NSTextField*     lblTitle;
@property (nonatomic, retain) IBOutlet NSTextField*     lblMessage;
@property (nonatomic, retain) IBOutlet NSTextField*     lblExtra;

+ (AppReviewViewCell *) item;

-(void) setReview:(Review*)aReview;

@end

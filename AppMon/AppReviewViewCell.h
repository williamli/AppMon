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
@property (nonatomic, retain) IBOutlet Review*          review;

+ (AppReviewViewCell *) item;
+ (AppReviewViewCell *) itemWithSuperView:(JAListView*)listView review:(Review*)review;

-(void) setReview:(Review*)aReview;
-(void) sizeToFit;

@end

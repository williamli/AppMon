//
//  AppReviewNotFoundItem.h
//  AppMon
//
//  Created by Francis Chong on 11年6月2日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JAListViewItem.h"

@interface AppReviewNotFoundItem : JAListViewItem {
@private
    NSTextField* lblMessage;
}

@property (nonatomic, retain) IBOutlet NSTextField* lblMessage;

+(AppReviewNotFoundItem *) item;

@end

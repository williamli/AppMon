//
//  AppListViewController.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PXListView.h"

@interface AppListViewController : NSViewController <PXListViewDelegate> {
@private
}

@property (nonatomic, retain) IBOutlet PXListView* listApps;

@end

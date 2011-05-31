//
//  LoadingViewItem.h
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JAListViewItem.h"

@interface LoadingViewItem : JAListViewItem {
@private
    
}
@property (nonatomic, retain) IBOutlet NSProgressIndicator* progressView;

+ (LoadingViewItem *) item;

@end

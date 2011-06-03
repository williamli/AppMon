//
//  CountryListHeaderItem.h
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JAListViewItem.h"

@interface CountryListHeaderItem : JAListViewItem {
@private
    NSTextField* lblHeader;
    NSButton* btnCheckbox;
    NSGradient *gradient;
}

@property (nonatomic, retain) NSGradient*   gradient;
@property (nonatomic, retain) IBOutlet      NSButton* btnCheckbox;
@property (nonatomic, retain) IBOutlet      NSTextField* lblHeader;

+ (CountryListHeaderItem*) item;

@end

//
//  JAListViewItem.h
//  AppMon
//
//  Created by Chong Francis on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JAListViewItem.h"

@interface CountryListItem : JAListViewItem {
@private
    NSGradient *gradient;
    NSButton* btnCheckbox;
    NSImageView* imgFlag;
    NSTextField* lblCountry;
}

@property (nonatomic, retain) NSGradient* gradient;
@property (nonatomic, retain) IBOutlet NSButton* btnCheckbox;
@property (nonatomic, retain) IBOutlet NSImageView* imgFlag;
@property (nonatomic, retain) IBOutlet NSTextField* lblCountry;

+ (CountryListItem*) item;

-(void) setCountryName:(NSString*)countryName;
-(void) setFlagName:(NSString*)flagName;

@end

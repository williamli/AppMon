//
//  SearchViewController.h
//  AppMon
//
//  Created by Chong Francis on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SearchViewController : NSViewController {
@private
}

@property (nonatomic, retain) IBOutlet NSProgressIndicator* progressIndicator;

-(void) setLoading:(BOOL)isLoading;

@end

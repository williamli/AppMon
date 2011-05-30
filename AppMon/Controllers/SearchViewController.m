//
//  SearchViewController.m
//  AppMon
//
//  Created by Chong Francis on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController

@synthesize progressIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Public

-(void) setLoading:(BOOL)isLoading {
    if (isLoading) {
        [self.progressIndicator startAnimation:self];
    } else {
        [self.progressIndicator stopAnimation:self];
    }
}

@end

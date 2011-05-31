//
//  AppListViewController.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppListViewController.h"

#import "AppMonAppDelegate.h"
#import "App.h"
#import "AppListViewCell.h"

#define kAppListCellReuseIdentifier @"AppListViewCell"

@implementation AppListViewController

@synthesize listApps=_listApps;

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

-(void) awakeFromNib {
    [super awakeFromNib];
    self.listApps.usesLiveResize = NO;
}


#pragma mark - PXListViewDelegate 

- (NSUInteger)numberOfRowsInListView:(PXListView*)aListView {
    AppService* appService = [AppMonAppDelegate instance].appService;
    NSUInteger count = [[appService followedApps] count];
    return count;
}

- (CGFloat)listView:(PXListView*)aListView heightOfRow:(NSUInteger)row {
    return 80.0;
}

- (PXListViewCell*)listView:(PXListView*)aListView cellForRow:(NSUInteger)row {
    AppListViewCell *cell = (AppListViewCell*)[aListView dequeueCellWithReusableIdentifier:kAppListCellReuseIdentifier];
	if(!cell) {
		cell = [AppListViewCell cellLoadedFromNibNamed:@"AppListViewCell" reusableIdentifier:kAppListCellReuseIdentifier];
	}

    AppService* appService = [AppMonAppDelegate instance].appService;
    App* app = [[appService followedApps] objectAtIndex:row];
    [cell setApp:app];
    
    return cell;
}

@end

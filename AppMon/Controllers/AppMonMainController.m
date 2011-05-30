//
//  AppMonMainController.m
//  AppMon
//
//  Created by Chong Francis on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppMonMainController.h"


@implementation AppMonMainController

@synthesize titleBar, searchField;
@synthesize searchView, splitView;

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

-(IBAction) performSearch:(id)sender {
    NSString* query = [searchField stringValue];
    if ([query isEqualToString:@""]) {
        NSLog(@"Clear Text");
        [self setSearchModeEnabled:NO];
        
    } else {
        NSLog(@"Perform Search");
        [self setSearchModeEnabled:YES];

    }
}

-(void) setSearchModeEnabled:(BOOL)searchViewEnabled {
    [self.searchView setHidden:!searchViewEnabled];
    [self.splitView setHidden:searchViewEnabled];
}

#pragma mark - NSSplitViewDelegate

-(void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize: (NSSize)oldSize {
    CGFloat dividerThickness = [sender dividerThickness];
    NSRect leftRect = [[[sender subviews] objectAtIndex:0] frame];
    NSRect rightRect = [[[sender subviews] objectAtIndex:1] frame];
    NSRect newFrame = [sender frame];

	leftRect.size.height = newFrame.size.height;
	leftRect.origin = NSMakePoint(0, 0);
	rightRect.size.width = newFrame.size.width - leftRect.size.width - dividerThickness;
	rightRect.size.height = newFrame.size.height;
	rightRect.origin.x = leftRect.size.width + dividerThickness;

	[[[sender subviews] objectAtIndex:0] setFrame:leftRect];
	[[[sender subviews] objectAtIndex:1] setFrame:rightRect];
}

@end

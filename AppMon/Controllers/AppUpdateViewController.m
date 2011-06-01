//
//  AppUpdateViewController.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppUpdateViewController.h"

#import "AppReviewViewCell.h"
#import "AppMonAppDelegate.h"
#import <Quartz/Quartz.h>

@interface JAListView ()
- (void)standardLayoutRemoveViews:(NSArray *)viewsToRemove addViews:(NSArray *)viewsToAdd moveViews:(NSArray *)viewsToMove;
- (void)standardLayoutAnimated:(BOOL)animated removeViews:(NSArray *)viewsToRemove addViews:(NSArray *)viewsToAdd moveViews:(NSArray *)viewsToMove;
@end

@interface AppUpdateViewController (Private)
@end

@implementation AppUpdateViewController

@synthesize listUpdates=_listUpdates, app=_app, reviews=_reviews;

- (id)init
{
    self = [super init];
    if (self) {
        _loading = NO;
        _loaded = NO;
    }
    
    return self;
}

- (void)dealloc
{
    self.app = nil;
    self.reviews = nil;
    
    [_service release];
    _service = nil;

    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];

    _service = [[AppService alloc] init];
    _service.delegate = self;
}

-(void) loadAppReviews:(App*)newApp {
    if ([newApp isEqual:self.app]) {
        return;
    }
    
    self.app = newApp;

    NSLog(@"Load App Reviews: %@ (%@)", self.app.title, self.app.itemId);
    [self setLoading:YES];
    [_service fetchTimelineWithApp:self.app];
}

-(void) setLoading:(BOOL)newLoading {
    _loading = newLoading;
    _loaded = !newLoading;
}

-(void) setLoaded:(BOOL)newLoaded {
    _loaded = newLoaded;
    _loading = NO;
}

#pragma mark - JAListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JAListView *)listView {
    if (_loaded) {
        return [self.reviews count];
    } else {
        return 0;
    }
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
    Review* review = [self.reviews objectAtIndex:index];
    AppReviewViewCell* item = [AppReviewViewCell itemWithSuperView:listView review:review];
    return item;
}

#pragma mark - AppServiceDelegate

// invoke when timeline is changed
-(void) fetchTimelineFinished:(App*)app timeline:(Timeline*)timeline {
    self.reviews = timeline.reviews;

    NSLog(@"load reviews did finished:, %ld reviews loaded", [self.reviews count]);
    [self setLoaded:YES];

    [self.listUpdates reloadDataWithAnimation:^(NSView *newSuperview, NSArray *viewsToAdd, NSArray *viewsToRemove, NSArray *viewsToMove) {
        [self.listUpdates standardLayoutAnimated:YES removeViews:viewsToRemove addViews:viewsToAdd moveViews:viewsToMove];
        [self.listUpdates scrollPoint:NSZeroPoint];
    }];
}

// invoke when timeline update has failed
-(void) fetchTimelineFailed:(App*)app timeline:(Timeline*)timeline error:(NSError*)error {
    [self setLoaded:NO];
}

-(void) fetchTimelineNoMore:(App*)app timeline:(Timeline*)timeline {

}

@end

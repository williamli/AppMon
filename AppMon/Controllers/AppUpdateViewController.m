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
-(BOOL) shouldScrollToTopWhenUpdated;
@end

@implementation AppUpdateViewController

@synthesize listUpdates=_listUpdates, progressView=_progressView, app=_app, reviews=_reviews;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSViewBoundsDidChangeNotification 
                                                  object:self.listUpdates];
    
    self.app = nil;
    self.reviews = nil;
    
    [_service release];
    _service = nil;

    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];

    _service = [[AppService sharedAppService] retain];
    _service.delegate = self;

}

-(void) loadAppReviews:(App*)newApp {
    if ([newApp isEqual:self.app]) {
        return;
    }
    
    self.app = newApp;
    self.reviews = [NSArray array];

    NSLog(@"Load App Reviews: %@ (%@)", self.app.title, self.app.itemId);
    [self.listUpdates reloadDataAnimated:NO];
    [self setLoading:YES];
    [_service fetchTimelineWithApp:self.app];
}

-(void) setLoading:(BOOL)newLoading {
    _loading = newLoading;
    _loaded = !newLoading;

    if (newLoading) {
        [self.progressView startAnimation:self];
        [self.progressView setHidden:NO];
    } else {
        [self.progressView stopAnimation:self];
        [self.progressView setHidden:YES];
    }
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
    NSLog(@"load reviews: finished with %ld reviews loaded, %ld total, last review date: %@", 
            [timeline.reviews count], timeline.total, timeline.lastReviewDate);

    self.reviews = timeline.reviews;
    [self setLoaded:YES];
    [self setLoading:NO];

    [self.listUpdates reloadDataWithAnimation:^(NSView *newSuperview, NSArray *viewsToAdd, NSArray *viewsToRemove, NSArray *viewsToMove) {
        [self.listUpdates standardLayoutAnimated:YES removeViews:viewsToRemove addViews:viewsToAdd moveViews:viewsToMove];
        
        if ([self shouldScrollToTopWhenUpdated]) {
            [self.listUpdates scrollPoint:NSZeroPoint];
        }
    }];
}

-(void) fetchTimelineNoUpdate:(App*)app timeline:(Timeline*)timeline {
    NSLog(@"load reviews: no update");

    self.reviews = timeline.reviews;
    [self setLoaded:YES];
    [self setLoading:NO];

    [self.listUpdates reloadDataWithAnimation:^(NSView *newSuperview, NSArray *viewsToAdd, NSArray *viewsToRemove, NSArray *viewsToMove) {
        [self.listUpdates standardLayoutAnimated:YES removeViews:viewsToRemove addViews:viewsToAdd moveViews:viewsToMove];
        
        if ([self shouldScrollToTopWhenUpdated]) {
            [self.listUpdates scrollPoint:NSZeroPoint];
        }
    }];
}

// invoke when timeline update has failed
-(void) fetchTimelineFailed:(App*)app timeline:(Timeline*)timeline error:(NSError*)error {
    NSLog(@"load reviews: failed with error: %@", error);
    
    [self setLoaded:NO];
    [self setLoading:NO];
}

-(void) fetchTimelineNoMore:(App*)app timeline:(Timeline*)timeline {
    NSLog(@"load reviews: no more!");

    [self setLoaded:YES];
    [self setLoading:NO];
}

-(BOOL) shouldScrollToTopWhenUpdated {
    return YES;
}

@end

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
                                                  object:[self.listUpdates superview]];
    
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

    self.listUpdates.backgroundColor = [NSColor whiteColor];
    [[self.listUpdates superview] setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(boundsDidChange:) 
                                                 name:NSViewBoundsDidChangeNotification 
                                               object:[self.listUpdates superview]]; 
}

-(void) loadAppReviews:(App*)newApp {
    if ([newApp isEqual:self.app]) {
        return;
    }

    self.app = newApp;
    self.reviews = [NSArray array];

    NSLog(@"Load App Reviews: %@ (%@)", self.app.title, self.app.itemId);
    [self.listUpdates reloadDataAnimated:YES];
    [self setLoading:YES];
    [_service fetchTimelineWithApp:self.app];
}

-(void) loadMoreAppReviews {
    if (self.app == nil) {
        NSLog(@"no apps selected");
        return;
    }
    
    if (_loading) {
        NSLog(@"currently loading, ignore load more");
        return;
    }
    
    Timeline* tl = [_service timelineWithApp:self.app];
    if (![tl hasMoreReviews]) {
        NSLog(@"no more reviews to be loaded");
        return;
    }

    NSLog(@"Load More App Reviews: %@ (%@)", self.app.title, self.app.itemId);
    [self setLoading:YES];
    [_service fetchTimelineWithApp:self.app more:YES];
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

#pragma mark - NSViewBoundsDidChangeNotification

-(void) boundsDidChange:(NSNotification*)aNotification  {
    CGRect bound = [[aNotification object] bounds];
    CGFloat height = self.listUpdates.frame.size.height;

    if ((bound.origin.y + bound.size.height)>=height) {
        NSLog(@" scroll view reached bottom!");
        [self loadMoreAppReviews];
    }
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
-(void) fetchTimelineFinished:(App*)app timeline:(Timeline*)timeline loadMore:(BOOL)isLoadMore {   
    NSLog(@"load reviews: finished with %ld reviews loaded, %ld total, last review date: %@", 
            [timeline.reviews count], timeline.total, timeline.lastReviewDate);

    self.reviews = timeline.reviews;
    [self setLoaded:YES];
    [self setLoading:NO];

    [self.listUpdates reloadDataWithAnimation:^(NSView *newSuperview, NSArray *viewsToAdd, NSArray *viewsToRemove, NSArray *viewsToMove) {
        [self.listUpdates standardLayoutAnimated:YES removeViews:viewsToRemove addViews:viewsToAdd moveViews:viewsToMove];
        if ([self shouldScrollToTopWhenUpdated] && !isLoadMore) {
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

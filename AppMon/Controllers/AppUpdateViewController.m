//
//  AppUpdateViewController.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Quartz/Quartz.h>

#import "AppUpdateViewController.h"

#import "AppReviewViewCell.h"
#import "AppMonAppDelegate.h"
#import "AppReviewNotFoundItem.h"

@interface JAListView ()
- (void)standardLayoutRemoveViews:(NSArray *)viewsToRemove addViews:(NSArray *)viewsToAdd moveViews:(NSArray *)viewsToMove;
- (void)standardLayoutAnimated:(BOOL)animated removeViews:(NSArray *)viewsToRemove addViews:(NSArray *)viewsToAdd moveViews:(NSArray *)viewsToMove;
@end

@interface AppUpdateViewController (Private)
-(BOOL) shouldScrollToTopWhenUpdated;
-(void) loadAppReviews:(App*)newApp force:(BOOL)forceLoad;
@end

@implementation AppUpdateViewController

@synthesize listUpdates=_listUpdates, progressView=_progressView, timeline=_timeline;

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSViewBoundsDidChangeNotification 
                                                  object:[self.listUpdates superview]];
    
    self.timeline = nil;
    
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
    [self loadAppReviews:newApp force:NO];
}

// Save as loadAppReviews:, with additional parameter 'force'
// loadAppReviews: will not load an app if it has already the current app
// force will make the system load reviews again even it is current app
-(void) loadAppReviews:(App*)newApp force:(BOOL)forceLoad {
    if ([newApp isEqual:self.timeline.app] && !forceLoad) {
        return;
    }
    
    // set timeline
    self.timeline = [_service timelineWithApp:newApp];
    [self.listUpdates reloadData];
    [self setLoading:YES];
    [_service fetchTimelineWithApp:newApp];
}

-(void) loadMoreAppReviews {
    if (self.timeline == nil) {
        NSLog(@"no apps selected");
        return;
    }
    
    if (self.timeline.loading) {
        NSLog(@"currently loading, ignore load more");
        return;
    }
    
    if (![self.timeline hasMoreReviews]) {
        NSLog(@"no more reviews to be loaded");
        return;
    }

    [self setLoading:YES];
    [_service fetchTimelineWithApp:self.timeline.app more:YES];
}

-(void) setLoading:(BOOL)newLoading {
    self.timeline.loading = newLoading;

    if (newLoading) {
        [self.progressView startAnimation:self];
        [self.progressView setHidden:NO];
    } else {
        [self.progressView stopAnimation:self];
        [self.progressView setHidden:YES];
    }
}

-(void) setLoaded:(BOOL)newLoaded {
    self.timeline.loaded = newLoaded;
    self.timeline.loading = NO;
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
    if (self.timeline && self.timeline.loaded) {
        NSUInteger reviewCount = [self.timeline.reviews count];
        if (reviewCount == 0) {
            return 1;            
        } else {
            return reviewCount;
        }
    } else {
        return 0;
    }
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
    if (self.timeline && self.timeline.loaded) {
        NSUInteger reviewCount = [self.timeline.reviews count];
        if (reviewCount == 0) {
            // NO Review found
            AppReviewNotFoundItem* item = [AppReviewNotFoundItem item];
            return item;
        } else {
            Review* review = [self.timeline.reviews objectAtIndex:index];
            AppReviewViewCell* item = [AppReviewViewCell itemWithSuperView:listView review:review];
            return item;
        }
    } else {
        Review* review = [self.timeline.reviews objectAtIndex:index];
        AppReviewViewCell* item = [AppReviewViewCell itemWithSuperView:listView review:review];
        return item;
    }
    
}

#pragma mark - AppServiceDelegate

// invoke when timeline is changed
-(void) fetchTimelineFinished:(App*)app timeline:(Timeline*)timeline loadMore:(BOOL)isLoadMore {   
    NSLog(@"load reviews: finished with %ld reviews loaded, %ld total, last review date: %@", 
            [timeline.reviews count], timeline.total, timeline.lastReviewDate);

    [self setLoading:NO];
    [self setLoaded:YES];
    [self.listUpdates reloadData];
}

-(void) fetchTimelineNoUpdate:(App*)app timeline:(Timeline*)timeline {
    NSLog(@"load reviews: no update");

    [self setLoading:NO];
    [self setLoaded:YES];
    [self.listUpdates reloadData];
}

// invoke when timeline update has failed
-(void) fetchTimelineFailed:(App*)app timeline:(Timeline*)timeline error:(NSError*)error {
    NSLog(@"load reviews: failed with error: %@", error);
    [self setLoading:NO];    
    [self setLoaded:NO];
}

-(void) fetchTimelineNoMore:(App*)app timeline:(Timeline*)timeline {
    NSLog(@"load reviews: no more!");
    [self setLoading:NO];
    [self setLoaded:YES];
    [self.listUpdates reloadData];
}

// invoked when timeline is reset - such as changing store
// reload the selected timeline
-(void) timelinesReset {
    if (self.timeline) {
        NSLog(@"timeline reset - reload app reviews");
        [self loadAppReviews:self.timeline.app force:YES];
    }
}

#pragma mark - Private

-(BOOL) shouldScrollToTopWhenUpdated {
    return YES;
}

@end

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
#import "AppReviewHeaderItem.h"

@interface JAListView ()
- (void)standardLayoutRemoveViews:(NSArray *)viewsToRemove addViews:(NSArray *)viewsToAdd moveViews:(NSArray *)viewsToMove;
- (void)standardLayoutAnimated:(BOOL)animated removeViews:(NSArray *)viewsToRemove addViews:(NSArray *)viewsToAdd moveViews:(NSArray *)viewsToMove;
@end

@interface AppUpdateViewController (Private)
-(BOOL) shouldScrollToTopWhenUpdated;
-(void) loadAppReviews:(App*)newApp force:(BOOL)forceLoad;
- (JAListViewItem *) timelineHeaderItem:(Timeline*)theTimeline;
-(AppReviewNotFoundItem*) notFoundItem;

-(void) fetchTimelineFinished:(NSNotificationCenter*)aNotification;
-(void) fetchTimelineNoUpdate:(NSNotificationCenter*)aNotification;
-(void) fetchTimelineFailed:(NSNotificationCenter*)aNotification;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:AppServiceNotificationStoreChanged 
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:AppServiceNotificationFetchFailed
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:AppServiceNotificationFetchFinished 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:AppServiceNotificationFetchNoUpdate
                                                  object:nil];
    
    self.timeline = nil;
    
    [_notFoundItem release];
    _notFoundItem = nil;

    [_service release];
    _service = nil;

    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];

    _service = [[AppService sharedAppService] retain];

    self.listUpdates.backgroundColor = [NSColor whiteColor];
    [[self.listUpdates superview] setPostsBoundsChangedNotifications:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(boundsDidChange:) 
                                                 name:NSViewBoundsDidChangeNotification 
                                               object:[self.listUpdates superview]]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeDidChanged:) 
                                                 name:AppServiceNotificationStoreChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchTimelineFinished:) 
                                                 name:AppServiceNotificationFetchFinished 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchTimelineFailed:) 
                                                 name:AppServiceNotificationFetchFailed
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchTimelineFinished:)
                                                 name:AppServiceNotificationFetchNoUpdate
                                               object:nil];
}

-(void) loadAppReviews:(App*)newApp {
    [self loadAppReviews:newApp force:NO];
}

// Save as loadAppReviews:, with additional parameter 'force'
// loadAppReviews: will not load an app if it has already the current app
// force will make the system load reviews again even it is current app
-(void) loadAppReviews:(App*)newApp force:(BOOL)forceLoad {
    NSLog(@"load reviews for app: %@", newApp.title);
    
    if ([newApp isEqual:self.timeline.app] && !forceLoad) {
        return;
    }
    
    // set timeline
    self.timeline = [_service timelineWithApp:newApp];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        [self.listUpdates reloadData];
        [pool release];
    });

    [self setLoading:YES];
    [_service fetchTimelineWithApp:newApp];
}

-(void) loadMoreAppReviews {
    if (self.timeline == nil) {
        NSLog(@"no apps selected");
        return;
    }
    
    if (![self.timeline hasMoreReviews]) {
        NSLog(@"no more reviews to be loaded");
        return;
    }

    [self setLoading:YES];
    [_service fetchTimelineWithApp:self.timeline.app more:YES];
}

-(void) unloadReviews {
    self.timeline = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        [self.listUpdates reloadData];
        [pool release];
    });
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

// the list has been scrolled
-(void) boundsDidChange:(NSNotification*)aNotification  {
    CGRect bound = [[aNotification object] bounds];
    CGFloat height = self.listUpdates.frame.size.height;

    if ((bound.origin.y + bound.size.height)>=height) {
        if (self.timeline) {
            [self loadMoreAppReviews];
            [_service markAppAsRead:self.timeline.app];
        }
    }
    
    if (bound.origin.y == 0) {
        if (self.timeline) {
            [_service markAppAsRead:self.timeline.app];
        }
    }
}

#pragma mark - JAListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JAListView *)listView {
    if (self.timeline && self.timeline.loaded) {
        NSUInteger reviewCount = [self.timeline.reviews count];
        if (reviewCount == 0) {
            return 2;            
        } else {
            return reviewCount + 1;
        }
    } else {
        return 0;
    }
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
    NSUInteger reviewCount = [self.timeline.reviews count];
    if (index == 0) {
        return [self timelineHeaderItem:self.timeline];
    } else {
        if (reviewCount == 0) {
            return [self notFoundItem];
        } else {
            Review* review = [self.timeline.reviews objectAtIndex:index-1];
            AppReviewViewCell* item = [AppReviewViewCell itemWithSuperView:listView review:review];
            return item;
        }
    }
}

#pragma mark - AppServiceDelegate

// invoke when timeline is changed
-(void) fetchTimelineFinished:(NSNotificationCenter*)aNotification{
//(App*)app timeline:(Timeline*)timeline loadMore:(BOOL)isLoadMore {   
//    NSLog(@"load reviews: finished with %ld reviews loaded, %ld total, last review date: %@", 
//            [timeline.reviews count], timeline.total, timeline.lastReviewDate);

    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        [self setLoading:NO];
        [self setLoaded:YES];   
        [self.listUpdates reloadData];
        [pool release];
    });
}

// invoke when timeline update has failed
-(void) fetchTimelineFailed:(NSNotificationCenter*)aNotification{
//    NSLog(@"load reviews: failed with error: %@", error);
//    [self setLoading:NO];    
//    [self setLoaded:NO];
}

-(void) fetchTimelineNoMore:(NSNotificationCenter*)aNotification{
    NSLog(@"load reviews: no more!");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        [self.listUpdates reloadData];
        [self setLoading:NO];
        [self setLoaded:YES];
        [pool release];
    });
}

#pragma mark - Button Actions

-(void) follow:(id)sender {
    AppReviewHeaderItem* item = (AppReviewHeaderItem*) [sender superview];
    [_service follow:self.timeline.app];
    [item setFollowed:YES];
    [item setNeedsDisplay:YES];
}

-(void) unfollow:(id)sender {
    AppReviewHeaderItem* item = (AppReviewHeaderItem*) [sender superview];
    [_service unfollow:self.timeline.app];
    [item setFollowed:NO];
    [item setNeedsDisplay:YES];
}

-(void) openAppStoreUrl:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%ld?mt=8", [self.timeline.app.itemId intValue]]]];
}

#pragma mark - Private

-(BOOL) shouldScrollToTopWhenUpdated {
    return YES;
}

- (JAListViewItem *) timelineHeaderItem:(Timeline*)theTimeline {
    AppReviewHeaderItem* header = [AppReviewHeaderItem item];
    [header setTimeline:theTimeline];
    [header setFollowed:[_service isFollowed:theTimeline.app]];
    [header.btnFollow setTarget:self];
    [header.btnFollow setAction:@selector(follow:)];
    [header.btnUnfollow setTarget:self];
    [header.btnUnfollow setAction:@selector(unfollow:)];    
    [header.btnAppStore setTarget:self];
    [header.btnAppStore setAction:@selector(openAppStoreUrl:)];
    return header;
}


// reload the selected timeline
-(void) storeDidChanged:(NSNotification*)aNotification {
    NSLog(@"store did changed, reload app reviews");
    if (self.timeline) {
        [self loadAppReviews:self.timeline.app force:YES];
    }
}

-(AppReviewNotFoundItem*) notFoundItem {
    if (!_notFoundItem) {
        _notFoundItem = [AppReviewNotFoundItem item];
    }
    return _notFoundItem;
}
@end

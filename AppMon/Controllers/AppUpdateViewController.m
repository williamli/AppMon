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

@interface AppUpdateViewController (Private)
-(void) loadAppReviewsDidFinished:(NSArray*)results;
-(void) loadAppReviewsDidFailed:(NSError*)error;
@end

@implementation AppUpdateViewController

@synthesize listUpdates=_listUpdates;

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
    [_reviews release];
    _reviews = nil;

    [_app release];
    _app = nil;
    
    [_api release];
    _api = nil;

    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];

    _api = [[AppStoreApi alloc] init];
}

-(void) loadAppReviews:(App*)app {
    if ([app isEqual:_app]) {
        return;
    }

    NSLog(@"Load App Reviews: %@ (%@)", app.title, app.itemId);
    [self setLoading:YES];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError* error = nil;
        NSInteger total;
        
        NSArray* reviews = [_api reviews:app.itemId 
                                    page:0 
                                   total:&total 
                                   error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLoading:NO];
            if (error) {
                [self loadAppReviewsDidFailed:error];
            } else {
                [self loadAppReviewsDidFinished:reviews];
            }
        });
    });
}

-(void) setLoading:(BOOL)newLoading {
    _loading = newLoading;
    _loaded = !newLoading;
}

-(void) setLoaded:(BOOL)newLoaded {
    _loaded = newLoaded;
    _loading = NO;
}

-(void) loadAppReviewsDidFinished:(NSArray*)theResults {
    NSLog(@"load reviews did finished: %@", theResults);
    [_reviews release];
    _reviews = [theResults retain];

    [self setLoaded:YES];
    [self.listUpdates reloadDataWithAnimation:^(NSView *newSuperview, NSArray *viewsToAdd, NSArray *viewsToRemove, NSArray *viewsToMove) {
        [self.listUpdates scrollPoint:NSZeroPoint];
    }];
}

-(void) loadAppReviewsDidFailed:(NSError*)error {
    NSLog(@"load reviews failed: %@", error);
    [self setLoaded:NO];
}

#pragma mark - JAListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JAListView *)listView {
    if (_loaded) {
        return [_reviews count];
    } else {
        return 0;
    }
}

- (JAListViewItem *)listView:(JAListView *)listView viewAtIndex:(NSUInteger)index {
    Review* review = [_reviews objectAtIndex:index];
    AppReviewViewCell* item = [AppReviewViewCell itemWithSuperView:listView review:review];
    return item;
}

@end

//
//  Timeline.m
//  AppMon
//
//  Created by Francis Chong on 11年6月1日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "Timeline.h"
#import "Review.h"

@implementation Timeline

@synthesize app;
@synthesize lastReviewDate, reviews, reviewResponses, total, unread;
@synthesize loaded, loading;

-(id) initWithApp:(App*)theApp
{
    self = [super init];
    if (self) {
        self.app = theApp;
        self.reviews = [NSMutableArray array];
        self.reviewResponses = [NSMutableDictionary dictionary];
        self.lastReviewDate = nil;
        self.total = 0;
        self.unread = 0;

        self.loaded = NO;
        self.loading = NO;
    }
    return self;
}

- (void)dealloc
{
    self.app = nil;
    self.lastReviewDate = nil;
    self.reviews = nil;
    self.reviewResponses = nil;

    [super dealloc];
}

-(void) addReviews:(NSArray*)newReviews fromHead:(BOOL)fromHead {
    @synchronized(self) {
        if (fromHead) {
            // insert to the head of timeline, use for 'refresh'
            // we should first reverse the review list (they were sorted by time already) and insert to head
            
            NSComparator descReviewSort = ^(id rev1, id rev2) {
                Review* r1 = rev1;
                Review* r2 = rev2;
                if (r1.position < r2.position) {
                    return (NSComparisonResult) NSOrderedDescending;
                } else if (r1.position > r2.position) {
                    return (NSComparisonResult) NSOrderedAscending;
                } else {
                    return (NSComparisonResult) NSOrderedSame;
                }
            }; 
            NSArray* revReviews = [newReviews sortedArrayUsingComparator:descReviewSort];
            for (Review* review in revReviews) {
                [self.reviews insertObject:review atIndex:0];
            }

        } else {
            // insert to end of timeline, used for 'initial load' or 'load more'
            [self.reviews addObjectsFromArray:newReviews];
        }
    }
}

-(void) reset {
    @synchronized(self) {
        NSLog(@"reset timeline - %@", self.app);
        [self.reviews removeAllObjects];
        [self.reviewResponses removeAllObjects];
        self.lastReviewDate = nil;
        self.total = 0;
        self.unread = 0;
        self.loaded = NO;
        self.loading = NO;
    }
}

-(BOOL) hasMoreReviews {
    for (ReviewResponse* resp in [self.reviewResponses allValues]) {
        if ([resp moreUrl] != nil) {
            return YES;
        }
    }
    return NO;
}

-(BOOL) hasMoreReviewsWithStore:(NSString*)store {
    ReviewResponse* response = [self.reviewResponses objectForKey:store];
    return response && [response moreUrl] != nil;
}

-(void) setUnread:(NSInteger)newUnread {
    [self.app setUnread:newUnread];
}

-(NSInteger) unread {
    return self.app.unread;
}

-(ReviewResponse*) responseWithStore:(NSString*)theStore {
    return [self.reviewResponses objectForKey:theStore];
}

-(void) setResponse:(ReviewResponse*)theResponse withStore:theStore {
    [self.reviewResponses setValue:theResponse forKey:theStore];
}

@end

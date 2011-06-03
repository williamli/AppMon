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
@synthesize lastReviewDate, reviews, moreUrls, total, unread;
@synthesize loaded, loading;

-(id) initWithApp:(App*)theApp
{
    self = [super init];
    if (self) {
        self.app = theApp;
        self.reviews = [NSMutableArray array];
        self.moreUrls = [NSMutableDictionary dictionary];
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
    self.moreUrls = nil;

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
        [self.moreUrls removeAllObjects];
        self.lastReviewDate = nil;
        self.total = 0;
        self.unread = 0;
        self.loaded = NO;
        self.loading = NO;
    }
}

-(BOOL) hasMoreReviews {
    for (NSString* url in [self.moreUrls allValues]) {
        return YES;
    }
    
    return NO;
}

-(BOOL) hasMoreReviewsWithStore:(NSString*)store {
    return [self.moreUrls objectForKey:store] != nil;
}

-(void) setUnread:(NSInteger)newUnread {
    [self.app setUnread:newUnread];
}

-(NSInteger) unread {
    return self.app.unread;
}

-(NSString*) moreUrlWithStore:(NSString*)store {
    return [self.moreUrls objectForKey:store];
}

-(void) setMoreUrl:(NSString*)theMoreUrl withStore:(NSString*)store {
    [self.moreUrls setValue:theMoreUrl forKey:store];
}

@end

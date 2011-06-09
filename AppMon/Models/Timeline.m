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
@synthesize lastReviewDate, reviews, reviewResponses, unread;
@synthesize loaded, loading;

-(id) initWithApp:(App*)theApp
{
    self = [super init];
    if (self) {
        self.app = theApp;
        self.reviews = [NSMutableArray array];
        self.reviewResponses = [NSMutableDictionary dictionary];
        self.lastReviewDate = nil;
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

-(void) addReviews:(NSArray*)newReviews {
    @synchronized(self) {
        for (Review* r in newReviews) {
            if (![self.reviews containsObject:r]) {
                [self.reviews addObjectsFromArray:newReviews];
            }
        }
        [self.reviews sortUsingSelector:@selector(compareReview:)];
    }
}

-(void) reset {
    @synchronized(self) {
        NSLog(@"reset timeline - %@", self.app);
        [self.reviews removeAllObjects];
        [self.reviewResponses removeAllObjects];
        self.lastReviewDate = nil;
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

-(void) setUnread:(NSUInteger)newUnread {
    [self.app setUnread:newUnread];
}

-(NSUInteger) unread {
    return self.app.unread;
}

-(NSUInteger) total {
    NSUInteger theTotal = 0;
    if (self.reviewResponses) {
        for (ReviewResponse* rev in [self.reviewResponses allValues]) {
            theTotal += rev.total;
        }
    }

    return theTotal;
}

-(ReviewResponse*) responseWithStore:(NSString*)theStore {
    return [self.reviewResponses objectForKey:theStore];
}

-(void) setResponse:(ReviewResponse*)theResponse withStore:theStore {
    [self.reviewResponses setValue:theResponse forKey:theStore];
}

-(NSArray*) responsesWithStoresWithMoreReviews {
    NSMutableArray* responses = [NSMutableArray array];
    for (ReviewResponse* rev in [self.reviewResponses allValues]) {
        if (rev.moreUrl != nil) {
            [responses addObject:rev];
        }
    }
    return responses;
}
@end

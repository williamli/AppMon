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

@synthesize app, lastReviewDate, reviews, total, page, ended;
@synthesize loaded, loading;

-(id) initWithApp:(App*)theApp
{
    self = [super init];
    if (self) {
        self.app = theApp;
        self.reviews = [NSMutableArray array];
        self.lastReviewDate = nil;
        self.total = 0;
        self.page = 0;

        self.ended = NO;
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
    [super dealloc];
}

-(void) addReviews:(NSArray*)newReviews fromHead:(BOOL)fromHead {
    @synchronized(self) {
        for (Review* review in newReviews) {
            if (![self.reviews containsObject:review]) {
                if (fromHead) {
                    [self.reviews insertObject:review atIndex:0];
                } else {
                    [self.reviews addObject:review];
                }
            }
        }
    }
}

-(BOOL) hasMoreReviews {
    NSUInteger fetched = ( self.page + 1 ) * kReviewsPerPage;
    return self.ended || self.total > fetched;
}

@end

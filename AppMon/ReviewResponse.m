//
//  ReviewResponse.m
//  AppMon
//
//  Created by Francis Chong on 11年6月3日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "ReviewResponse.h"


@implementation ReviewResponse

@synthesize total, averageUserRating, ratingCount, reviews, lastReviewDate, moreUrl, error;

- (id)init
{
    self = [super init];
    if (self) {
    }    
    return self;
}

- (void)dealloc
{
    self.reviews = nil;
    self.lastReviewDate = nil;
    self.moreUrl = nil;
    self.error = nil;
    [super dealloc];
}

@end

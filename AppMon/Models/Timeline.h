//
//  Timeline.h
//  AppMon
//
//  Created by Francis Chong on 11年6月1日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"

#define kReviewsPerPage         10

@interface Timeline : NSObject {
@private    
}

@property (nonatomic, retain) App* app;

@property (nonatomic, retain) NSDate* lastReviewDate;

@property (nonatomic, retain) NSMutableArray* reviews;

// last fetched page number
@property (nonatomic, assign) NSUInteger page;

// total number of reviews online
@property (nonatomic, assign) NSUInteger total;

-(id) initWithApp:(App*)app;

-(void) addReviews:(NSArray*)newReviews fromHead:(BOOL)fromHead;

-(BOOL) hasMoreReviews;

@end

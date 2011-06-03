//
//  Timeline.h
//  AppMon
//
//  Created by Francis Chong on 11年6月1日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"
#import "Store.h"

#define kReviewsPerPage         10

@interface Timeline : NSObject {
@private
    App* app;
    NSDate* lastReviewDate;
    NSMutableArray* reviews;
    NSMutableDictionary* moreUrls;
    NSUInteger total;
    
    BOOL loaded;
    BOOL loading;
}

#pragma mark - parameters

// app of this timeline
@property (nonatomic, retain) App* app;

#pragma mark - states

// last review date
@property (nonatomic, retain) NSDate* lastReviewDate;

// array of reviews of this timeline
@property (nonatomic, retain) NSMutableArray* reviews;

// URL to load more reviews
@property (nonatomic, retain) NSMutableDictionary* moreUrls;

// total number of reviews online
@property (nonatomic, assign) NSUInteger total;

// number of unread reviews
@property (nonatomic, assign) NSInteger unread;

// if this timeline is loaded
@property (nonatomic, assign) BOOL loaded;

// if this timeline is being loaded
@property (nonatomic, assign) BOOL loading;

#pragma mark - methods

// initialize the timeline with specified app
-(id) initWithApp:(App*)theApp;

// add reviews to this timeline
-(void) addReviews:(NSArray*)newReviews fromHead:(BOOL)fromHead;

// reset the timeline to initial state (when switching channel)
-(void) reset;

// if the timeline has more reviews
-(BOOL) hasMoreReviewsWithStore:(NSString*)store;

-(BOOL) hasMoreReviews;

-(NSString*) moreUrlWithStore:(NSString*)store;

-(void) setMoreUrl:(NSString*)moreUrl withStore:(NSString*)store;

@end

//
//  SearchViewController.m
//  AppMon
//
//  Created by Chong Francis on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "SearchViewController.h"
#import "AppViewController.h"
#import "AppSearchResultItem.h"
#import "AppSearchHeaderItem.h"

@interface SearchViewController (Private)
-(void) searchDidFinished:(NSArray*)results;
-(void) searchDidFailed:(NSError*)error;
@end

@implementation SearchViewController

@synthesize searchScrollView, progressIndicator, searchResultList, api, results;
@synthesize searchNotFoundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    self.api = nil;
    self.results = nil;
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.api = [[[AppStoreApi alloc] init] autorelease];
}

#pragma mark - Public

-(void) setNotFound:(BOOL)isNotFound {
    [self.searchNotFoundView setHidden:!isNotFound];
    [self.searchScrollView setHidden:isNotFound];
}

-(void) setLoading:(BOOL)isLoading {
    _loading = isLoading;
    if (isLoading) {
        [self.progressIndicator startAnimation:self];
    } else {
        [self.progressIndicator stopAnimation:self];
    }
    [self.progressIndicator setHidden:!isLoading];
    [self.searchResultList setHidden:isLoading];
}

-(void) search:(NSString*)query {
    NSLog(@"search: %@", query);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError* error = nil;
        NSInteger total;

        NSArray* searchResult = [self.api search:query 
                                            page:0 
                                           total:&total 
                                           error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLoading:NO];
            if (error) {
                [self searchDidFailed:error];
            } else {
                [self searchDidFinished:searchResult];
            }
        });
    });
}

#pragma mark - Private

-(void) searchDidFinished:(NSArray*)theResults {
    if ([theResults count] == 0) {
        NSLog(@"no search result");
        [self setNotFound:YES];
    } else {
        NSLog(@"search finished: %@", theResults);
        [self setNotFound:NO];
        self.results = theResults;
        [self.searchResultList reloadDataAnimated:YES];
    }
}

-(void) searchDidFailed:(NSError*)error {
    NSLog(@"search failed: %@", error);
}

#pragma mark - JASectionedListViewDataSource

- (NSUInteger)numberOfSectionsInListView:(JASectionedListView *)listView {
    return 1;
}

- (NSUInteger)listView:(JASectionedListView *)listView numberOfViewsInSection:(NSUInteger)section {
    return [results count];
}

- (JAListViewItem *)listView:(JAListView *)listView sectionHeaderViewForSection:(NSUInteger)section {
    AppSearchHeaderItem* item = [AppSearchHeaderItem item];
    [item.lblMessage setStringValue:[NSString stringWithFormat:@"%d search result loaded", [results count]]];
    [item setHidden:_loading];
    return item;
}

- (JAListViewItem *)listView:(JAListView *)listView viewForSection:(NSUInteger)section index:(NSUInteger)index {
    AppSearchResultItem* item = [AppSearchResultItem item];
    App* app = [results objectAtIndex:index];
    [item setApp:app];
    return item;
}


@end

//
//  SearchViewController.m
//  AppMon
//
//  Created by Chong Francis on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "SearchViewController.h"
#import "AppSearchResultItem.h"
#import "AppSearchHeaderItem.h"
#import "AppMonAppDelegate.h"
#import "AppService.h"
#import "AppMonConfig.h"

@interface SearchViewController (Private)
-(void) searchDidFinished:(NSArray*)results;
-(void) searchDidFailed:(NSError*)error;

@end

@implementation SearchViewController

@synthesize searchScrollView=_searchScrollView, progressIndicator=_progressIndicator, searchResultList=_searchResultList;
@synthesize api=_api, appService=_appService, results=_results;
@synthesize searchNotFoundView=_searchNotFoundView;
@synthesize error=_error;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    self.error = nil;
    self.appService = nil;
    self.api = nil;
    self.results = nil;
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.appService = [AppService sharedAppService];
    self.api = [AppStoreApi sharedAppStoreApi];    
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
        NSInteger total;

        NSArray* stores = [[AppMonConfig sharedAppMonConfig] enabledStores];
        NSArray* searchResult = [self.api searchByStores:stores
                                                   query:query 
                                                    page:0 
                                                   total:&total];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLoading:NO];
            [self searchDidFinished:searchResult];
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
    self.error = error;
    [self.searchResultList reloadDataAnimated:YES];
}

-(void) dismissSearch:(id)sender {
    [[AppMonAppDelegate instance].mainController setSearchModeEnabled:NO];
}

#pragma mark - Actions

-(void) follow:(id)sender {
    AppSearchResultItem* item = (AppSearchResultItem*) [sender superview];
    NSLog(@"Follow App: %@", item.app);
    [self.appService follow:item.app];
    [item setFollowed:YES];
    [item setNeedsDisplay:YES];
}

-(void) unfollow:(id)sender {
    AppSearchResultItem* item = (AppSearchResultItem*)  [sender superview];
    NSLog(@"Unfollow App: %@", item.app);
    [self.appService unfollow:item.app];
    [item setFollowed:NO];
    [item setNeedsDisplay:YES];
}

#pragma mark - JASectionedListViewDataSource

- (NSUInteger)numberOfSectionsInListView:(JASectionedListView *)listView {
    return 1;
}

- (NSUInteger)listView:(JASectionedListView *)listView numberOfViewsInSection:(NSUInteger)section {
    return [_results count];
}

- (JAListViewItem *)listView:(JAListView *)listView sectionHeaderViewForSection:(NSUInteger)section {
    AppSearchHeaderItem* item = [AppSearchHeaderItem item];
    [item setHidden:_loading];
    [item.btnProceed setTarget:self];
    [item.btnProceed setAction:@selector(dismissSearch:)];
    if (self.error) {
        [item.lblMessage setStringValue:[NSString stringWithFormat:@"Search Failed! (%@)", [self.error description]]];
    } else {
        [item.lblMessage setStringValue:[NSString stringWithFormat:@"%d search result loaded", [_results count]]];
    }
    return item;
}

- (JAListViewItem *)listView:(JAListView *)listView viewForSection:(NSUInteger)section index:(NSUInteger)index {
    AppSearchResultItem* item = [AppSearchResultItem item];
    App* app = [_results objectAtIndex:index];
    [item setApp:app];
    [item setFollowed:[self.appService isFollowed:app]];    
    [item.btnFollow setTarget:self];
    [item.btnFollow setAction:@selector(follow:)];    
    [item.btnUnfollow setTarget:self];
    [item.btnUnfollow setAction:@selector(unfollow:)];
    return item;
}


@end

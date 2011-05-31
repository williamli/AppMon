//
//  SearchViewController.m
//  AppMon
//
//  Created by Chong Francis on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "SearchViewController.h"
#import "AppViewController.h"

@interface SearchViewController (Private)
-(void) searchDidFinished:(NSArray*)results;
-(void) searchDidFailed:(NSError*)error;
@end

@implementation SearchViewController

@synthesize searchScrollView, progressIndicator, txtProgress, searchResultCollectionView, api;
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
    [super dealloc];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.api = [[[AppStoreApi alloc] init] autorelease];
    [self.searchScrollView setDocumentView:self.searchResultCollectionView];
}

#pragma mark - Public

-(void) setNotFound:(BOOL)isNotFound {
    [self.searchNotFoundView setHidden:!isNotFound];
    [self.searchScrollView setHidden:isNotFound];
}

-(void) setLoading:(BOOL)isLoading {
    if (isLoading) {
        [self.progressIndicator startAnimation:self];
    } else {
        [self.progressIndicator stopAnimation:self];
    }
    [self.progressIndicator setHidden:!isLoading];
    [self.txtProgress setHidden:!isLoading];
    [self.searchResultCollectionView setHidden:isLoading];
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

-(void) searchDidFinished:(NSArray*)results {
    if ([results count] == 0) {
        NSLog(@"no search result");
        [self setNotFound:YES];
    } else {
        NSLog(@"search finished: %@", results);
        [self setNotFound:NO];
        [self.searchResultCollectionView reloadDataWithItems:results emptyCaches:YES];
    }
}

-(void) searchDidFailed:(NSError*)error {
    NSLog(@"search failed: %@", error);
}

#pragma mark - BCCollectionViewDelegate

//CollectionView assumes all cells aer the same size and will resize its subviews to this size.
- (NSSize)cellSizeForCollectionView:(BCCollectionView *)collectionView {
    return NSMakeSize(220, 80);
}

//Return an empty ViewController, this might not be visible to the user immediately
- (NSViewController *)reusableViewControllerForCollectionView:(BCCollectionView *)collectionView {
    return [[[AppViewController alloc] initWithNibName:@"AppViewController" bundle:nil] autorelease];
}

//The CollectionView is about to display the ViewController. Use this method to populate the ViewController with data
- (void)collectionView:(BCCollectionView *)collectionView willShowViewController:(NSViewController *)viewController forItem:(id)anItem {
    App* app = (App*) anItem;
    AppViewController* appController = (AppViewController*) viewController;
    [appController setApp:app];
}

- (NSSize)insetMarginForSelectingItemsInCollectionView:(BCCollectionView *)collectionView {
    return NSMakeSize(0, 0);
}

- (BOOL)collectionViewShouldDrawSelections:(BCCollectionView *)collectionView {
    return NO;
}

- (BOOL)collectionViewShouldDrawHover:(BCCollectionView *)collectionView {
    return YES;
}

@end

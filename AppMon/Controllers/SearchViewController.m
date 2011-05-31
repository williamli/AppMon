//
//  SearchViewController.m
//  AppMon
//
//  Created by Chong Francis on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController (Private)
-(void) searchDidFinished:(NSArray*)results;
-(void) searchDidFailed:(NSError*)error;
@end

@implementation SearchViewController

@synthesize progressIndicator, txtProgress, api;

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
}

#pragma mark - Public

-(void) setLoading:(BOOL)isLoading {
    if (isLoading) {
        [self.progressIndicator startAnimation:self];
    } else {
        [self.progressIndicator stopAnimation:self];
    }
    
    [self.progressIndicator setHidden:!isLoading];
    [self.txtProgress setHidden:!isLoading];
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
    NSLog(@"search finished: %@", results);
}

-(void) searchDidFailed:(NSError*)error {
    NSLog(@"search failed: %@", error);
}

@end

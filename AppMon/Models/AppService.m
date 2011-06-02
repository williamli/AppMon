//
//  AppService.m
//  AppMon
//
//  Created by Francis Chong on 11年5月31日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppService.h"
#import "SynthesizeSingleton.h"

#import "App.h"
#import "AppStoreApi.h"
#import "AppMonAppDelegate.h"
#import "Timeline.h"

NSString * const AppServiceNotificationAppListChanged  = @"hk.ignition.mac.appmon.AppListChanged";
NSString * const AppServiceNotificationTimelineChanged = @"hk.ignition.mac.appmon.TimelineChanged";

@interface AppService (Private)
-(NSString*) saveFilePath;
@end

@implementation AppService

SYNTHESIZE_SINGLETON_FOR_CLASS(AppService);

@synthesize delegate=_delegate, store=_store;

- (id)init
{
    self = [super init];
    if (self) {
        [self load];
        _queue = dispatch_queue_create("hk.ignition.appmon", NULL);
        _timelines = [[NSMutableDictionary dictionary] retain];
    }
    
    return self;
}

- (void)dealloc
{
    dispatch_release(_queue);

    [_timelines release];
    _timelines = nil;

    [_apps release];
    _apps = nil;
    
    [_store release];
    _store = nil;
    
    [super dealloc];
}

-(void) follow:(App*)app {
    if (![self isFollowed:app]) {
        [_apps addObject:app];
        [_apps sortWithOptions:0 usingComparator:^(id id1, id id2){
            App* app1 = id1;
            App* app2 = id2;            
            return [app1.title compare:app2.title];
        }];
        [self save];
        [[NSNotificationCenter defaultCenter] postNotificationName:AppServiceNotificationAppListChanged 
                                                            object:self];
    }
}

-(void) unfollow:(App*)app {
    [_apps removeObject:app];
    [self save];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppServiceNotificationAppListChanged 
                                                        object:self];
}

-(NSArray*) followedApps {
    return _apps;
}

-(BOOL) isFollowed:(App*)app {
    return [_apps containsObject:app];
}

-(void) setStore:(NSString*)newStore {
    dispatch_sync(_queue, ^{
        [_store release];
        _store = [newStore retain];      

        for (Timeline* timeline in [_timelines allValues]) {
            [timeline reset];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(fetchTimelineNoMore:timeline:)]) {
                [self.delegate timelinesReset];
            }
        });
    });       
}

@end

@implementation AppService (Timeline)

-(void) fetchTimelineWithApp:(App*)app {
    [self fetchTimelineWithApp:app more:NO];
}

-(void) fetchTimelineWithApp:(App*)app more:(BOOL)loadMore {
    Timeline* timeline = [self timelineWithApp:app];
    if (loadMore && ![timeline hasMoreReviews]) {
        NSLog(@"timeline (%@) has no more reviews", app.title);
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.delegate respondsToSelector:@selector(fetchTimelineNoMore:timeline:)]) {
                [self.delegate fetchTimelineNoMore:app timeline:timeline];
            }
        });
        return;
    }

    dispatch_async(_queue, ^{
        NSInteger total;
        NSError* error = nil;
        NSDate* lastReviewDate = nil;

        AppStoreApi* api = [AppStoreApi sharedAppStoreApi];
        NSArray* reviews = [api reviewsByStore:self.store
                                         appId:app.itemId 
                                          page:(loadMore ? timeline.page+1 : 0)
                                         total:&total
                                lastReviewDate:&lastReviewDate
                                         error:&error];
        
        if (error) {
            NSLog(@"timeline of (%@) encounter error: %@", app.title, error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if([self.delegate respondsToSelector:@selector(fetchTimelineFailed:timeline:error:)]) {
                    [self.delegate fetchTimelineFailed:app timeline:timeline error:error];
                }
            });
            
        } else {
            BOOL shouldInsertFromHead = !loadMore;
            if (loadMore || timeline.lastReviewDate == nil || [timeline.lastReviewDate compare:lastReviewDate] == NSOrderedAscending) {
                NSLog(@"timeline of (%@) updated", app.title);
                [timeline addReviews:reviews fromHead:shouldInsertFromHead];

                if (!loadMore) {
                    timeline.unread = total - timeline.total;
                    timeline.total = total;
                    timeline.page = 0;
                    timeline.lastReviewDate = lastReviewDate;
                } else {
                    timeline.page = timeline.page+1;
                }
                
                if ([reviews count] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        timeline.ended = YES;
                        if([self.delegate respondsToSelector:@selector(fetchTimelineNoMore:timeline:)]) {
                            [self.delegate fetchTimelineNoMore:app timeline:timeline];
                        }
                    });
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([self.delegate respondsToSelector:@selector(fetchTimelineFinished:timeline:loadMore:)]) {
                            [self.delegate fetchTimelineFinished:app timeline:timeline loadMore:loadMore];
                        }
                    });
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:AppServiceNotificationTimelineChanged
                                                                    object:timeline];
            } else {
                NSLog(@"timeline of (%@) not updated", app.title);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([self.delegate respondsToSelector:@selector(fetchTimelineNoUpdate:timeline:)]) {
                        [self.delegate fetchTimelineNoUpdate:app timeline:timeline];
                    }
                });
            } 
        }
    });
}

-(Timeline*) timelineWithApp:(App*)app {   
    Timeline* timeline = [_timelines objectForKey:app.itemId];
    if (!timeline) {        
        timeline = [[[Timeline alloc] initWithApp:app] autorelease];
        [_timelines setValue:timeline forKey:app.itemId];
    }

    return timeline;
}

@end

@implementation AppService (Persistence)

-(void) save {
    NSString* savePath = [self saveFilePath];
    BOOL result = [NSKeyedArchiver archiveRootObject:_apps 
                                              toFile:savePath];
    if (!result) {
        NSLog(@"WARN: Failed saving AppService: %@", savePath);
    }
    
}

-(void) load {
    NSString* savePath = [self saveFilePath];
    NSFileManager* manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:savePath]) {
        NSLog(@"load config file: %@", savePath);
        [_apps release];
        _apps = [[NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:savePath]] retain];
        [_apps sortWithOptions:0 usingComparator:^(id id1, id id2){
            App* app1 = id1;
            App* app2 = id2;            
            return [app1.title compare:app2.title];
        }];
        
        return;
    }

    // create initial empty data record
    NSLog(@"initialize config  file");
    [_apps release];
    _apps = [[NSMutableArray array] retain];
    [self save];        

}

// save path for app mon config file
// create intermediate directories if needed
-(NSString*) saveFilePath {
    NSBundle* bundle = [NSBundle mainBundle];
    NSDictionary* info = [bundle infoDictionary];
    NSString* bundleName = [info objectForKey:@"CFBundleName"];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true);
    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleName];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSError* error;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"ERROR: cannot create config file path: %@, error=%@", path, error);
        }
    }
    
    return [path stringByAppendingFormat:@"/appservice.plist"];   
}

@end

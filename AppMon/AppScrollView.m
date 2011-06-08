//
//  AppScrollView.m
//  AppMon
//
//  Created by Chong Francis on 11年6月8日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppScrollView.h"
#import "AppScroller.h"

@implementation AppScrollView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    [self setWantsLayer:YES];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setWantsLayer:YES];
    return self;
}

- (void)tile {
    [super tile];
    [[self contentView] setFrame:[self bounds]];
}


@end

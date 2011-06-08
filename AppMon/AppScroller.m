//
//  AppScroller.m
//  AppMon
//
//  Created by Francis Chong on 11年6月8日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppScroller.h"


@implementation AppScroller

+(CGFloat) scrollerWidth{
    return 5;
}

+(CGFloat) scrollerWidthForControlSize:(NSControlSize)controlSize{
    return 5;
}

-(id) initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    [self setArrowsPosition:NSScrollerArrowsNone];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setArrowsPosition:NSScrollerArrowsNone];
    return self;
}

-(id) init{
    self = [super init];
    [self setArrowsPosition:NSScrollerArrowsNone];
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSDrawWindowBackground([self bounds]);
    [self drawKnob];
}

- (void)drawKnob{
    NSRect knobRect = [self rectForPart:NSScrollerKnob];
    NSRect newRect = NSMakeRect((knobRect.size.width - [AppScroller scrollerWidth]) / 2, knobRect.origin.y, 
                                [AppScroller scrollerWidth], knobRect.size.height);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:2 yRadius:2];
    [[NSColor grayColor] set];
    [path fill];
}

- (NSUsableScrollerParts)usableParts {
	return NSAllScrollerParts;
}
@end

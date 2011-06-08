//
//  AppScroller.m
//  AppMon
//
//  Created by Francis Chong on 11年6月8日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "AppScroller.h"

@interface NSScroller (AppScrollerExt)

+(CGFloat) scrollerWidth;

+(CGFloat) scrollerWidthForControlSize:(NSControlSize)controlSize;

@end

@implementation NSScroller (AppScrollerExt)

+(CGFloat) scrollerWidth{
    return 12;
}

+(CGFloat) scrollerWidthForControlSize:(NSControlSize)controlSize{
    return 12;
}

@end

@implementation AppScroller

+(CGFloat) scrollerWidth{
    return 6;
}

+(CGFloat) scrollerWidthForControlSize:(NSControlSize)controlSize{
    return 6;
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
    [self drawKnob];
}

- (void)drawKnob{
    NSRect knobRect = [self rectForPart:NSScrollerKnob];
    NSRect newRect = NSMakeRect((knobRect.size.width - [AppScroller scrollerWidth]) / 2, knobRect.origin.y, 
                                [AppScroller scrollerWidth], knobRect.size.height);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:3 yRadius:3];
    [[NSColor colorWithCalibratedRed:0.2 green:0.2 blue:0.2 alpha:0.5] set];
    [path fill];
}

- (NSUsableScrollerParts)usableParts {
	return NSAllScrollerParts;
}

@end

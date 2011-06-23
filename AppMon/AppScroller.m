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
    return 14;
}

+(CGFloat) scrollerWidthForControlSize:(NSControlSize)controlSize{
    return 14;
}

@end

@implementation AppScroller

+(CGFloat) scrollerWidth{
    return 8;
}

+(CGFloat) scrollerWidthForControlSize:(NSControlSize)controlSize{
    return 8;
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
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:4 yRadius:4];
    [[NSColor colorWithCalibratedRed:0.2f green:0.2f blue:0.2f alpha:0.5f] set];
    [path fill];
}

- (NSUsableScrollerParts)usableParts {
	return NSAllScrollerParts;
}

@end

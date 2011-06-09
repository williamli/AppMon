//
//  NSArray+RemoveDup.m
//  AppMon
//
//  Created by Chong Francis on 11年6月9日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "NSMutableArray+IGUtils.h"

@implementation NSMutableArray (IGUtils)

-(void) unique {
    NSArray* resultsCopy = [self copy];
    NSInteger index = [resultsCopy count] - 1;
    for (id object in [resultsCopy reverseObjectEnumerator]) {
        if ([self indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [self removeObjectAtIndex:index];
        }
        index--;
    }
    [resultsCopy release];
}
  
@end

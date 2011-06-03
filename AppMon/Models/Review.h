//
//  Review.h
//  AppMon
//
//  Created by Francis Chong on 11年5月30日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Review : NSObject <NSCoding> {
@private
    CGFloat _rating;
    NSString* _text;
    NSString* _title;
    NSString* _username;
    NSString* _date;
    NSUInteger _position;
    NSString* _on_version;
    NSString* _store;
}

@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* date;
@property (nonatomic, assign) NSUInteger position;
@property (nonatomic, retain) NSString* on_version;
@property (nonatomic, retain) NSString* store;

-(id) initWithPlist:(NSDictionary*)plist store:(NSString*)aStore;

@end

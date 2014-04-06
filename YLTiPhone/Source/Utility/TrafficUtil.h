//
//  TrafficUtil.h
//  POS2iPhone
//
//  Created by  STH on 4/27/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrafficUtil : NSObject

#define TYPE_SEND           1
#define TYPE_RECEIVE        2

+ (TrafficUtil *) sharedInstance;

- (void) setTraffic:(int) type length:(double) length;
- (NSDictionary *) getTraffic;

@end

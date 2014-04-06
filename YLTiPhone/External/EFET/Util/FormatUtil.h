//
//  FormatUtil.h
//  POS2iPhone
//
//  Created by  STH on 12/26/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Util.h"

@interface FormatUtil : NSObject

+ (NSString *) formatAmount:(NSString *) amount;

+ (NSString *) formatNumeric:(NSString *) number withLength:(int) length;

+ (NSString *) formatAlpha:(NSString *) str withLength:(int) length;

+ (NSString *) fillZeroLeft:(NSString *) value withLength:(int) length;

@end

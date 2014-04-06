//
//  FieldType.h
//  POS2iPhone
//
//  Created by  STH on 12/26/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldType : NSObject

#define kFieldTypeArray @"NUMERIC", @"ALPHA", @"_ALPHA", @"ALPHA_",@"LLVAR",@"LLLVAR",@"LLNVAR",@"LLLNVAR",@"DATE10",@"DATE4",@"DATE_EXP",@"TIME",@"AMOUNT", nil

typedef enum {
    NUMERIC,
    ALPHA,
    _ALPHA,
    ALPHA_,
    
    LLVAR,
    LLLVAR,
    LLNVAR,
    LLLNVAR,
    
    DATE10,
    DATE4,
    DATE_EXP,
    TIME,
    AMOUNT
    
} kFieldType;


+ (NSString*) fieldTypeEnumToString:(kFieldType)enumVal;

+ (kFieldType) fieldTypeStringToEnum:(NSString*)strVal;

@end

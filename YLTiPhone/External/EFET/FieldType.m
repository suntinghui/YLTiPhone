//
//  FieldType.m
//  POS2iPhone
//
//  Created by  STH on 12/26/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "FieldType.h"

@implementation FieldType

+ (NSString*) fieldTypeEnumToString:(kFieldType)enumVal
{
    NSArray *fieldTypeArray = [[NSArray alloc] initWithObjects:kFieldTypeArray];
    return [fieldTypeArray objectAtIndex:enumVal];
}

+ (kFieldType) fieldTypeStringToEnum:(NSString*)strVal
{
    NSArray *fieldTypeArray = [[NSArray alloc] initWithObjects:kFieldTypeArray];
    NSUInteger n = [fieldTypeArray indexOfObject:strVal];
    if(n < 1) n = NUMERIC;
    return (kFieldType) n;
}

@end

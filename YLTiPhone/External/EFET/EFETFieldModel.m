//
//  FieldModel.m
//  POS2iPhone
//
//  Created by  STH on 12/26/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "EFETFieldModel.h"
#import "FieldType.h"
#import "FormatUtil.h"
#import "ConvertUtil.h"

@implementation EFETFieldModel

@synthesize dataType;
@synthesize value;
@synthesize length;

- (id) initWithDatatype:(NSString *)type value:(NSString *) theValue length:(int) theLength
{
    if (self = [super init]) {
        self.dataType = type;
        self.value = theValue;
        self.length = theLength;
    }
    
    return self;
}

- (NSString *)description
{
    if (value == nil){
        NSLog(@"Value is null !!!");
        
        return @"VALUE_IS_NULL";
    }
    
    NSString *str = @"";
    
    if ([self.dataType isEqualToString:[FieldType fieldTypeEnumToString:AMOUNT]])
    {
        str = [FormatUtil formatAmount:self.value];
        return str;
    } else if ([self.dataType isEqualToString:[FieldType fieldTypeEnumToString:NUMERIC]]) {
        // 数字长度不足左补0
        str = [FormatUtil formatNumeric:self.value withLength:self.length];
        return str;
    } else if ([self.dataType isEqualToString:[FieldType fieldTypeEnumToString:ALPHA]]) {
        // 长度不足右补空格
        str = [FormatUtil formatAlpha:self.value withLength:self.length];
        return str;
    }
    
    return self.value;
}

@end

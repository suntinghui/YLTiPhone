//
//  FormatUtil.m
//  POS2iPhone
//
//  Created by  STH on 12/26/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "FormatUtil.h"
#import "ConvertUtil.h"
#include "Util.h"

@implementation FormatUtil

+ (NSString *) formatAmount:(NSString *)amount
{
    NSString *tempStr = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *tempMutableStr = [NSMutableString stringWithString:tempStr];
    if ([tempStr rangeOfString:@"."].location == NSNotFound) {
        [tempMutableStr appendString:@"00"];
        
    } else if ([tempStr rangeOfString:@"."].location == tempStr.length - 1) {
        [tempMutableStr appendString:@"00"];
        
    } else if ([tempStr rangeOfString:@"."].location == tempStr.length - 2) {
        [tempMutableStr appendString:@"0"];
        
    } else if ([tempStr rangeOfString:@"."].location == tempStr.length - 3) {
    }
    
    tempMutableStr = [NSMutableString stringWithString:[tempMutableStr stringByReplacingOccurrencesOfString:@"." withString:@""]];
    
    int l = 12 - [tempMutableStr length];
    for (int i=0; i<l; i++) {
        [tempMutableStr insertString:@"0" atIndex:0];
    }
    
    return tempMutableStr;
}

// 左补0
+ (NSString *) formatNumeric:(NSString *) number withLength:(int) length
{
    if (number.length > length) {
        NSLog(@"长度超出限制...");
        return [number substringToIndex:length];
    }
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:number];
    int limit = length - number.length;
    for (int i=0; i<limit; i++){
        [mutableStr insertString:@"0" atIndex:i];
    }
    
    return mutableStr;
}

// 右补空格
+ (NSString *) formatAlpha:(NSString *) str withLength:(int) length
{
    if (str.length > length) {
        NSLog(@"长度超出限制...");
        return [str substringToIndex:length];
    }
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:str];
    int limit = length - str.length;
    for (int i=0; i<limit; i++){
        [mutableStr appendString:@" "];
    }
    
    return mutableStr;
}

+ (NSString *) fillZeroLeft:(NSString *) value withLength:(int) length
{
    char dest[length];
    strLeftFill([ConvertUtil string2Char:value], dest, '0', length);
    return [ConvertUtil char2String:dest];
}

@end

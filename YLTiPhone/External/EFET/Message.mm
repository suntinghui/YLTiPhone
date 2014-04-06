//
//  Message.m
//  POS2iPhone
//
//  Created by  STH on 12/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "Message.h"
#import "EFETFieldModel.h"
#import "FieldType.h"
#import "ConvertUtil.h"
#import <bitset>

@implementation Message

@synthesize msgType;
@synthesize bitMap;
@synthesize fieldDic;

- (id) initWithMsgTypeId:(NSString *) msgTypeId
{
    if (self = [super init]) {
        self.msgType = msgTypeId;
        self.fieldDic = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSString *) getFieldValue:(int) fieldId
{
    return [self getFieldModel:fieldId].value;
}

- (EFETFieldModel *) getFieldModel:(int) fieldId
{
    EFETFieldModel *model = (EFETFieldModel *)[self.fieldDic objectForKey:[NSNumber numberWithInt:fieldId]];
    return model;
}

// 设置字段域，由于字段域1被 用来存放位图，设置字段域应从2开始
- (void) setFieldModel:(int) fieldId withField:(EFETFieldModel *) fieldModel
{
    if (fieldId < 2 || fieldId > 128) {
        NSLog(@"Field index must be between 2 and 128 !!!");
        return;
    }
    
    if (fieldModel) {
        [self.fieldDic setObject:fieldModel forKey:[NSNumber numberWithInt:fieldId]];
    } else {
        [self.fieldDic removeObjectForKey:[NSNumber numberWithInt:fieldId]];
    }
}

// 设置字段域，由于字段域1被 用来存放位图，设置字段域应从2开始
- (void) setFieldModel:(int) fieldId value:(NSString *) value type:(NSString *) type length:(int) length
{
    EFETFieldModel *field = [[EFETFieldModel alloc] initWithDatatype:type value:value length:length];
    [self setFieldModel:fieldId withField:field];
}

- (BOOL) hasField:(int) fieldId
{
    EFETFieldModel *field = [self.fieldDic objectForKey:[NSNumber numberWithInt:fieldId]];
    return (field!=nil);
}

/*
 返回报文内容 ,不包含前报文总长度及结束符
 *
 * @return位图[8字节]+ 11域【3字节BCD码】+其余所有域值（个别域值前加上BCD码压缩的2个字节的长度值_左补0）
 */
- (NSData *) writeInternal
{
    @try {
        NSMutableData *msgData = [[NSMutableData alloc] init];
        
        // 位图
        NSArray *fieldIdArray = [self.fieldDic allKeys];
        std::bitset<64> bm(0);
        for (NSNumber *num in fieldIdArray) {
            int pos = [num intValue];
            bm.set(64-pos);
        }
        std::string bmStr = bm.to_string();
        
        NSString *bitmapStr = [NSString stringWithCString:bmStr.c_str() encoding:NSASCIIStringEncoding];
        NSString *bitmapHex = [ConvertUtil stringToHex:bitmapStr];
        
        NSLog(@"BitMap:%@", bitmapStr);
        NSLog(@"BitMap:%@", bitmapHex);
        
        NSData *bitmapData = [ConvertUtil hexStrTOData:bitmapHex];
        [msgData appendData:bitmapData];
        
        // 排序
        NSArray *sortedKeys = [[self.fieldDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
        
        // 紧跟位图后面，位图所有域的值
        for (NSNumber *num in sortedKeys){
            NSLog(@"===%@",  num);
            
            EFETFieldModel *field = [self.fieldDic objectForKey:num];
            
            if ([num intValue] != 52) {
                unsigned long length = field.value.length;
                
                if ([field.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLVAR]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLNVAR]]) {
                    NSData *tempData = [ConvertUtil decStr2BCDRight:[NSString stringWithFormat:@"%02luu", length]];
                    [msgData appendData:tempData];
                    NSLog(@"1111111:%@", msgData);
                    
                } else if ([field.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLLVAR]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLLNVAR]]) {
                    NSData *tempData = [ConvertUtil decStr2BCDRight:[NSString stringWithFormat:@"%04lu", length]];
                    [msgData appendData:tempData];
                    NSLog(@"2222222:%@", msgData);
                }
            }
            
            if ([field.dataType isEqualToString:[FieldType fieldTypeEnumToString:NUMERIC]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLNVAR]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLLNVAR]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:AMOUNT]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:DATE10]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:DATE4]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:DATE_EXP]] || [field.dataType isEqualToString:[FieldType fieldTypeEnumToString:TIME]]) {
                // BCD压缩
                [msgData appendData:[ConvertUtil toBCD:[field description] fieldId:[num intValue]]];
                NSLog(@"3333333:%@", msgData);
                
            } else {
                [msgData appendData:[[field description] dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"444444:%@", msgData);
            }
        }
        
        NSLog(@"位图与域:%@", msgData);
        
        return msgData;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
        NSLog(@"%@", [exception callStackSymbols]);
    }
    
    return nil;
    
}

@end

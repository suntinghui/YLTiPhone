//
//  FieldParserInfo.m
//  POS2iPhone
//
//  Created by  STH on 12/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "FieldParserInfo.h"
#import "FieldType.h"
#import "ConvertUtil.h"
#import "Util/Util.h"

@implementation FieldParserInfo

@synthesize type;
@synthesize length;
@synthesize mustBe;


- (id) initWithType:(NSString *) theType length:(int) theLength mustBe:(BOOL) flag
{
    if (self = [super init]){
        self.type = theType;
        self.length = theLength;
        self.mustBe = flag;
    }
    
    return self;
}

- (EFETFieldModel *) parseBinary:(NSData *) respData postion:(int) postion fieldId:(int) fieldId
{
    @try {
        NSString *value = @"";
        
        //NSLog(@"parse resp postion:%d", postion);
        
        if (fieldId == 2 || fieldId == 22|| fieldId == 32|| fieldId == 35 || fieldId == 36 || fieldId == 48 || fieldId == 60 || fieldId == 61) {
            
            if ([type isEqualToString:[FieldType fieldTypeEnumToString:NUMERIC]]) {
                NSData *tempData = [respData subdataWithRange:NSMakeRange(postion, self.length%2==0?self.length/2 : (self.length/2+self.length%2))];
                value = [ConvertUtil BCDToStringDeleteRightZero:tempData];
                
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:LLNVAR]]) {
                NSData *lenData = [respData subdataWithRange:NSMakeRange(postion, 1)];
                NSString *tempLen = [ConvertUtil BCDToString:lenData];
                int len = [tempLen intValue];
                
                self.length = len/2 + len%2;
                
                NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+1, self.length)];
                if (len % 2 == 0) {
                    value = [ConvertUtil BCDToString:tempData];
                } else {
                    value = [ConvertUtil BCDToStringDeleteRightZero:tempData];
                }
                
                self.length = len;
                
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:LLLNVAR]]) {
                NSData *lenData = [respData subdataWithRange:NSMakeRange(postion, 2)];
                NSString *tempLen = [ConvertUtil BCDToString:lenData];
                int len = [tempLen intValue];
                
                if (len % 2 == 1) {
                    self.length = len/2 + len%2;
                    NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+2, self.length)];
                    value = [ConvertUtil BCDToStringDeleteRightZero:tempData];
                } else {
                    self.length = len/2;
                    NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+2, self.length)];
                    value = [ConvertUtil BCDToString:tempData];
                }
                self.length = len;
            }
            
        } else { // 其他域
            if ([type isEqualToString:[FieldType fieldTypeEnumToString:ALPHA]]) {
                NSData *tempData = [respData subdataWithRange:NSMakeRange(postion, self.length)];
                //value = [[NSString alloc] initWithData:tempData encoding:NSASCIIStringEncoding];
                value = [[NSString alloc] initWithData:tempData encoding:GBKENC];
                
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:NUMERIC]]) {
                NSData *tempData = [respData subdataWithRange:NSMakeRange(postion, self.length%2==0?self.length/2:(self.length/2+self.length%2))];
                if (self.length % 2 == 0) {
                    value = [ConvertUtil BCDToString:tempData];
                } else {
                    value = [ConvertUtil BCDToStringDeleteLeftZero:tempData];
                }
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:LLVAR]]) {
                NSData *lenData = [respData subdataWithRange:NSMakeRange(postion, 1)];
                NSString *tempLen = [ConvertUtil BCDToString:lenData];
                int len = [tempLen intValue];
                self.length = len;
                
                NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+1, self.length)];
                value = [[NSString alloc] initWithData:tempData encoding:GBKENC];
                
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:LLLVAR]]) {
                NSData *lenData = [respData subdataWithRange:NSMakeRange(postion, 2)];
                NSString *tempLen = [ConvertUtil BCDToString:lenData];
                int len = [tempLen intValue];
                self.length = len;
                
                if (fieldId == 62) {
                    NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+2, self.length)];
                    value = [ConvertUtil byteToHex:tempData];
                } else {
                    NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+2, self.length)];
                    value = [[NSString alloc] initWithData:tempData encoding:GBKENC];
                }
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:LLNVAR]]) {
                NSData *lenData = [respData subdataWithRange:NSMakeRange(postion, 1)];
                NSString *tempLen = [ConvertUtil BCDToString:lenData];
                int len = [tempLen intValue];
                
                if (len % 2 == 1) {
                    self.length = len/2 +len%2;
                    NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+1, self.length)];
                    value = [ConvertUtil BCDToStringDeleteLeftZero:tempData];
                } else {
                    self.length = len/2;
                    NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+1, self.length)];
                    value = [ConvertUtil BCDToString:tempData];
                }
                
                self.length = len;
                
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:LLLNVAR]]) {
                NSData *lenData = [respData subdataWithRange:NSMakeRange(postion, 2)];
                NSString *tempLen = [ConvertUtil BCDToString:lenData];
                int len = [tempLen intValue];
                
                if (len % 2 == 1) {
                    self.length = len/2 +len%2;
                    NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+2, self.length)];
                    value = [ConvertUtil BCDToStringDeleteLeftZero:tempData];
                } else {
                    self.length = len/2;
                    NSData *tempData = [respData subdataWithRange:NSMakeRange(postion+2, self.length)];
                    value = [ConvertUtil BCDToString:tempData];
                }
                
                self.length = len;
                
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:AMOUNT]]) {
                NSData *tempData = [respData subdataWithRange:NSMakeRange(postion, 6)];
                value = [ConvertUtil BCDToString:tempData];
                
                self.length = 12;
                
            } else if ([type isEqualToString:[FieldType fieldTypeEnumToString:DATE10]] || [type isEqualToString:[FieldType fieldTypeEnumToString:DATE4]] || [type isEqualToString:[FieldType fieldTypeEnumToString:DATE_EXP]] || [type isEqualToString:[FieldType fieldTypeEnumToString:TIME]]) {
                
                /*
                 NSUInteger respLen = [respData length];
                 Byte *byteData = (Byte*)malloc(respLen);
                 memcpy(byteData, [respData bytes], respLen);
                 
                 int len = self.length/2 + self.length%2;
                 int *tens = new int[len];
                 
                 int start = 0;
                 [respData bytes];
                 
                 for (int i=postion; i<postion+len; i++) {
                 tens[start++] = ((byteData[i]&0xf0) >> 4) * 10 + (byteData[i] & 0x0f);
                 }
                 
                 
                 NSMutableString *tempValue = [NSMutableString string];
                 for (int i=0; i<len; i++) {
                 [tempValue appendFormat:@"%2d", tens[i]];
                 }
                 
                 value = [NSString stringWithString:tempValue];
                 */
                
                NSData *tempData = [respData subdataWithRange:NSMakeRange(postion, self.length)];
                value = [[[tempData description] stringByReplacingOccurrencesOfString:@" " withString:@""] substringWithRange:NSMakeRange(1, self.length)];
            }
            
        }
        
        //NSLog(@"<field%d -- %@>", fieldId, value);
        
        EFETFieldModel *model = [[EFETFieldModel alloc] initWithDatatype:self.type value:value length:self.length];
        return model;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
        NSLog(@"%@", [exception callStackSymbols]);
    }
    
    return nil;
}

@end

//
//  MessageFactory.m
//  POS2iPhone
//
//  Created by  STH on 12/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "MessageFactory.h"
#import "TBXML.h"
#import "FieldParserInfo.h"
#import "ConvertUtil.h"
#import "Message.h"
#import "FieldType.h"
#import <bitset>

@implementation MessageFactory

@synthesize allTransferFieldDic;
@synthesize allTransferFieldOrderDic;

static MessageFactory *instance;

+ (MessageFactory *) sharedInstane
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[MessageFactory alloc] init];
        }
    }
    
    return instance;
}

- (id) init
{
    if (self = [super init]) {
        self.allTransferFieldDic = [[NSMutableDictionary alloc] init];
        self.allTransferFieldOrderDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    
    return nil;
}

- (void) setATransferFieldDic:(NSString *) msgType value:(NSMutableDictionary *)fieldDic
{
    [self.allTransferFieldDic setObject:fieldDic forKey:msgType];
    
    NSArray *array = [fieldDic allKeys];
    
    //有误
    //NSArray* sortedArray = [array sortedArrayUsingSelector:@selector(comparator)];
    
    // TODO IOS不需要排序，默认是有序的，需要核对
    [self.allTransferFieldOrderDic setObject:array forKey:msgType];
}

- (NSDictionary *) getTheTransferFieldDic:(NSString *) msgType
{
    NSDictionary *tempDic = [self.allTransferFieldDic objectForKey:msgType];
    return tempDic;
}

// 通过字节数组来创建消息
- (Message *) getMessageFromResp:(NSData *) respMsgData
{
    // msgType
    NSData *msgTypeData = [respMsgData subdataWithRange:NSMakeRange(11, 2)];
    // ERROR
    //NSString *msgTypeStr = [ConvertUtil BCDTOStringLeftFillZero:msgTypeData];
    NSString *msgTypeStr = [[msgTypeData description] substringWithRange:NSMakeRange(1, 4)];
    
    Message *message = [[Message alloc] initWithMsgTypeId:msgTypeStr];
    
    // Bitmap
    NSData *bitmapData = [respMsgData subdataWithRange:NSMakeRange(5+6+msgTypeData.length, 8)];
    NSString *bitmapHexStr = [[[bitmapData description] stringByReplacingOccurrencesOfString:@" " withString:@""] substringWithRange:NSMakeRange(1, 16)];
    NSString *bitmapBinaryStr = [ConvertUtil hexToBinStr:bitmapHexStr];
    
    NSLog(@"位图:%@", bitmapHexStr);
    NSLog(@"位图:%@", bitmapBinaryStr);
    
    NSMutableArray *fieldArray = [NSMutableArray array];
    
    std::string cppStr = [bitmapBinaryStr cStringUsingEncoding:NSUTF8StringEncoding];
    std::bitset<64> bm(cppStr);
    for (int i=63; i>-1; i--) {
        if (bm.test(i)) {
            [fieldArray addObject:[NSNumber numberWithInt:(64-i)]];
        }
    }
    
    int postion = 5+6+msgTypeData.length+8;
    
    NSDictionary *parseGuide = [self.allTransferFieldDic objectForKey:message.msgType];
    
    NSArray *indexArray = [self.allTransferFieldOrderDic objectForKey:message.msgType];
    if (indexArray == nil) {
        NSLog(@"在XML文件中未定义报文类型[%@]的解析配置, 无法解析该类型的报文!! 请完善配置!", message.msgType);
        return nil;
    }
    
    for (int fieldnum = 2; fieldnum <= 64; fieldnum++) {
        if ([fieldArray containsObject:[NSNumber numberWithInt:fieldnum]]) {
            if (![indexArray containsObject:[NSNumber numberWithInt:fieldnum]]) {
                NSLog(@"收到类型为[ %@ ]的报文中的位图指示含有第[ %d ]域,但XML配置文件中未配置该域. 这可能会导致解析错误,建议检查或完善XML配置文件！", message.msgType, fieldnum);
            }
        }
    }
    
    //NSArray *sortedKeys = [indexArray sortedArrayUsingSelector: @selector(compare:)];
    
    for (NSNumber *num in fieldArray) {
        int index = [num intValue];
        FieldParserInfo *info = [parseGuide objectForKey:num];
        
        EFETFieldModel *fieldModel = [info parseBinary:respMsgData postion:postion fieldId:index];
        
        [message setFieldModel:index withField:fieldModel];
        
        if (index == 62) {
            [message setFieldModel:index value:fieldModel.value type:[FieldType fieldTypeEnumToString:LLLVAR] length:fieldModel.value.length];
        }
        
        if (!([fieldModel.dataType isEqualToString:[FieldType fieldTypeEnumToString:ALPHA]] || [fieldModel.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLVAR]] || [fieldModel.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLLVAR]])) {
            postion += (fieldModel.length/2 + fieldModel.length%2);
        } else {
            postion += fieldModel.length;
        }
        
        if ([fieldModel.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLVAR]]) {
            postion += 1;
        } else if ([fieldModel.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLLVAR]]) {
            postion += 2;
        } else if ([fieldModel.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLNVAR]]) {
            postion += 1;
        } else if ([fieldModel.dataType isEqualToString:[FieldType fieldTypeEnumToString:LLLNVAR]]) {
            postion += 2;
        }
    }
    
    return message;
}

- (void) parseConfigXML:(NSData *) content
{
    NSLog(@"解析XML...");
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:content error:&error];
    if (error) {
        NSLog(@"%@->parseConfigXML:%@", [self class] ,[error localizedDescription]);
        return;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        
        TBXMLElement *infoElement = [TBXML childElementNamed:@"parseinfo" parentElement:rootElement];
        
        while (infoElement) {
            
            NSString *msgType = [TBXML valueOfAttributeNamed:@"msgtypeid" forElement:infoElement];
            
            TBXMLElement *fieldElement = [TBXML childElementNamed:@"field" parentElement:infoElement];
            
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
            
            while (fieldElement) {
                
                int fieldId = [[TBXML valueOfAttributeNamed:@"id" forElement:fieldElement] intValue];
                NSString *type = [TBXML valueOfAttributeNamed:@"datatype" forElement:fieldElement];
                int length = [[TBXML valueOfAttributeNamed:@"length" forElement:fieldElement] intValue];
                BOOL isOk = [[TBXML valueOfAttributeNamed:@"isOk" forElement:fieldElement] boolValue];
                
                FieldParserInfo *info = [[FieldParserInfo alloc] initWithType:type length:length mustBe:isOk];
                
                [tempDic setObject:info forKey:[NSNumber numberWithInt:fieldId]];
                
                fieldElement = [TBXML nextSiblingNamed:@"field" searchFromElement:fieldElement];
            }
            
            [self setATransferFieldDic:msgType value:tempDic];
            
            infoElement = [TBXML nextSiblingNamed:@"parseinfo" searchFromElement:infoElement];
        }
        
    }
    
}

@end

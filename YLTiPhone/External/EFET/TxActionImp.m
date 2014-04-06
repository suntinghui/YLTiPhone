//
//  TxActionImp.m
//  POS2iPhone
//
//  Created by  STH on 12/28/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "TxActionImp.h"
#import "MessageFactory.h"
#import "Message.h"
#import "FieldParserInfo.h"
#import "FieldType.h"
#import "FormatUtil.h"
#import "ConvertUtil.h"
#import "EFETConstant.h"

@implementation TxActionImp

@synthesize reqDic;
@synthesize clientTransferCode;
@synthesize message;

- (NSData *) first:(NSDictionary *) requestDic withXMLData:(NSData *) xmlData
{
    self.reqDic = [NSMutableDictionary dictionaryWithDictionary:requestDic];
    self.clientTransferCode = [self.reqDic objectForKey:@"fieldTrancode"];
    
    if (self.clientTransferCode == nil) {
        NSLog(@"请求报文未有消息类型(交易码)");
        return nil;
    }
    
    if (self.clientTransferCode.length < 4) {
        NSLog(@"请求报文异常交易码:%@", self.clientTransferCode);
        return nil;
    }
    
    NSString *msgType = [self.clientTransferCode substringToIndex:4];
    [self.reqDic setObject:msgType forKey:@"fieldTrancode"];
    
    // 解析XML
    [[MessageFactory sharedInstane] parseConfigXML:xmlData];
    
    return [self process];
}

- (NSData *) process
{
    NSLog(@"----------------------process-------------------------");
    
    self.message = [self registerReqMsg];
    
    [self printMessage:self.message];
    
    NSData *reqMsgData = [self depacketize];
    
    return reqMsgData;
}

- (Message *) registerReqMsg
{
    NSString *msgType = [self.reqDic objectForKey:@"fieldTrancode"];
    
    NSDictionary *parseDic = [[MessageFactory sharedInstane] getTheTransferFieldDic:msgType];
    
    Message *msg = [[Message alloc] initWithMsgTypeId:msgType];
    
    int fieldId = 0;
    NSString *value = @"";
    NSString *type = @"";
    FieldParserInfo *xField = nil;
    
    for (NSNumber *num in [parseDic allKeys]) {
        fieldId = [num intValue];
        xField = [parseDic objectForKey:num];
        type = xField.type;
        value = [reqDic objectForKey:[NSString stringWithFormat:@"field%d", fieldId]];
        
        // 屏蔽请求报文的无值域 req_map中不为空时有效
        if ([type isEqualToString:[FieldType fieldTypeEnumToString:AMOUNT]]) {
            [msg setFieldModel:fieldId value:[FormatUtil formatAmount:value==NULL ?@"" :value] type:type length:xField.length];
        } else {
            if (xField.mustBe && (value == nil || [value isEqualToString:@""])) {
                NSLog(@"Field%d 的值不能为空！", fieldId);
            } else if (xField.length != 0 && (xField.length != value.length)){
                NSLog(@"Field%d 的长度不符合规定！", fieldId);
            }
            [msg setFieldModel:fieldId value:value type:type length:value.length];
        }
    }
    
    return msg;
}

// 组装报文
- (NSData *) depacketize
{
    NSData *msgTPDU = [NSData data];
    NSData *msgHeader = [NSData data];
    NSData *msgTypeId = [NSData data];
    
    // 进行BCD码压缩
    msgTPDU = [ConvertUtil byteToBCD:[TPDU dataUsingEncoding:NSUTF8StringEncoding]];
    msgHeader = [ConvertUtil byteToBCD:[HEADER dataUsingEncoding:NSUTF8StringEncoding]];
    msgTypeId = [ConvertUtil decStr2BCDLeft:self.message.msgType];
    
    //data :位图[8字节]+ {11域【3字节BCD码】+其余所有域值（个别域值前加上BCD码压缩的2个字节的长度值_左补0）}
    NSData *data = [self.message writeInternal];
    
    NSLog(@"位图和域值长度:%d", data.length);
    //NSLog(@"位图和域值:%@", [ConvertUtil traceData:data]);
    
    /*
     组装字节类型报文；（tpdu[BCD压缩5字节]+头文件[BCD压缩6字节]）+
     报文类型【BCD压缩2字节】+位图【8字节】&&位图对应的域值
     */
    
    NSMutableData *tempData = [[NSMutableData alloc] init];
    [tempData appendData:msgTPDU];
    [tempData appendData:msgHeader];
    [tempData appendData:msgTypeId];
    [tempData appendData:data];
    
    // 长度
    int sendDataLen = [tempData length];
    uint8_t lenData[2];
    lenData[0] = (sendDataLen & 0xff00) >> 8;
    lenData[1] = sendDataLen & 0xff;
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    [sendData appendBytes:lenData length:2];
    [sendData appendData:tempData];
    
    NSLog(@"REQ_Data:%d", [sendData length]);
    NSLog(@"REQ_Data:%@", sendData);
    
    return sendData;
}

- (NSDictionary *) afterProcess:(NSData *) respData
{
    NSLog(@"---------------------afterProcess---------------------");
    
    NSMutableDictionary *respDic = [NSMutableDictionary dictionary];
    
    Message *respMessage = [[MessageFactory sharedInstane] getMessageFromResp:respData];
    for (int i=0; i<128; i++) {
        if ([respMessage hasField:i]) {
            [respDic setObject:[[respMessage getFieldModel:i] description] forKey:[NSString stringWithFormat:@"field%d", i]];
        }
    }
    
    NSLog(@"RESP DIC:%@", respDic);
    
    return respDic;
}

- (void) printMessage:(Message *) msg
{
    NSLog(@"-------------------Message Begin------------------");
    
    NSLog(@"Message Type : %@", msg.msgType);
    
    for (int i=2; i<128; i++) {
        if ([msg hasField:i]) {
            EFETFieldModel *model = [msg getFieldModel:i];
            NSLog(@"Field:%d <%@>  <%d> <%@>", i, model.dataType, model.length, model.value);
        }
    }
    
    NSLog(@"-------------------Message End------------------");
}


@end

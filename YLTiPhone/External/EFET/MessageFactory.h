//
//  MessageFactory.h
//  POS2iPhone
//
//  Created by  STH on 12/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageFactory : NSObject
{
    // msgType NSDictionary(fieldId, EFETFieldModel)
    NSMutableDictionary         *allTransferFieldDic;
    // msgType NSArray(fieldId)
    NSMutableDictionary         *allTransferFieldOrderDic;
}

@property (nonatomic, strong) NSMutableDictionary           *allTransferFieldDic;
@property (nonatomic, strong) NSMutableDictionary           *allTransferFieldOrderDic;

+ (MessageFactory *) sharedInstane;

- (void) setATransferFieldDic:(NSString *) msgType value:(NSMutableDictionary *)fieldDic;

- (NSDictionary *) getTheTransferFieldDic:(NSString *) msgType;

- (Message *) getMessageFromResp:(NSData *) respMsg;

- (void) parseConfigXML:(NSData *) content;

@end

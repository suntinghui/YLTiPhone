//
//  TxActionImp.h
//  POS2iPhone
//
//  Created by  STH on 12/28/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface TxActionImp : NSObject
{
    NSMutableDictionary             *reqDic;
    NSString                        *clientTransferCode;
    
    Message                         *message;
}

@property (nonatomic, strong) NSMutableDictionary           *reqDic;
@property (nonatomic, strong) NSString                      *clientTransferCode;
@property (nonatomic, strong) Message                       *message;

- (NSData *) first:(NSDictionary *) reqDic withXMLData:(NSData *) xmlData;

- (NSDictionary *) afterProcess:(NSData *) respData;

@end

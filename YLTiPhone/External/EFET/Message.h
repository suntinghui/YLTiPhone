//
//  Message.h
//  POS2iPhone
//
//  Created by  STH on 12/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFETFieldModel.h"

@interface Message : NSObject
{
    NSString                    *bitMap;
    NSString                    *msgType;
    NSMutableDictionary         *fieldDic;
}

@property (nonatomic, strong) NSString                          *bitMap;
@property (nonatomic, strong) NSString                          *msgType;
@property (nonatomic, strong) NSMutableDictionary               *fieldDic;

- (id) initWithMsgTypeId:(NSString *) msgTypeId;

- (NSString *) getFieldValue:(int) fieldId;

- (EFETFieldModel *) getFieldModel:(int) fieldId;

- (void) setFieldModel:(int) fieldId withField:(EFETFieldModel *) fieldModel;

- (void) setFieldModel:(int) fieldId value:(NSString *) value type:(NSString *) type length:(int) length;

- (BOOL) hasField:(int) fieldId;

- (NSData *) writeInternal;

@end

//
//  FieldParserInfo.h
//  POS2iPhone
//
//  Created by  STH on 12/27/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFETFieldModel.h"

@interface FieldParserInfo : NSObject
{
    NSString            *type;
    int                 length;
    BOOL                mustBe;
}

@property (nonatomic, strong) NSString          *type;
@property (nonatomic, assign) int               length;
@property (nonatomic, assign) BOOL              mustBe;

- (id) initWithType:(NSString *) theType length:(int) theLength mustBe:(BOOL) flag;

- (EFETFieldModel *) parseBinary:(NSData *) respData postion:(int) pos fieldId:(int) fieldId;

@end

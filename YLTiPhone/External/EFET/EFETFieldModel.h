//
//  FieldModel.h
//  POS2iPhone
//
//  Created by  STH on 12/26/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFETFieldModel : NSObject
{
    NSString    *dataType;
    NSString    *value;
    int         length;
}

@property (nonatomic, strong) NSString      *dataType;
@property (nonatomic, strong) NSString      *value;
@property (nonatomic, assign) int           length;

- (id) initWithDatatype:(NSString *)type value:(NSString *) theValue length:(int) theLength;

@end

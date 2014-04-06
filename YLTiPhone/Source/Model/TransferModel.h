//
//  TransferModel.h
//  YLTiPhone
//
//  Created by xushuang on 14-1-15.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferModel : NSObject
{
    NSString           *_isJson;
    NSString           *_shouldMac;
    NSArray            *_fieldModelArray; //不加__unsafe_unretained 报错 Xcode5后
}
@property (nonatomic, strong) NSString                  *isJson;
@property (nonatomic, strong) NSString                  *shouldMac;
@property (nonatomic, strong) NSArray                   *fieldModelArray;

- (id)initWithArray:(NSArray *)fieldModelArray isJson:(NSString *)isJson shouldMac:(NSString *)shouldMac;

@end

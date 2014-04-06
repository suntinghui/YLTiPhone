//
//  TransferModel.m
//  YLTiPhone
//
//  Created by xushuang on 14-1-15.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "TransferModel.h"

@implementation TransferModel

@synthesize isJson = _isJson;
@synthesize shouldMac = _shouldMac;
@synthesize fieldModelArray = _fieldModelArray;

- (id)initWithArray:(NSArray *)fieldModelArray isJson:(NSString *)isJson shouldMac:(NSString *)shouldMac
{
	self = [super init];
	assert(self != nil);
	
	_fieldModelArray = [[NSArray alloc] initWithArray:fieldModelArray];
	_isJson = isJson;
    _shouldMac = shouldMac;
	return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"isJson:%@, shouldMac:%@", self.isJson?@"YES":@"NO", self.shouldMac?@"YES":@"NO"];
}


@end

//
//  UserModel.m
//  YLTiPhone
//
//  Created by xushuang on 14-1-17.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@synthesize merchant_name = _merchant_name;
@synthesize pid = _pid;
@synthesize type = _type;
@synthesize img13 = _img13;
@synthesize img14 = _img14;
@synthesize img15 = _img15;
@synthesize img17 = _img17;
@synthesize is_complete = _is_complete;
@synthesize is_identify = _is_identify;

- (id) init {
	self = [super init];
    
	return self;
}

@end

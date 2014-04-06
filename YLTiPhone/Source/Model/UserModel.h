//
//  UserModel.h
//  YLTiPhone
//
//  Created by xushuang on 14-1-17.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
{
@private
    NSString        *_merchant_name;//商户名
    NSString        *_pid;          //身份证
    NSString        *_type;         //类型
    
    NSString        *_img13;        //身份证图片（正面）
    NSString        *_img17;        //身份证图片（反面）
    NSString        *_img14;        //身份证图片（二合一）
    NSString        *_img15;        //大头照
    
    NSString        *_is_identify;  //身份认证 0 未认证  1 已认证
    NSString        *_is_complete;  //完善注册信息 	0 未完善  1 已完善
}

@property (nonatomic, strong) NSString          *merchant_name;
@property (nonatomic, strong) NSString          *merchant_id;
@property (nonatomic, strong) NSString          *pid;
@property (nonatomic, strong) NSString          *type;

@property (nonatomic, strong) NSString          *img13;
@property (nonatomic, strong) NSString          *img17;
@property (nonatomic, strong) NSString          *img14;
@property (nonatomic, strong) NSString          *img15;

@property (nonatomic, strong) NSString          *is_identify;
@property (nonatomic, strong) NSString          *is_complete;

@end

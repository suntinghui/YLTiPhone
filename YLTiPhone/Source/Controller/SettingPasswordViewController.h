//
//  SettingPasswordViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "PwdLeftTextField.h"

@interface SettingPasswordViewController : AbstractViewController
{
    NSString            *_smsCode;
}
@property (nonatomic, copy) NSString        *smsCode;
@property (nonatomic, strong) NSString *type; //0:找回登录密码 1：找回支付密码
@property(nonatomic, strong) PwdLeftTextField *freshPwdTF;
@property(nonatomic, strong) PwdLeftTextField *confirmPwdTF;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              smscode:(NSString *)smscode;
@end

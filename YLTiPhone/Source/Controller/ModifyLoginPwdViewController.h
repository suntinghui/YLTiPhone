//
//  ModifyLoginPwdViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-26.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

//修改登录密码
#import "AbstractViewController.h"
#import "PwdLeftTextField.h"
#import "LeftTextField.h"

@interface ModifyLoginPwdViewController : AbstractViewController
{
    NSInteger  secondsCountDown;
    NSTimer   *countDownTimer;
}
@property(nonatomic, strong) PwdLeftTextField *originalPwdTF;
@property(nonatomic, strong) PwdLeftTextField *freshPwdTF;
@property(nonatomic, strong) PwdLeftTextField *confirmPwdTF;
@property(nonatomic, strong) LeftTextField    *securityCodeTF;
@property(nonatomic, strong) NSTimer         *countDownTimer;
@property(nonatomic, strong) UIButton        *securityCodeButton;
@end

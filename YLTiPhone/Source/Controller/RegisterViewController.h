//
//  RegisterViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-26.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "LeftImageTextField.h"
#import "PwdLeftTextField.h"
#import "LeftTextField.h"

@interface RegisterViewController : AbstractViewController<UITextFieldDelegate>
{
    NSInteger       secondsCountDown;
    NSTimer         *countDownTimer;
    BOOL            agreeButtonTouch;
}

@property(nonatomic, strong) LeftImageTextField *phoneNumTF;
@property(nonatomic, strong) PwdLeftTextField *passwordTF;
@property(nonatomic, strong) PwdLeftTextField *confirmPasswordTF;
@property(nonatomic, strong) LeftTextField    *securityCodeTF;
@property(nonatomic, strong) NSTimer         *countDownTimer;
@property(nonatomic, strong) UIButton        *securityCodeButton;

@end

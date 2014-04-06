//
//  FindoutPaymentPwdViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-26.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

//找回支付密码
#import "AbstractViewController.h"
#import "LeftTextField.h"
#import "LeftImageTextField.h"

@interface FindoutPaymentPwdViewController : AbstractViewController<UITextFieldDelegate>
{
    NSInteger  secondsCountDown;
    NSTimer   *countDownTimer;
}
@property(nonatomic, strong)LeftImageTextField *phoneNumTF;
@property(nonatomic, strong)LeftImageTextField *realNameTF;
@property(nonatomic, strong)LeftImageTextField *cardIDTF;

@property(nonatomic, strong) LeftTextField    *securityCodeTF;
@property(nonatomic, strong) NSTimer         *countDownTimer;
@property(nonatomic, strong) UIButton        *securityCodeButton;


@property (nonatomic, strong) MKNetworkOperation            *MKOperation;

@end


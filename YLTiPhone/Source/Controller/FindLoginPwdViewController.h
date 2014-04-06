//
//  FindLoginPwdViewController.h
//  YLTiPhone
//
//  Created by liao jia on 14-4-1.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "LeftTextField.h"
#import "LeftImageTextField.h"
@interface FindLoginPwdViewController  : AbstractViewController<UITextFieldDelegate>
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

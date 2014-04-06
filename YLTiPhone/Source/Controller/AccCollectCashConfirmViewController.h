//
//  AccCollectCashConfirmViewController.h
//  YLTiPhone
//
//  Created by xushuang on 14-1-21.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "PwdLeftTextField.h"
#import "LeftTextField.h"

@interface AccCollectCashConfirmViewController : AbstractViewController
{
    NSString            *_moneyString;
    NSInteger           secondsCountDown;
    NSTimer             *countDownTimer;
}
@property (nonatomic, retain) NSString          *moneyString;
@property(nonatomic, strong) PwdLeftTextField   *paypassTF;
@property(nonatomic, strong) LeftTextField      *securityCodeTF;
@property(nonatomic, strong) NSTimer            *countDownTimer;
@property(nonatomic, strong) UIButton           *securityCodeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                money:(NSString *)money;
@end

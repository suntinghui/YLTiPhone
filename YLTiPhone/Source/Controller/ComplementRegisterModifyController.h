//
//  ComplementRegisterModifyController.h
//  YLTiPhone
//
//  Created by liao jia on 14-3-26.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "LeftImageTextField.h"
#import "PwdLeftTextField.h"
@interface ComplementRegisterModifyController : AbstractViewController<UITextFieldDelegate,
    UIActionSheetDelegate,
    UIScrollViewDelegate,
    UITextFieldDelegate>
{
    UIScrollView *scrollView;
    int type;
}

@property(nonatomic, strong)LeftImageTextField *et_merchant_name;
@property(nonatomic, strong)LeftImageTextField *et_name;
@property(nonatomic, strong)LeftImageTextField *et_pid;
@property(nonatomic, strong)LeftImageTextField *et_email;
@property(nonatomic, strong)PwdLeftTextField *pwd_pay;
@property(nonatomic, strong)PwdLeftTextField *pwd_pay_confirm;

@end

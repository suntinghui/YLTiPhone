//
//  MerchantQueryBalanceViewController.h
//  YLTiPhone
//
//  Created by liao jia on 14-4-9.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "PwdLeftTextField.h"
@interface MerchantQueryBalanceViewController : AbstractViewController
{
    PwdLeftTextField *pswTxtField;
}

@property (strong, nonatomic) NSString *moneyStr; //前一个页面传过来的金额
@end
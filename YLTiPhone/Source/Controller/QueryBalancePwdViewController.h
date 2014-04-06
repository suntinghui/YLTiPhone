//
//  QueryBalancePwdViewController.h
//  YLTiPhone
//
//  Created by liao jia on 14-3-31.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PwdLeftTextField.h"
@interface QueryBalancePwdViewController : AbstractViewController
{
    PwdLeftTextField *pswTxtField;
}

@property (strong, nonatomic) NSString *moneyStr; //前一个页面传过来的金额
@end
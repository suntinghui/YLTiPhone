//
//  InputPasswordViewController.h
//  YLTiPhone
//
//  Created by 文彬 on 14-3-28.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PwdLeftTextField.h"

@interface InputPasswordViewController : AbstractViewController
{
    PwdLeftTextField *pswTxtField;
}

@property (strong, nonatomic) NSString *moneyStr; //前一个页面传过来的金额
@end

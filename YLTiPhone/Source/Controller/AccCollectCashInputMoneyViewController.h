//
//  AccCollectCashInputMoneyViewController.h
//  YLTiPhone
//
//  Created by xushuang on 14-1-21.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "LeftTextField.h"

@interface AccCollectCashInputMoneyViewController : AbstractViewController<UIActionSheetDelegate>
{
    NSDictionary        *_receiveDic;
    UIScrollView        *scrView ;
    int type; //提现类型 1：快速提现  0：普通提现
}
@property (nonatomic, strong) NSDictionary      *receiveDic;
@property (nonatomic, strong) LeftTextField     *inputMoneyTF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  dic:(NSDictionary *)dic;
@end

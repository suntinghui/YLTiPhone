//
//  AccountCollectCashViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

//账户提现
#import "AbstractViewController.h"

@interface AccountCollectCashViewController : AbstractViewController<UIGestureRecognizerDelegate>
{
    NSDictionary        *_accountDic;
}
@property (nonatomic, strong) NSDictionary      *accountDic;
@property (nonatomic, strong) UIButton          *accountButton;
@property (nonatomic, strong) UIButton          *confirmButton;
@property (nonatomic, strong) UIView            *accountView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *accountLabel;
@property (nonatomic, strong) UIScrollView *scroll ;
@property (nonatomic, strong) UIButton *btn_add;
-(void)requestAction;
-(void)refreshTabelView;
@end

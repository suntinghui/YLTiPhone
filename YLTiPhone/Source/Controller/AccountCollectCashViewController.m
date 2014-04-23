//
//  AccountCollectCashViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AccountCollectCashViewController.h"
#import "AddAccountInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AccCollectCashInputMoneyViewController.h"
#import "ModifyAccountInfoViewController.h"

@interface AccountCollectCashViewController ()

@end

@implementation AccountCollectCashViewController

@synthesize accountDic = _accountDic;
@synthesize accountButton;
@synthesize confirmButton;
@synthesize accountView, nameLabel, accountLabel;
@synthesize scroll;
@synthesize btn_add;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"账户提现";
    self.hasTopView = YES;
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40+ios7_h, 320, 480)];
    [scroll setContentSize:CGSizeMake(320, 550)];
    [self.view addSubview:scroll];
    
    btn_add = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_add setFrame:CGRectMake(10, 0, 297, 44)];
    
    [btn_add setTitle:@"+新增提款银行帐户" forState:UIControlStateNormal];
    [btn_add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_add.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn_add addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn_add setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [btn_add setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [btn_add setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    
    //单击时间跳到提款确认界面  
    accountView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 297, 50)];
    accountView.backgroundColor = [UIColor whiteColor];
    accountView.layer.borderWidth = 1;
    accountView.layer.cornerRadius = 5;
    accountView.layer.borderColor = [UIColor grayColor].CGColor;
    //账户名称
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [accountView addSubview:nameLabel];
    //账号
    accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, 30)];
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.font = [UIFont systemFontOfSize:14];
    [accountView addSubview:accountLabel];
    
    UIButton *btn_hand = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_hand setFrame:CGRectMake(240, 8, 36, 36)];
    [btn_hand addTarget:self action:@selector(handAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn_hand setBackgroundImage:[UIImage imageNamed:@"icon_hand"] forState:UIControlStateNormal];
    [accountView addSubview:btn_hand];
    
    //给上面的view添加单击事件和长按事件
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    [accountView addGestureRecognizer:singleRecognizer];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 45, 60, 30)];
    [confirmButton setTitle:@"修改" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmButton];
    
    UIImage *image = [UIImage imageNamed:@"explain.png"];
    UIImageView *explainIV = [[UIImageView alloc] initWithImage:[self stretchImage:image]];
    [explainIV setFrame:CGRectMake(10, 75, 297, 320)];
    [scroll addSubview:explainIV];
    
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 282, 310)];
    explainLabel.backgroundColor = [UIColor clearColor];
    explainLabel.textColor = [UIColor blackColor];
    explainLabel.font = [UIFont systemFontOfSize:14];
    explainLabel.numberOfLines = 0;
    explainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString *phone;
    if (APPTYPE == CAppTypeBFB)
    {
        phone = @"4008-2660-77";
    }
    else
    {
        phone = @"4008-0166-88";
    }
    explainLabel.text = [NSString stringWithFormat: @"用户须知\n注意：使用本服务前需完成实名认证，用户填写信息一经提交不可修改，如确需修改信息，请致电客服热线办理；请仔细核对提款银行信息，如因提款信息错误导致提款失败，提款资金将退回至提款人手机账户。\n1、普通提款：\n提款限额：50万/日（大额交易系统可能自动分拆入账）; 信用卡收款当日下午3时以后(因不同银行处理时间不同，部分银行入账可能出现延迟)；\n2、快速提款：\n提款限额：50000元/日，手续费0.25%；到账时间：工作时间内提款2小时内到账（因不同银行处理时间不同，部分银行入账可能出现延迟）\n服务热线：%@",phone];
    
    [explainIV addSubview:explainLabel];
    
    [self requestAction];
}

-(void)requestAction
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    // 089007 获取提款银行账号
    [[Transfer sharedTransfer] startTransfer:@"089007" fskCmd:nil paramDic:dic];
}

-(void)refreshTabelView
{
    NSLog(@"ddd %@",self.accountDic);
    if ([[self.accountDic objectForKey:@"bankaccount"] isEqualToString:@" "])
    {
        [scroll addSubview:btn_add];
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [scroll addSubview:accountView];
        self.nameLabel.text = [self.accountDic objectForKey:@"accountname"];
        self.accountLabel.text = [self.accountDic objectForKey:@"bankaccount"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//处理单击操作 跳转到账户提现输入金额界面
-(void)SingleTap:(UITapGestureRecognizer *)recognizer
{
    AccCollectCashInputMoneyViewController *inputVC = [[AccCollectCashInputMoneyViewController alloc] initWithNibName:Nil bundle:nil dic:self.accountDic];
    [self.navigationController pushViewController:inputVC animated:YES];
}


-(IBAction)confirmButtonAction:(id)sender
{
    AddAccountInfoViewController *addAccountVC = [[AddAccountInfoViewController alloc] initWithNibName:nil bundle:nil];
    addAccountVC.pageType = 1;
    addAccountVC.accountDict = [[NSMutableDictionary alloc]initWithDictionary:self.accountDic];
    [self.navigationController pushViewController:addAccountVC animated:YES];
}

-(IBAction)handAction:(id)sender
{
    AccCollectCashInputMoneyViewController *inputVC = [[AccCollectCashInputMoneyViewController alloc] initWithNibName:Nil bundle:nil dic:self.accountDic];
    [self.navigationController pushViewController:inputVC animated:YES];
}

-(IBAction)addAction:(id)sender
{
    AddAccountInfoViewController *addAccountVC = [[AddAccountInfoViewController alloc] initWithNibName:nil bundle:nil];
    addAccountVC.pageType = 0;
    addAccountVC.accountDict = [[NSMutableDictionary alloc]initWithDictionary:self.accountDic];
    [self.navigationController pushViewController:addAccountVC animated:YES];
}
@end

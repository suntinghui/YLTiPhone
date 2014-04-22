//
//  AccCollectCashConfirmViewController.m
//  YLTiPhone
//
//  Created by xushuang on 14-1-21.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "AccCollectCashConfirmViewController.h"
#import "UITextField+HideKeyBoard.h"
#import "StringUtil.h"
#define right_x 120
#define right_w 170
@interface AccCollectCashConfirmViewController ()

@end

@implementation AccCollectCashConfirmViewController

@synthesize moneyString = _moneyString;
@synthesize paypassTF;
@synthesize securityCodeButton;
@synthesize securityCodeTF;
@synthesize countDownTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                money:(NSString *)money
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _moneyString = [[NSString alloc] initWithString:money];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"交易确认";
    self.hasTopView = YES;
    
    UIView *accountInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, 100+ios7_h, 300, 100)];
    accountInfoView.backgroundColor = [UIColor whiteColor];
    accountInfoView.layer.borderWidth = 1;
    accountInfoView.layer.cornerRadius = 5;
    accountInfoView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:accountInfoView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 25)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"交易名称";
    [accountInfoView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 100, 25)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:15];
    label2.text = [NSString stringWithFormat:@"%@账号",ApplicationDelegate.proName];
    [accountInfoView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 150, 25)];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = [UIFont systemFontOfSize:15];
    label3.text = @"交易余额";
    [accountInfoView addSubview:label3];
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(right_x, 5, right_w, 25)];
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.font = [UIFont systemFontOfSize:15];
    namelabel.text = @"手机号提款";
    [namelabel setTextAlignment:NSTextAlignmentRight];
    [accountInfoView addSubview:namelabel];
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(right_x, 35, right_w, 25)];
    phonelabel.backgroundColor = [UIColor clearColor];
    phonelabel.font = [UIFont systemFontOfSize:15];
    phonelabel.text = [[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"];
    [phonelabel setTextAlignment:NSTextAlignmentRight];
    [accountInfoView addSubview:phonelabel];
    
    UILabel *balancelabel = [[UILabel alloc] initWithFrame:CGRectMake(right_x, 65, right_w, 25)];
    balancelabel.backgroundColor = [UIColor clearColor];
    balancelabel.font = [UIFont systemFontOfSize:15];
    [balancelabel setTextAlignment:NSTextAlignmentRight];
    balancelabel.text = [NSString stringWithFormat:@"￥%@",self.moneyString];
    [accountInfoView addSubview:balancelabel];
    
    self.paypassTF = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 220+ios7_h, 300, 44) left:@"" prompt:@"请输入商户支付密码"];
//    [self.paypassTF.pwdTF hideKeyBoard:self.view :1 hasNavBar:YES]; //TODO
    [self.view addSubview:self.paypassTF];

    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 290+ios7_h, 300, 42)];
    [confirmButton setTitle:@"确    定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:confirmButton];
    
    UITapGestureRecognizer *tapgustrue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapgustrue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 功能函数
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}
- (void)securityCodeButtonAction
{
    self.securityCodeButton.enabled = NO;
    secondsCountDown = 30;//30秒倒计时 1s执行一次下面方法
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

-(void)timeFireMethod
{
    secondsCountDown--;
    [self.securityCodeButton setTitle:[NSString stringWithFormat:@"倒计时 %d",secondsCountDown] forState:UIControlStateNormal];
    if(secondsCountDown==0)
    {
        [self.securityCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        self.securityCodeButton.enabled = YES;
        [countDownTimer invalidate];
    }
}


-(BOOL)checkValue
{
    if([self.securityCodeTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入短信校验码"];
        return NO;
    }else if(self.paypassTF.md5Value == nil || [self.paypassTF.md5Value isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位支付密码"];
        return NO;
    }
    return YES;
}

#pragma mark - 按钮点击

-(IBAction)confirmButtonAction:(id)sender
{
    if ([self checkValue])
    {
        if (ApplicationDelegate.isAishua)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            int random = (arc4random() % 100) + 1;
            [dic setObject:[NSString stringWithFormat:@"01%016d",random] forKey:@"RANDOM"];
            [AppDataCenter sharedAppDataCenter].__RANDOM = [NSString stringWithFormat:@"%016d",random];
            
            //010000 普通提款  020000快速提款
            [dic setObject:self.type==0?@"010000":@"020000" forKey:@"field3"];
            
            [dic setObject:[StringUtil amount2String:self.moneyString] forKey:@"field4"]; //金额转12位
            [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"PHONENUM"];
//            [dic setObject:self.paypassTF.md5Value forKey:@"pwd"];
            [dic setObject:@"2BFDD621B461950E3D7038391295B03B" forKey:@"pwd"]; //TODO
            //080002 商户提款
            [[Transfer sharedTransfer] startTransfer:@"080002" fskCmd:nil paramDic:dic];
        }
        else
        {
            //发送数据 走8583
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[StringUtil amount2String:self.moneyString] forKey:@"field4"]; //金额转12位
            [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"PHONENUM"];
            [dic setObject:self.paypassTF.md5Value forKey:@"pwd"];
            //080002 商户提款
            [[Transfer sharedTransfer] startTransfer:@"080002" fskCmd:@"Request_GetExtKsn#Request_VT" paramDic:dic];
        }
      
    }
}
@end
//
//  FindLoginPwdViewController.m
//  YLTiPhone
//
//  Created by liao jia on 14-4-1.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "FindLoginPwdViewController.h"
#import "UITextField+HideKeyBoard.h"
#import "HttpManager.h"

@interface FindLoginPwdViewController ()

@end

@implementation FindLoginPwdViewController

@synthesize phoneNumTF, realNameTF, cardIDTF;
@synthesize securityCodeTF, securityCodeButton;
@synthesize countDownTimer;

@synthesize MKOperation;

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
    self.navigationItem.title = @"找回登录密码";
    
    self.hasTopView = true;
    
    //手机号码
    self.phoneNumTF = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 70, 300, 44) leftImage:@"phoneNum.png" leftImageFrame:CGRectMake(15, 10, 20, 20) prompt:@"手机号码" keyBoardType:UIKeyboardTypePhonePad];
    self.phoneNumTF.contentTF.delegate = self;
    [self.phoneNumTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    [self.view addSubview:self.phoneNumTF];
    
    UILabel *userInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 124, 200, 40)];
    userInfoLabel.text = @"用户信息";
    userInfoLabel.backgroundColor = [UIColor clearColor];
    userInfoLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.view addSubview:userInfoLabel];
    
    //真实姓名
    self.realNameTF = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 175, 300, 44) leftImage:@"realname.png" leftImageFrame:CGRectMake(15, 15, 19, 22) prompt:@"真实姓名" keyBoardType:UIKeyboardTypeDefault];
    self.realNameTF.contentTF.delegate = self;
    [self.realNameTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    [self.view addSubview:self.realNameTF];
    
    //身份证号码
    self.cardIDTF = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 225, 300, 44) leftImage:@"cardID.png" leftImageFrame:CGRectMake(15, 15, 23, 15) prompt:@"身份证号码" keyBoardType:UIKeyboardTypeDefault];
    self.cardIDTF.contentTF.delegate = self;
    [self.cardIDTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    [self.view addSubview:self.cardIDTF];
    
    
    //短信校验码输入框背景
    UIImageView *textFieldImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 280, 150, 44)];
    [textFieldImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [self.view addSubview:textFieldImage1];
    
    self.securityCodeTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 280, 150, 44) isLong:FALSE];
    [self.securityCodeTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self.securityCodeTF.contentTF setPlaceholder:@"短信校验码"];
    [self.securityCodeTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    self.securityCodeTF.contentTF.delegate = self;
    [self.securityCodeTF.contentTF hideKeyBoard:self.view :2 hasNavBar:NO];
    [self.view addSubview:self.securityCodeTF];
    
    securityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [securityCodeButton setFrame:CGRectMake(175, 280, 130, 44)];
    [securityCodeButton setTitle:@"获取短信校验码" forState:UIControlStateNormal];
    [securityCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    securityCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [securityCodeButton addTarget:self action:@selector(securityCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [securityCodeButton setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:securityCodeButton];
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 340, 297, 42)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)securityCodeButtonAction
{
    self.securityCodeButton.enabled = NO;
    secondsCountDown = 30;//30秒倒计时 1s执行一次下面方法
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd 20hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    [dic setObject:@"time" forKey:date];
    
    [[Transfer sharedTransfer] startTransfer:@"089006" fskCmd:nil paramDic:dic];
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
    if([self.phoneNumTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入手机号码"];
        return NO;
        
    }else if([self.securityCodeTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入短信校验码"];
        return NO;
        
    }else if([self.realNameTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入真实姓名"];
        return NO;
        
    }else if([self.cardIDTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入身份证号码"];
        return NO;
        
    }
    return YES;
}
-(IBAction)confirmButtonAction:(id)sender
{
    
    if ([self checkValue]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.phoneNumTF.contentTF.text forKey:@"tel"];
        [dic setObject:self.securityCodeTF.contentTF.text forKey:@"smscode"];
        [dic setObject:self.cardIDTF.contentTF.text forKey:@"pid"];//身份证
        [dic setObject:self.realNameTF.contentTF.text forKey:@"merchant_name"];//户名
        
        [[Transfer sharedTransfer] startTransfer:@"089002" fskCmd:nil paramDic:dic];
    }
}

@end

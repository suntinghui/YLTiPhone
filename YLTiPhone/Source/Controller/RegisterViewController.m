//
//  RegisterViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-26.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UITextField+HideKeyBoard.h"
#import "EncryptionUtil.h"
#import "AgreementViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize phoneNumTF, passwordTF, confirmPasswordTF;
@synthesize securityCodeTF, securityCodeButton;
@synthesize countDownTimer;

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
    self.navigationItem.title = @"注 册";
    
//    self.hasTopView = true;
    
    //手机号码
    self.phoneNumTF = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 30, 300, 44) leftImage:@"phoneNum.png" leftImageFrame:CGRectMake(15, 10, 20, 20) prompt:@"手机号码" keyBoardType:UIKeyboardTypePhonePad];
    self.phoneNumTF.contentTF.delegate = self;
    [self.phoneNumTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    [self.view addSubview:self.phoneNumTF];
    
    self.passwordTF = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 90, 300, 44) left:@"" prompt:@"新密码"];
    [self.view addSubview:self.passwordTF];
    
    self.confirmPasswordTF = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 150, 300, 44) left:@"" prompt:@"确认新密码"];
    [self.view addSubview:self.confirmPasswordTF];
    
    //短信校验码输入框背景
    UIImageView *textFieldImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 210, 150, 44)];
    [textFieldImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [self.view addSubview:textFieldImage1];
    
    self.securityCodeTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 210, 150, 44) isLong:FALSE];
    [self.securityCodeTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self.securityCodeTF.contentTF setPlaceholder:@"短信校验码"];
    [self.securityCodeTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    self.securityCodeTF.contentTF.delegate = self;
    [self.securityCodeTF.contentTF hideKeyBoard:self.view :2 hasNavBar:NO];
    [self.view addSubview:self.securityCodeTF];
    
    securityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [securityCodeButton setFrame:CGRectMake(175, 210, 130, 44)];
    [securityCodeButton setTitle:@"获取短信校验码" forState:UIControlStateNormal];
    [securityCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    securityCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [securityCodeButton addTarget:self action:@selector(securityCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [securityCodeButton setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:securityCodeButton];
    
    
    //记住密码复选框
    agreeButtonTouch = NO;
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setFrame:CGRectMake(15, 270, 20, 20)];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn_comment_sametime_unselect.png"] forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeButton];
    
    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 265, 170, 30)];
    agreeLabel.backgroundColor = [UIColor clearColor];
    agreeLabel.font = [UIFont systemFontOfSize:15.0f];
    agreeLabel.text = [NSString stringWithFormat:@"同意《%@服务协议》",ApplicationDelegate.proName];
    [self.view addSubview:agreeLabel];
    
    UIButton *serviceDelegateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceDelegateButton setFrame:CGRectMake(220, 265, 100, 30)];
    [serviceDelegateButton setTitle:@"服务协议" forState:UIControlStateNormal];
    [serviceDelegateButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    serviceDelegateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [serviceDelegateButton addTarget:self action:@selector(serviceDelegateButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceDelegateButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 330, 297, 42)];
    [confirmButton setTitle:@"立即注册" forState:UIControlStateNormal];
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

//同意服务协议按钮
- (void)agreeButtonAction:(UIButton *)button
{
    if (agreeButtonTouch == NO) {
        [button setBackgroundImage:[UIImage imageNamed:@"btn_comment_sametime_select.png"] forState:UIControlStateNormal];
        agreeButtonTouch = YES;
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"btn_comment_sametime_unselect.png"] forState:UIControlStateNormal];
        agreeButtonTouch = NO;
    }
}

- (void)serviceDelegateButton
{    
    AgreementViewController *vc = [[AgreementViewController alloc] initWithNibName:@"AgreementViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
    [dic setObject:self.phoneNumTF.contentTF.text forKey:@"tel"];
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
        
    }else if(self.passwordTF.md5Value == nil || [self.passwordTF.md5Value isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位密码"];
        return NO;
        
    }else if(self.confirmPasswordTF.md5Value == nil || [self.confirmPasswordTF.md5Value isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位密码"];
        return NO;
        
    }else if(![self.passwordTF.md5Value isEqualToString:self.confirmPasswordTF.md5Value]){
        [ApplicationDelegate showErrorPrompt:@"两次支付密码输入不一致"];
        return NO;
    }
    return YES;
}

-(IBAction)confirmButtonAction:(id)sender
{
    if ([self checkValue]) {
        
        [[AppDataCenter sharedAppDataCenter] setPhoneNum:[[self.phoneNumTF contentTF] text]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.phoneNumTF.contentTF.text forKey:@"tel"];
        [dic setObject:self.passwordTF.md5Value forKey:@"logpass"];
//        [dic setObject:@"2BFDD621B461950E3D7038391295B03B" forKey:@"logpass"];
        [dic setObject:self.securityCodeTF.contentTF.text forKey:@"smscode"];
        [[Transfer sharedTransfer] startTransfer:@"089001" fskCmd:@"Request_GetKsn" paramDic:dic];
    }
}
@end

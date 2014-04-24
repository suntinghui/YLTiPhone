//
//  ModifyPaymentPwdViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-26.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "ModifyPaymentPwdViewController.h"
#import "UITextField+HideKeyBoard.h"
#import "EncryptionUtil.h"

@interface ModifyPaymentPwdViewController ()

@end

@implementation ModifyPaymentPwdViewController

@synthesize originalPwdTF = _originalPwdTF;
@synthesize freshPwdTF = _freshPwdTF;
@synthesize confirmPwdTF = _confirmPwdTF;
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
    self.navigationItem.title = @"修改支付密码";
    self.hasTopView = true;
    
    self.originalPwdTF = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 70, 300, 44) left:@"" prompt:@"请输入原支付密码"];
    [self.view addSubview:self.originalPwdTF];
    
    self.freshPwdTF = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 130, 300, 44) left:@"" prompt:@"请输入6位支付密码"];
    [self.view addSubview:self.freshPwdTF];
    
    self.confirmPwdTF = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 190, 300, 44) left:@"" prompt:@"请再次输入支付密码"];
    [self.view addSubview:self.confirmPwdTF];
    
    //短信校验码输入框背景
    UIImageView *textFieldImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 250, 150, 44)];
    [textFieldImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [self.view addSubview:textFieldImage1];
    
    self.securityCodeTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 250, 150, 44) isLong:FALSE];
    [self.securityCodeTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self.securityCodeTF.contentTF setPlaceholder:@"短信校验码"];
    [self.securityCodeTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    self.securityCodeTF.contentTF.delegate = self;
    [self.securityCodeTF.contentTF hideKeyBoard:self.view :2 hasNavBar:NO];
    [self.view addSubview:self.securityCodeTF];
    
    securityCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [securityCodeButton setFrame:CGRectMake(175, 250, 130, 44)];
    [securityCodeButton setTitle:@"获取短信校验码" forState:UIControlStateNormal];
    [securityCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    securityCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [securityCodeButton addTarget:self action:@selector(securityCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [securityCodeButton setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:securityCodeButton];
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 320, 297, 42)];
    [confirmButton setTitle:@"确    定" forState:UIControlStateNormal];
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
    if([self.securityCodeTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位原登录密码"];
        return NO;
        
    }else if(self.originalPwdTF.md5Value == nil || [self.originalPwdTF.md5Value isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位原支付密码"];
        return NO;
        
    }else if(self.freshPwdTF.md5Value == nil || [self.freshPwdTF.md5Value isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位新支付密码"];
        return NO;
        
    }else if(self.confirmPwdTF.md5Value == nil || [self.confirmPwdTF.md5Value isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请再次输入6位新支付密码"];
        return NO;
        
    }else if(![self.freshPwdTF.md5Value isEqualToString:self.confirmPwdTF.md5Value]){
        [ApplicationDelegate showErrorPrompt:@"两次新密码输入不一致"];
        return NO;
        
    }
    return YES;
}

-(IBAction)confirmButtonAction:(id)sender
{
    if(![self.freshPwdTF.md5Value isEqualToString:self.originalPwdTF.md5Value]){
        [ApplicationDelegate showErrorPrompt:@"两次新密码输入不一致"];
        
    }

    
    if ([self checkValue]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
        
        [dic setObject:self.originalPwdTF.md5Value forKey:@"old_password"];
        [dic setObject:self.freshPwdTF.md5Value forKey:@"new_password"];
        [dic setObject:[[self.securityCodeTF contentTF] text] forKey:@"smscode"];
        [dic setObject:@"1" forKey:@"type"]; //0是登录密码 1是支付密码
        
        //089003 修改登录密码
        [[Transfer sharedTransfer] startTransfer:@"089003" fskCmd:nil paramDic:dic];
    }

}

@end

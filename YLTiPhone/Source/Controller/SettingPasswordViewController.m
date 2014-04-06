//
//  SettingPasswordViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "SettingPasswordViewController.h"

@interface SettingPasswordViewController ()

@end

@implementation SettingPasswordViewController

@synthesize smsCode = _smsCode;
@synthesize freshPwdTF, confirmPwdTF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              smscode:(NSString *)smscode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _smsCode = smscode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"设置密码";
    
    self.freshPwdTF = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 30, 300, 44) left:@"" prompt:@"请输入6位密码"];
    [self.view addSubview:self.freshPwdTF];
    
    self.confirmPwdTF = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 100, 300, 44) left:@"" prompt:@"请再次输入密码"];
    [self.view addSubview:self.confirmPwdTF];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 180, 297, 42)];
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

-(BOOL)checkValue
{
    if(self.freshPwdTF.md5Value == nil || [self.freshPwdTF.md5Value isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位新密码"];
        return NO;
        
    }else if(self.confirmPwdTF.md5Value == nil || [self.confirmPwdTF.md5Value isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请再次输入6位密码"];
        return NO;
        
    }else if(![self.freshPwdTF.md5Value isEqualToString:self.confirmPwdTF.md5Value]){
        [ApplicationDelegate showErrorPrompt:@"两次新密码输入不一致"];
        return NO;
        
    }
    return YES;
}

-(IBAction)confirmButtonAction:(id)sender
{
    if ([self checkValue]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"PHONENUM"];
        
        [dic setObject:self.freshPwdTF.md5Value forKey:@"paypass"];
        //上个界面请求返回数据中 传到此界面的值
        [dic setObject:self.smsCode forKey:@"smscode"];
        [dic setObject:@"1" forKey:@"type"]; //0是登录密码 1是支付密码
        
        //089015 修改登录密码
        [[Transfer sharedTransfer] startTransfer:@"089015" fskCmd:nil paramDic:dic];
    }
}

@end

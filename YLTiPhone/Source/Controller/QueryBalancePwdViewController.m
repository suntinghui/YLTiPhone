//
//  QueryBalancePwdViewController.m
//  YLTiPhone
//
//  Created by liao jia on 14-3-31.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "QueryBalancePwdViewController.h"
#import "ConvertUtil.h"
#import "SecurityUtil.h"
#import "InputPwdQueryBalanceViewController.h"

@interface QueryBalancePwdViewController ()

@end

@implementation QueryBalancePwdViewController

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
    // Do any additional setup after loading the view from its nib.
    self.hasTopView = YES;
    self.navigationItem.title = @"余额查询";
    
    pswTxtField = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 50, 300, 44) left:@"密码" prompt:@"请输入密码"];
    [self.view addSubview:pswTxtField];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 360, 297, 42)];
    [confirmButton setTitle:@"确    定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:confirmButton];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击
- (void)confirmButtonAction:(id)sender
{
    if (pswTxtField.pwdTF.text==nil||[pswTxtField.pwdTF.text isEqualToString:@""])
    {
        [ApplicationDelegate showErrorPrompt:@"请输入密码"];
        return;
    }
    
    //NSDictionary *cardInfo = [AppDataCenter sharedAppDataCenter].cardInfoDict;
    //NSString *random = [AppDataCenter sharedAppDataCenter].__RANDOM;
    //NSString *encTracks = [AppDataCenter sharedAppDataCenter].__ENCTRACKS;
    
    NSString *temKey = [NSString stringWithFormat:@"%@%@",[AppDataCenter sharedAppDataCenter].__ENCTRACKS,[AppDataCenter sharedAppDataCenter].pinKey];
    NSString *key = [SecurityUtil encryptUseXOR16:temKey];
    
    NSString *psw = [NSString stringWithFormat:@"%@00",pswTxtField.inputStr];
    NSString *keyResult = [NSString stringWithFormat:@"%@%@",key,[key substringToIndex:16]];
    NSString *enStr = [[SecurityUtil encryptUseTripleDES:[ConvertUtil stringToHexStr:psw] key:keyResult] substringWithRange:NSMakeRange(0, 16)];
    NSLog(@"enStr %@",enStr);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:enStr forKey:@"AISHUAPIN"];
    [dic setObject:self.moneyStr forKey:@"field4"];
    
    [[Transfer sharedTransfer] startTransfer:@"020001" fskCmd:nil paramDic:dic];
    
}

#pragma mark - 功能函数
- (void)setCardInfoDic:(NSDictionary *)cardInfoDic
{
    InputPwdQueryBalanceViewController *vc = [[InputPwdQueryBalanceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end

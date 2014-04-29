//
//  InputPasswordViewController.m
//  YLTiPhone
//
//  Created by 文彬 on 14-3-28.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "InputPasswordViewController.h"
#import "ConvertUtil.h"
#import "SecurityUtil.h"

@interface InputPasswordViewController ()

@end

@implementation InputPasswordViewController

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
    self.navigationItem.title = @"输入密码";
    
    pswTxtField = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 50, 300, 44) left:@"密码" prompt:@"请输入卡密码"];
    [self.view addSubview:pswTxtField];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 280, 297, 42)];
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
    [super viewWillAppear:YES];
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
    else if(pswTxtField.pwdTF.text.length<6)
    {
        [ApplicationDelegate showErrorPrompt:@"请输入6位长度密码"];
        return;
    }
    
    //NSDictionary *cardInfo = [AppDataCenter sharedAppDataCenter].cardInfoDict;
    
    NSString *temKey = [NSString stringWithFormat:@"%@%@", [AppDataCenter sharedAppDataCenter].__ENCTRACKS, [AppDataCenter sharedAppDataCenter].pinKey ];
    NSString *key = [SecurityUtil encryptUseXOR16:temKey];
    
    NSString *psw = [NSString stringWithFormat:@"%@00",pswTxtField.inputStr];
    NSString *keyResult = [NSString stringWithFormat:@"%@%@",key,[key substringToIndex:16]];
    NSString *enStr = [[SecurityUtil encryptUseTripleDES:[ConvertUtil stringToHexStr:psw] key:keyResult] substringWithRange:NSMakeRange(0, 16)];
    NSLog(@"enStr %@",enStr);
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:enStr forKey:@"AISHUAPIN"];

    NSString *transferCode = @"020022";
    if (self.fromVC == 0) {// 收款
        [dic setObject:self.moneyStr forKey:@"field4"];
    }else if(self.fromVC == 1) {// 余额查询
        transferCode = @"020001";
    }
    [[Transfer sharedTransfer] startTransfer:transferCode fskCmd:nil paramDic:dic];
    
}


@end

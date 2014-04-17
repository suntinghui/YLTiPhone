//
//  ComplementRegisterModifyController.m
//  YLTiPhone
//
//  Created by liao jia on 14-3-26.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "ComplementRegisterModifyController.h"
#import "UITextField+HideKeyBoard.h"

@interface ComplementRegisterModifyController ()

@end

@implementation ComplementRegisterModifyController
@synthesize et_merchant_name, et_email, et_pid;
@synthesize pwd_pay, pwd_pay_confirm;

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
    
    self.navigationItem.title = @"完善注册信息";
    self.hasTopView = true;
    
    //商户姓名
    self.et_merchant_name = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 50, 300, 44) leftImage:@"realname.png" leftImageFrame:CGRectMake(15, 10, 19, 22) prompt:@"商户名称" keyBoardType:UIKeyboardTypeDefault];
    self.et_merchant_name.contentTF.delegate = self;
    [self.et_merchant_name.contentTF hideKeyBoard:self.view:2 hasNavBar:NO];
    [self.view addSubview:self.et_merchant_name];
    
    //身份证
    self.et_pid = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 105, 300, 44) leftImage:@"cardID.png" leftImageFrame:CGRectMake(15, 15, 23, 15) prompt:@"身份证号码" keyBoardType:UIKeyboardTypeDefault];
    self.et_pid.contentTF.delegate = self;
    [self.view addSubview:self.et_pid];
    
    //email
    self.et_email = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 155, 300, 44) leftImage:@"cardID.png" leftImageFrame:CGRectMake(15, 15, 23, 15) prompt:@"邮箱" keyBoardType:UIKeyboardTypeDefault];
    self.et_email.contentTF.delegate = self;
    [self.view addSubview:self.et_email];
    
    //支付密码
    self.pwd_pay = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 205, 300, 44) left:@"" prompt:@"请输入原支付密码"];
    [self.view addSubview:self.pwd_pay];
    
    self.pwd_pay_confirm = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 255, 300, 44) left:@"" prompt:@"请输入6位支付密码"];
    [self.view addSubview:self.pwd_pay_confirm];
    
    
    UIButton *btn_confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_confirm setFrame:CGRectMake(10, 320, 300, 44)];
    [btn_confirm setTitle:@"确认" forState:UIControlStateNormal];
    [btn_confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_confirm.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn_confirm addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn_confirm setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [btn_confirm setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [btn_confirm setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btn_confirm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (BOOL)checkInput
{
    NSString *err  = nil;
    if (self.et_merchant_name.contentTF.text==nil||
        [self.et_merchant_name.contentTF.text isEqualToString:@""])
    {
        err = @"请输入商户姓名";
    }
    else if (self.et_pid.contentTF.text==nil||
             [self.et_pid.contentTF.text isEqualToString:@""])
    {
        err = @"请输入身份证号";
    }
    else if (self.et_email.contentTF.text==nil||
             [self.et_email.contentTF.text isEqualToString:@""])
    {
        err = @"请输入邮箱";
    }
    else if (self.pwd_pay.rsaValue==nil)
    {
        err = @"请输入原支付密码";
    }
    else if (self.pwd_pay_confirm.rsaValue==nil)
    {
        err = @"请输入支付密码";
    }
    
    if (err!=nil) {
        [ApplicationDelegate showErrorPrompt:err];
        return NO;
    }
    
    return YES;
}
-(IBAction)confirmAction:(id)sender
{
    if (![self checkInput]) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    [dic setObject:[et_merchant_name contentTF].text forKey:@"merchant_name"];
    [dic setObject:[et_merchant_name contentTF].text forKey:@"master_name"];
    [dic setObject:[et_pid contentTF].text forKey:@"pid"];
    [dic setObject:[et_email contentTF].text forKey:@"email"];
    [dic setObject:[pwd_pay_confirm rsaValue] forKey:@"paypass"];
    
    [[Transfer sharedTransfer] startTransfer:@"089010" fskCmd:nil paramDic:dic];
}
@end

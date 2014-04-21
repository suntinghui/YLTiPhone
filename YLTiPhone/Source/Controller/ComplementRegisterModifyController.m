//
//  ComplementRegisterModifyController.m
//  YLTiPhone
//
//  Created by liao jia on 14-3-26.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "ComplementRegisterModifyController.h"
#import "UITextField+HideKeyBoard.h"

#define Action_Tag_TypeSelect  100

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
    type = 1;
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 320, VIEWHEIGHT)];
    scrollView.contentSize = CGSizeMake(320, 520);
    [self.view addSubview:scrollView];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 30)];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.text = @"商户类型";
    [scrollView addSubview:typeLabel];
    
    UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    typeButton.frame = CGRectMake(110, 10, 200, 40);
    typeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [typeButton setBackgroundImage:[UIImage imageNamed:@"selectbg.jpg"] forState:UIControlStateNormal];
    typeButton.tag = Action_Tag_TypeSelect;
    [typeButton setTitle:@"个人商户" forState:UIControlStateNormal];
    typeButton.titleEdgeInsets = UIEdgeInsetsMake(0,-20,0,0);
    [typeButton addTarget:self action:@selector(typeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:typeButton];
    
    
    //商户名称
    self.et_merchant_name = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 60, 300, 44) leftImage:@"realname.png" leftImageFrame:CGRectMake(15, 10, 19, 22) prompt:@"商户名称" keyBoardType:UIKeyboardTypeDefault];
    self.et_merchant_name.contentTF.delegate = self;
    self.et_merchant_name.contentTF.enabled = NO;
    [scrollView addSubview:self.et_merchant_name];
    
    //姓名
    self.et_name = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 115, 300, 44) leftImage:@"realname.png" leftImageFrame:CGRectMake(15, 10, 19, 22) prompt:@"姓名" keyBoardType:UIKeyboardTypeDefault];
    self.et_name.contentTF.delegate = self;
    [scrollView addSubview:self.et_name];
    
    //身份证
    self.et_pid = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 165, 300, 44) leftImage:@"cardID.png" leftImageFrame:CGRectMake(15, 15, 23, 15) prompt:@"身份证号码" keyBoardType:UIKeyboardTypeDefault];
    self.et_pid.contentTF.delegate = self;
    [scrollView addSubview:self.et_pid];
    
    //email
    self.et_email = [[LeftImageTextField alloc] initWithFrame:CGRectMake(10, 215, 300, 44) leftImage:@"cardID.png" leftImageFrame:CGRectMake(15, 15, 23, 15) prompt:@"邮箱" keyBoardType:UIKeyboardTypeDefault];
    self.et_email.contentTF.delegate = self;
    [self.et_email.contentTF hideKeyBoard:self.view:2 hasNavBar:YES];
    [scrollView addSubview:self.et_email];
    
    //支付密码
    self.pwd_pay = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 265, 300, 44) left:@"" prompt:@"请输入原支付密码"];
    [self.pwd_pay.pwdTF hideKeyBoard:self.view:2 hasNavBar:YES];
    [scrollView addSubview:self.pwd_pay];
    
    self.pwd_pay_confirm = [[PwdLeftTextField alloc] initWithFrame:CGRectMake(10, 315, 300, 44) left:@"" prompt:@"请输入6位支付密码"];
    [self.pwd_pay_confirm.pwdTF hideKeyBoard:self.view:2 hasNavBar:YES];
    [scrollView addSubview:self.pwd_pay_confirm];
    
    
    UIButton *btn_confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_confirm setFrame:CGRectMake(10, 380, 300, 44)];
    [btn_confirm setTitle:@"确认" forState:UIControlStateNormal];
    [btn_confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_confirm.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn_confirm addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn_confirm setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [btn_confirm setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [btn_confirm setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [scrollView addSubview:btn_confirm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UIActionsheetdelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self clearInput];
    UIButton *button = (UIButton*)[scrollView viewWithTag:Action_Tag_TypeSelect];
    if (buttonIndex==0)
    {
        [button setTitle:@"个人商户" forState:UIControlStateNormal];
        [self.et_name.contentTF setPlaceholder:@"姓名"];
        [self.et_pid.contentTF setPlaceholder:@"身份证号码"];
        type = 1;
        self.et_merchant_name.contentTF.enabled = NO;
    }
    else if(buttonIndex == 1)
    {
        [button setTitle:@"企业商户" forState:UIControlStateNormal];
        [self.et_name.contentTF setPlaceholder:@"法人"];
        [self.et_pid.contentTF setPlaceholder:@"法人身份证号码"];
        type = 2;
        self.et_merchant_name.contentTF.enabled = YES;
    }
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.et_name.contentTF&&type==1&&textField.text.length>0)
    {
        self.et_merchant_name.contentTF.text = [NSString stringWithFormat:@"个体户-%@",self.et_name.contentTF.text];
    }
}

- (BOOL)checkInput
{
    NSString *err  = nil;
    if (self.et_merchant_name.contentTF.text==nil||
        [self.et_merchant_name.contentTF.text isEqualToString:@""])
    {
        err = @"请输入商户名称";
    }
    if (self.et_name.contentTF.text==nil||
        [self.et_name.contentTF.text isEqualToString:@""])
    {
        err = @"请输入姓名";
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

- (void)clearInput
{
    self.et_merchant_name.contentTF.text = nil;
    self.et_name.contentTF.text = nil;
    self.et_pid.contentTF.text = nil;
    self.pwd_pay.pwdTF.text = nil;
    self.pwd_pay_confirm.pwdTF.text = nil;
}

- (void)typeSelect:(UIButton*)button
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"个人商户",@"企业商户", nil];
    [sheet showInView:self.view];
}
-(IBAction)confirmAction:(id)sender
{
    if (![self checkInput]) {
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    [dic setObject:[et_merchant_name contentTF].text forKey:@"merchant_name"];
    [dic setObject:[self.et_name contentTF].text forKey:@"mastername"];
    [dic setObject:[et_pid contentTF].text forKey:@"pid"];
    [dic setObject:[et_email contentTF].text forKey:@"email"];
    [dic setObject:[pwd_pay_confirm rsaValue] forKey:@"paypass"];
    [dic setObject:[NSString stringWithFormat:@"%d",type] forKey:@"merchant_type"];
   
    [[Transfer sharedTransfer] startTransfer:@"089010" fskCmd:nil paramDic:dic];
}
@end

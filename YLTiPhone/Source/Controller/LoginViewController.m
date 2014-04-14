//
//  LoginViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "LoginViewController.h"
#import "UITextField+HideKeyBoard.h"
#import "CatalogViewController.h"
#import "RegisterViewController.h"
#import "SelectPOSViewController.h"
#import "FindLoginPwdViewController.h"

#import "EncryptionUtil.h"
#import "JSONKit.h"
#import "YLTPasswordTextField.h"
#import "SecurityUtil.h"
#import "ConvertUtil.h"
#import "ShowContentViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize phoneNumTF = _phoneNumTF;
@synthesize passwordTF = _passwordTF;
@synthesize forgetPwdButton = _forgetPwdButton;
@synthesize loginButton = _loginButton;
@synthesize registerButton = _registerButton;
@synthesize url= _url;
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
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, [UIColor colorWithWhite:0.0 alpha:0.0], NSBackgroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.title = @"登  录";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginshade-5.png"]];
    self.navigationItem.hidesBackButton = YES;
    
    UIView *loginView = [[UIView alloc] init];
    
    loginView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
    loginView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginViewBG"]];
    
    self.phoneNumTF = [[LeftTextField alloc] initWithFrame:CGRectMake(79, 115, 181, 30) isLong:true];
    [self.phoneNumTF.contentTF setPlaceholder:@"请输入注册时的手机号"];
    self.phoneNumTF.contentTF.delegate = self;
    [self.phoneNumTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    [self.phoneNumTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [loginView addSubview:self.phoneNumTF];
    
    self.passwordTF = [[YLTPasswordTextField alloc] initWithFrame:CGRectMake(79, 166, 181, 30)];
    NSString *pwd = [UserDefaults stringForKey:PWDLOGIN];
//    [self.passwordTF.pwdTF setText:pwd];
    [loginView addSubview:self.passwordTF];
    
    
    //记住密码复选框
    agreeButtonTouch = [UserDefaults boolForKey:REMBERPWD];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setFrame:CGRectMake(33, 211, 20, 20)];
    NSString *btn_img ;
    if (agreeButtonTouch) {
        btn_img = @"btn_comment_sametime_select.png";
    }else{
        btn_img = @"btn_comment_sametime_unselect.png";
    }
    [agreeButton setBackgroundImage:[UIImage imageNamed:btn_img] forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:agreeButton];
    
    UIButton *btn_forget_pwd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_forget_pwd setFrame:CGRectMake(210, 206, 100, 30)];
    [btn_forget_pwd setTitle:@"取回密码" forState:UIControlStateNormal];
    [btn_forget_pwd setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    btn_forget_pwd.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn_forget_pwd addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:btn_forget_pwd];
    
    //注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(30, 280, 120, 35)];
    [registerButton setTitle:@"注 册" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"RegisterButton_normal.png"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"RegisterButton_highlight.png"] forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(regesterAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:registerButton];
    
    //登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(175, 280, 120, 35)];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"LoginButton_normal.png"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"LoginButton_highlight.png"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginButton];
    
    
    [self.phoneNumTF.contentTF hideKeyBoard:self.view :2 hasNavBar:NO];
    // 手机号赋初值
    self.phoneNumTF.contentTF.text = [[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"];
    
    [self.view addSubview:loginView];

//暂时隐藏终端按钮
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"终端" style:UIBarButtonItemStyleBordered target:self action:@selector(selectPost:)];
//    self.navigationItem.rightBarButtonItem = rightButton;
//    
    [self checkUpdate];
    
}

- (void)selectPost:(id)sender
{
    SelectPOSViewController *selectPosVC = [[SelectPOSViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:selectPosVC animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
//    [self.passwordTF clearInput];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (BOOL) checkValue
{
    if ([self.phoneNumTF.contentTF.text length] < 11)
    {
        [ApplicationDelegate showErrorPrompt:@"请输入11位手机号码"];
        return NO;
    }
    else if (self.passwordTF.md5Value == nil || [self.passwordTF.md5Value isEqualToString:@""])
    {
        [ApplicationDelegate showErrorPrompt:@"请输入6位商户密码"];
        return NO;
    }
    return YES;
}

-(IBAction)loginAction:(id)sender
{
    if ([self checkValue])
    {
        [[AppDataCenter sharedAppDataCenter] setPhoneNum:[[self.phoneNumTF contentTF] text]];

        [UserDefaults setObject:self.passwordTF.pwdTF.text forKey:PWDLOGIN];
        [UserDefaults setBool:agreeButtonTouch forKey:REMBERPWD];
        [UserDefaults synchronize];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[self.phoneNumTF contentTF] text] forKey:@"tel"];
        [dic setObject:self.passwordTF.md5Value forKey:@"logpass"];
//        [dic setObject:@"2BFDD621B461950E3D7038391295B03B" forKey:@"logpass"];

        //[[Transfer sharedTransfer] startTransfer:@"086000" fskCmd:@"Request_GetExtKsn#Request_VT" paramDic:dic];
        [[Transfer sharedTransfer] startTransfer:@"089016" fskCmd:nil paramDic:dic];
        
    }
}

-(void)checkUpdate
{
   
    [[Transfer sharedTransfer] startTransfer:@"089018" fskCmd:nil paramDic:nil];
    
}
- (IBAction)regesterAction:(id)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)forgetPwdAction:(id)sender
{
    FindLoginPwdViewController *vc = [[FindLoginPwdViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTF.contentTF && [[NSString stringWithFormat:@"%@%@",self.phoneNumTF.contentTF.text,string] isEqualToString:@"40051656598"]) {
//        ChongZhengViewController *chongzhengVC = [[ChongZhengViewController alloc] initWithNibName:@"ChongZhengViewController" bundle:nil];
//        [self.navigationController pushViewController:chongzhengVC animated:YES];
        
        return NO;
    } else if (textField == self.phoneNumTF.contentTF && [[NSString stringWithFormat:@"%@%@",self.phoneNumTF.contentTF.text,string] isEqualToString:@"40058965896"]) {
//        RecordDeviceViewController *rdvc = [[RecordDeviceViewController alloc] init];
//        [self.navigationController pushViewController:rdvc animated:YES];
    }
    
    if (textField == self.phoneNumTF.contentTF) {
        if(range.location>=11){
            return NO;
        }
    }
    return YES;
}

#pragma mark - UINavigationControllerDelegate Method
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animate{
    if ( self == viewController) {
        [navigationController setNavigationBarHidden:YES animated:animate];
    } else  {
        [navigationController setNavigationBarHidden:NO animated:animate];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)showAlertViewUpdate:(NSDictionary *) dic {
    NSDictionary *dic_version = [[dic objectForKey:@"apires"] objectFromJSONString];
    self.url = [dic_version objectForKey:@"url"];
    NSString *version = [dic_version objectForKey:@"version"];
    int version_d = [version intValue];
    if(version_d < version_num){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"有新版本，是否下载更新？！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
        alertView.tag = 100;
        [alertView show];
    }
    


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            
            ShowContentViewController *vc = [[ShowContentViewController alloc] initWithUrl:self.url];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end

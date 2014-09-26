//
//  ConfirmCancelResultViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "ConfirmCancelResultViewController.h"
#import "SalesSlipDetailViewController.h"
#import "Transfer.h"
#import "Transfer+Action.h"

@interface ConfirmCancelResultViewController ()

@end

@implementation ConfirmCancelResultViewController

@synthesize resultMsg;

- (id)initWithResultMessage:(NSString*)resMsg
{
    if (self = [super initWithNibName:@"ResultViewController" bundle:nil]) {
        self.resultMsg = resMsg;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasTopView = true;
    //
    // TODO 下面的delegate做何用
    // self.navigationController.delegate = self;
    //
    self.title = @"收款";
    
    [self.navigationItem setHidesBackButton:YES]; //隐藏返回按纽
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, VIEWHEIGHT)];
    [scrollView setContentSize:CGSizeMake(320, 470)];
    scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success.png"]];
    [imageView setFrame:CGRectMake(122, 30, 77, 75)];
    [scrollView addSubview:imageView];
    
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 115, 200, 40)];
    [errorLabel setBackgroundColor:[UIColor clearColor]];
    errorLabel.textColor = [UIColor blackColor];
    [errorLabel setTextAlignment:NSTextAlignmentCenter];
    if (self.resultMsg) {
        errorLabel.text = self.resultMsg;
    }
    errorLabel.font = [UIFont systemFontOfSize:18];
    [scrollView addSubview:errorLabel];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 190 +(iPhone5?18:0), 297, 42)];
    if (ApplicationDelegate.printVersion) {
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    } else {
        [confirmButton setTitle:@"去签名" forState:UIControlStateNormal];
    }
    
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [scrollView addSubview:confirmButton];
    
    UIImage *image = [UIImage imageNamed:@"explain.png"];
    UIImageView *explainIV = [[UIImageView alloc] initWithImage:[self stretchImage:image]];
    [explainIV setFrame:CGRectMake(10, 267 +(iPhone5?18:0), 297, 180)];
    [scrollView addSubview:explainIV];
    
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 282, 160)];
    explainLabel.backgroundColor = [UIColor clearColor];
    explainLabel.textColor = [UIColor blackColor];
    explainLabel.font = [UIFont systemFontOfSize:15];
    explainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    explainLabel.numberOfLines = 0;
    explainLabel.text = [NSString stringWithFormat:@"使用说明\n1、消费(撤销)成功后，交易资金将会转移到你的银行帐户中;\n2、持卡人需要在签购单上正确签名，作为消费(撤销)凭证;\n3、商户可以使用“签购单查询”来调阅签购单,也可以在%@门户网站上调阅;\n4、可以将该交易的签购单以短信方式发送给消费者查阅。",ApplicationDelegate.proName];
    
    [explainIV addSubview:explainLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)confirmButtonAction:(id)sender
{
    if (ApplicationDelegate.printVersion) {
        // 签购单打印成功后需要告知后台。
        [[Transfer sharedTransfer].receDic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__UUID"] forKey:@"imei"];
        [[Transfer sharedTransfer].receDic setObject:@"" forKey:@"receivePhoneNo"];
        [[Transfer sharedTransfer].receDic setObject:@"" forKey:@"fieldImage"];
        [[Transfer sharedTransfer] uploadSignImageAction];
        
        [self popToCatalogViewController];
        
    } else {
        SalesSlipDetailViewController *vc = [[SalesSlipDetailViewController alloc] init];
        [[ApplicationDelegate topViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self print];
}

- (void) repeatPrint:(NSString *) errReason
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"打印凭条失败。失败原因: %@ ,请检查设备并重新打印。", errReason] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新打印", nil];
    [alert show];
}

- (void) print
{
    if (ApplicationDelegate.printVersion) {
        [[Transfer sharedTransfer] startTransfer:nil fskCmd:@"Print" paramDic:nil];
    }
}

#pragma mark - UINavigationControllerDelegate Method
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animate{
    if (self == viewController) {
        navigationController.navigationItem.hidesBackButton = YES;
        
    } else  {
        navigationController.navigationItem.hidesBackButton = NO;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        [self print];
    }
}

@end


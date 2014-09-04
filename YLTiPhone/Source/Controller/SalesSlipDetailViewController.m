//
//  SalesSlipDetailViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "SalesSlipDetailViewController.h"
#import "SignViewController.h"
#import "StringUtil.h"
#import "DateUtil.h"
#import "EncryptionUtil.h"
#define left_w  100
@interface SalesSlipDetailViewController ()

@end

@implementation SalesSlipDetailViewController
@synthesize scrollView = _scrollView;
@synthesize gotoSignButton = _gotoSignButton;
@synthesize confirmButton = _confirmButton;
@synthesize imageView = _imageView;
@synthesize bgImageView = _bgImageView;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"签购单";
    self.hasTopView = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, VIEWHEIGHT+40)];
    [self.scrollView setContentSize:CGSizeMake(320, 640)];
    self.scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.scrollView];
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[self stretchImage:[UIImage imageNamed:@"salesslip.png"]]];
    [self.bgImageView setFrame:CGRectMake(5, 10+ios7_h, 310, 570)];
    [self.scrollView addSubview:self.bgImageView];
    
    UIImageView *iv_logo = [[UIImageView alloc] initWithFrame:CGRectMake(47, 22+ios7_h, 86/2, 54/2)];
    [iv_logo setImage:[UIImage imageNamed:@"yinlian"]];
    [self.scrollView addSubview:iv_logo];
    
    UILabel *label_sign = [[UILabel alloc] initWithFrame:CGRectMake(110, 10+ios7_h, 100, 40)];
    [label_sign setBackgroundColor:[UIColor clearColor]];
    [label_sign setText:@"签购单"];
    [label_sign setTextAlignment:NSTextAlignmentCenter];
    [label_sign setFont:[UIFont boldSystemFontOfSize:17]];
    [self.scrollView addSubview:label_sign];
    
    UILabel *label_right = [[UILabel alloc] initWithFrame:CGRectMake(200, 30+ios7_h, 100, 40)];
    [label_right setBackgroundColor:[UIColor clearColor]];
    [label_right setText:@"持卡人存根"];
    [label_right setFont:[UIFont systemFontOfSize:14]];
    [self.scrollView addSubview:label_right];
    
    //bg1
    UIImage *image1 = [UIImage imageNamed:@"textInput.png"];
    UIImageView *bgIV1 = [[UIImageView alloc] initWithImage:[self stretchImage:image1]];
    [bgIV1 setFrame:CGRectMake(28, 60, 253, 100)];
    [self.bgImageView addSubview:bgIV1];
    
    UILabel *tmpNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, left_w, 30)];
    [tmpNameLabel setText:@"商户名称："];
    [self setLabelStyle:tmpNameLabel];
    [bgIV1 addSubview:tmpNameLabel];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 150, 30)];
    [nameLabel setTextAlignment:NSTextAlignmentRight];
    [nameLabel setText:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__MERCHERNAME"]];
    [self setLabelStyle:nameLabel];
    [bgIV1 addSubview:nameLabel];
    
    UILabel *tmpNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, left_w, 30)];
    [tmpNumLabel setText:@"商户编号："];
    [self setLabelStyle:tmpNumLabel];
    [bgIV1 addSubview:tmpNumLabel];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 150, 30)];
    [numLabel setTextAlignment:NSTextAlignmentRight];
    [numLabel setText:[Transfer sharedTransfer].receDic[@"apires"][@"MID"]];
    [self setLabelStyle:numLabel];
    [bgIV1 addSubview:numLabel];
    
    UILabel *tmpTerminalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, left_w, 30)];
    [tmpTerminalNumLabel setText:@"终端编号："];
    [self setLabelStyle:tmpTerminalNumLabel];
    [bgIV1 addSubview:tmpTerminalNumLabel];
    UILabel *terminalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 150, 30)];
    [terminalNumLabel setTextAlignment:NSTextAlignmentRight];
    [terminalNumLabel setText:[Transfer sharedTransfer].receDic[@"apires"][@"TID"]];
    [self setLabelStyle:terminalNumLabel];
    [bgIV1 addSubview:terminalNumLabel];
    
    //bg2
    UIImage *image2 = [UIImage imageNamed:@"textInput.png"];
    UIImageView *bgIV2 = [[UIImageView alloc] initWithImage:[self stretchImage:image2]];
    [bgIV2 setFrame:CGRectMake(28, 170, 253, 310)];
    [self.bgImageView addSubview:bgIV2];
    
    UILabel *tmpCardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 70, 30)];
    [tmpCardNumLabel setText:@"卡号："];
    [self setLabelStyle:tmpCardNumLabel];
    [bgIV2 addSubview:tmpCardNumLabel];
    UILabel *cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 150, 30)];
    [cardNumLabel setTextAlignment:NSTextAlignmentRight];
    [cardNumLabel setText:[StringUtil formatAccountNo:[Transfer sharedTransfer].receDic[@"apires"][@"CARD"]]];
    [self setLabelStyle:cardNumLabel];
    [bgIV2 addSubview:cardNumLabel];
    
    UILabel *tmpCardBankLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 70, 30)];
    [tmpCardBankLabel setText:@"发卡行："];
    [self setLabelStyle:tmpCardBankLabel];
    [bgIV2 addSubview:tmpCardBankLabel];
    UILabel *cardBankLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 150, 30)];
    [cardBankLabel setTextAlignment:NSTextAlignmentRight];
    [cardBankLabel setText:[[Transfer sharedTransfer].receDic objectForKey:@"issuerBank"]];
    [self setLabelStyle:cardBankLabel];
    [bgIV2 addSubview:cardBankLabel];
    
    UILabel *tmpValidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, left_w, 30)];
    [tmpValidityLabel setText:@"卡有效期："];
    [self setLabelStyle:tmpValidityLabel];
    [bgIV2 addSubview:tmpValidityLabel];
    UILabel *validityLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 150, 30)];
    [validityLabel setTextAlignment:NSTextAlignmentRight];
    [validityLabel setText:[[Transfer sharedTransfer].receDic objectForKey:@"field15"]];
    [self setLabelStyle:validityLabel];
    [bgIV2 addSubview:validityLabel];
    
    UILabel *tmptradeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, left_w, 30)];
    [tmptradeDateLabel setText:@"交易日期："];
    [self setLabelStyle:tmptradeDateLabel];
    [bgIV2 addSubview:tmptradeDateLabel];
    UILabel *tradeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 80, 150, 30)];
    [tradeDateLabel setTextAlignment:NSTextAlignmentRight];
    [tradeDateLabel setText:[DateUtil formatDateTime:[NSString stringWithFormat:@"%@%@", [Transfer sharedTransfer].receDic[@"apires"][@"XTDE"], [Transfer sharedTransfer].receDic[@"apires"][@"XTTM"]]]];
    [self setLabelStyle:tradeDateLabel];
    [bgIV2 addSubview:tradeDateLabel];
    
    UILabel *tmpTradeStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, left_w, 30)];
    [tmpTradeStyleLabel setText:@"交易类型："];
    [self setLabelStyle:tmpTradeStyleLabel];
    [bgIV2 addSubview:tmpTradeStyleLabel];
    UILabel *tradeStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 105, 150, 30)];
    [tradeStyleLabel setTextAlignment:NSTextAlignmentRight];
    [tradeStyleLabel setText:[[AppDataCenter sharedAppDataCenter].transferNameDic objectForKey:[[Transfer sharedTransfer].receDic objectForKey:@"fieldTrancode"]]];
    [self setLabelStyle:tradeStyleLabel];
    [bgIV2 addSubview:tradeStyleLabel];
    
    UILabel *tmpFlowNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, left_w, 30)];
    [tmpFlowNumLabel setText:@"交易流水号："];
    [self setLabelStyle:tmpFlowNumLabel];
    [bgIV2 addSubview:tmpFlowNumLabel];
    UILabel *flowNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 130, 150, 30)];
    [flowNumLabel setTextAlignment:NSTextAlignmentRight];
    [flowNumLabel setText:[Transfer sharedTransfer].receDic[@"apires"][@"SLSH"]];
    [self setLabelStyle:flowNumLabel];
    [bgIV2 addSubview:flowNumLabel];
    
    UILabel *tmpAuthenticationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, left_w, 30)];
    [tmpAuthenticationLabel setText:@"授权号："];
    [self setLabelStyle:tmpAuthenticationLabel];
    [bgIV2 addSubview:tmpAuthenticationLabel];
    UILabel *authenticationLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 155, 150, 30)];
    [authenticationLabel setTextAlignment:NSTextAlignmentRight];
    [authenticationLabel setText:[[Transfer sharedTransfer].receDic objectForKey:@"field38"]];
    [self setLabelStyle:authenticationLabel];
    [bgIV2 addSubview:authenticationLabel];
    
    UILabel *tmpReferenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, left_w, 30)];
    [tmpReferenceLabel setText:@"参考号："];
    [self setLabelStyle:tmpReferenceLabel];
    [bgIV2 addSubview:tmpReferenceLabel];
    UILabel *referenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 180, 150, 30)];
    [referenceLabel setTextAlignment:NSTextAlignmentRight];
    [referenceLabel setText:[Transfer sharedTransfer].receDic[@"apires"][@"XTLS"]];
    [self setLabelStyle:referenceLabel];
    [bgIV2 addSubview:referenceLabel];
    
    UILabel *tmpbatchNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, left_w, 30)];
    [tmpbatchNumLabel setText:@"批次号："];
    [self setLabelStyle:tmpbatchNumLabel];
    [bgIV2 addSubview:tmpbatchNumLabel];
    UILabel *batchNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 205, 150, 30)];
    [batchNumLabel setTextAlignment:NSTextAlignmentRight];
    [batchNumLabel setText:[Transfer sharedTransfer].receDic[@"apires"][@"cycle_no"]];
    [self setLabelStyle:batchNumLabel];
    [bgIV2 addSubview:batchNumLabel];
    
    UILabel *tmpTradeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 233, left_w, 30)];
    [tmpTradeMoneyLabel setText:@"交易金额："];
    [self setLabelStyle:tmpTradeMoneyLabel];
    [bgIV2 addSubview:tmpTradeMoneyLabel];
    UILabel *tradeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 230, 150, 40)];
    [tradeMoneyLabel setTextAlignment:NSTextAlignmentRight];
//    [tradeMoneyLabel setText:[StringUtil string2SymbolAmount:[Transfer sharedTransfer].receDic[@"apires"][@"JE"]]];
    [tradeMoneyLabel setText:[Transfer sharedTransfer].receDic[@"apires"][@"JE"]];
   
    [tradeMoneyLabel setBackgroundColor:[UIColor clearColor]];
    [tradeMoneyLabel setTextColor:[UIColor blueColor]];
    [tradeMoneyLabel setFont:[UIFont systemFontOfSize:17]];
    [bgIV2 addSubview:tradeMoneyLabel];
    
    UILabel *tmpCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 70, 30)];
    [tmpCommentLabel setText:@"备注："];
    [self setLabelStyle:tmpCommentLabel];
    [bgIV2 addSubview:tmpCommentLabel];
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 270, 150, 30)];
    [commentLabel setTextAlignment:NSTextAlignmentRight];
    [commentLabel setText:[[Transfer sharedTransfer].receDic objectForKey:@"remark"]];
    [self setLabelStyle:commentLabel];
    [bgIV2 addSubview:commentLabel];
    
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 480, 253, 30)];
    [instructionLabel setTextColor:[UIColor grayColor]];
    [instructionLabel setBackgroundColor:[UIColor clearColor]];
    [instructionLabel setFont:[UIFont systemFontOfSize:15]];
    instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    instructionLabel.numberOfLines = 0;
    instructionLabel.textAlignment = UITextAlignmentCenter;
    [instructionLabel setText:@"本人确认以上信息同意将其计入本卡账户"];
    [self.bgImageView addSubview:instructionLabel];
    
    self.gotoSignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gotoSignButton setFrame:CGRectMake(35, 525+ios7_h, 250, 40)];
    [self.gotoSignButton setTitle:@"请持卡人签名" forState:UIControlStateNormal];
    [self.gotoSignButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.gotoSignButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.gotoSignButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.gotoSignButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [self.gotoSignButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [self.gotoSignButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [self.scrollView addSubview:self.gotoSignButton];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 488, 250, 90)];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setFrame:CGRectMake(35, 592, 250, 40)];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.confirmButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:YES];
//    //设置导航栏旋转
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
//    self.navigationController.navigationBar.transform = CGAffineTransformMakeRotation(0);
    
}

-(IBAction)confirmButtonAction:(id)sender
{
    [[Transfer sharedTransfer].receDic setObject:[self getMD5Value] forKey:@"MD5"];
    
    SignViewController *signVC = [[SignViewController alloc] initWithNibName:@"SignViewController" bundle:nil];
    signVC.delegate = self;
    [ApplicationDelegate.rootNavigationController pushViewController:signVC animated:YES];
    
}

-(IBAction)close:(id)sender
{
    [self popToCatalogViewController];
}

- (NSUInteger)supportedInterfaceOrientations
{
    //    return UIInterfaceOrientationMaskLandscapeLeft;
    return 0;
}

- (NSString *) getMD5Value
{
    // 银联返回的检索参考号（12位）
    NSString *indexNo = [[Transfer sharedTransfer].receDic objectForKey:@"field37"];
    // 时间戳
    NSString *dateTime = [DateUtil getSystemDateTime2];
    // 手机中已经保存的UUID
    NSString *UUID = [[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__UUID"];
    
    return [EncryptionUtil MD5Encrypt:[NSString stringWithFormat:@"%@%@%@", indexNo, dateTime, UUID]];
}

- (void)abstractViewControllerDone:(id) obj
{
    NSLog(@"完成签名后回调...");
    
    [self.gotoSignButton removeFromSuperview];
    
    [self.scrollView setContentSize:CGSizeMake(320, 660)];
    [self.bgImageView setFrame:CGRectMake(5, 10+ios7_h, 310, 670)];
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[self stretchImage:[UIImage imageNamed:@"salesslip.png"]]];
    [self.imageView setImage:obj];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.confirmButton];
}

@end

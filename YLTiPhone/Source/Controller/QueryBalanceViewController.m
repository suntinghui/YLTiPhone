//
//  QueryBalanceViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "QueryBalanceViewController.h"

@interface QueryBalanceViewController ()

@end

@implementation QueryBalanceViewController

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
    self.hasTopView = true;
    self.navigationItem.title = @"银行卡余额查询";
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, VIEWHEIGHT)];
    [scrollView setContentSize:CGSizeMake(320, VIEWHEIGHT)];
    scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"swipcard.png"]];
    [imageView setFrame:CGRectMake(110, 10, 100, 125)];
    [scrollView addSubview:imageView];
    
    UILabel *messageExplainLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 155, 221, 40)];
    messageExplainLabel.text = @"请按[刷卡]按钮开始交易";
    [messageExplainLabel setTextAlignment:NSTextAlignmentCenter];
    messageExplainLabel.font  = [UIFont systemFontOfSize:18];
    messageExplainLabel.textColor = [UIColor blackColor];
    messageExplainLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:messageExplainLabel];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, VIEWHEIGHT - 150, 297, 42)];
    [confirmButton setTitle:@"刷    卡" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [scrollView addSubview:confirmButton];
    
    UIImage *image = [UIImage imageNamed:@"explain.png"];
    UIImageView *explainIV = [[UIImageView alloc] initWithImage:[self stretchImage:image]];
    [explainIV setFrame:CGRectMake(10, VIEWHEIGHT - 90, 297, 80)];
    [scrollView addSubview:explainIV];
    
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 282, 60)];
    explainLabel.backgroundColor = [UIColor clearColor];
    explainLabel.textColor = [UIColor blackColor];
    explainLabel.font = [UIFont systemFontOfSize:15];
    explainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    explainLabel.numberOfLines = 0;
    
    explainLabel.text = @"使用说明\n1、您可以查到银行卡余额信息\n2、银行卡余额信息将显示到刷卡器上";
    [explainIV addSubview:explainLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)confirmButtonAction:(id)sender
{
    [[Transfer sharedTransfer] startTransfer:@"020001" fskCmd:@"Request_GetExtKsn#Request_VT#Request_GetDes#Request_GetPin|string:0" paramDic:nil];
}
/*
<input
id="balancequery_ConfirmBtn"
actionId="queryBalance"
fsk="Get_PsamNo|null#Get_VendorTerID|null#Get_EncTrack|int:0,int:0,string:null,int:60#Get_PIN|int:0,int:0,string:0,string:null,string:__PAN,int:60"
layoutParamsTemplateIds="linearLayoutParams01"
margin="20,20,20,0"
templateId="button06"
transfer="020001"
type="button"
value="刷     卡" >
</input>
 */
@end

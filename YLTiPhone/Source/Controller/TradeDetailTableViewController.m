//
//  TradeDetailTableViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "TradeDetailTableViewController.h"
#import "DateUtil.h"

#define left_w  100
@interface TradeDetailTableViewController ()

@end

@implementation TradeDetailTableViewController

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
    self.navigationItem.title = @"交易流水详情";
//    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, VIEWHEIGHT+41) style:UITableViewStyleGrouped];
//    self.myTableView.delegate = self;
//    self.myTableView.dataSource = self;
//    [self.myTableView setBackgroundColor:[UIColor clearColor]];
//    self.myTableView.backgroundView  = nil;
//    [self.view addSubview:self.myTableView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, VIEWHEIGHT+40)];
    [self.scrollView setContentSize:CGSizeMake(320, 600)];
    self.scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.scrollView];
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[self stretchImage:[UIImage imageNamed:@"salesslip.png"]]];
    [self.bgImageView setFrame:CGRectMake(5, 5+ios7_h, 310, 570)];
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
    [nameLabel setText:self.detailModel.merchant_name];
    [self setLabelStyle:nameLabel];
    [bgIV1 addSubview:nameLabel];
    
    UILabel *tmpNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, left_w, 30)];
    [tmpNumLabel setText:@"商户编号："];
    [self setLabelStyle:tmpNumLabel];
    [bgIV1 addSubview:tmpNumLabel];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 150, 30)];
    [numLabel setTextAlignment:NSTextAlignmentRight];
    [numLabel setText:self.detailModel.merchant_id];
    [numLabel setTextColor:[UIColor blueColor]];
    [numLabel setFont:[UIFont systemFontOfSize:15]];
    [bgIV1 addSubview:numLabel];
    
    UILabel *tmpTerminalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, left_w, 30)];
    [tmpTerminalNumLabel setText:@"终端编号："];
    [self setLabelStyle:tmpTerminalNumLabel];
    [bgIV1 addSubview:tmpTerminalNumLabel];
    UILabel *terminalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 150, 30)];
    [terminalNumLabel setTextAlignment:NSTextAlignmentRight];
    [terminalNumLabel setText:self.detailModel.terminal_id];
    [terminalNumLabel setTextColor:[UIColor blueColor]];
    [terminalNumLabel setFont:[UIFont systemFontOfSize:15]];
    [bgIV1 addSubview:terminalNumLabel];
    
    //bg2
    UIImage *image2 = [UIImage imageNamed:@"textInput.png"];
    UIImageView *bgIV2 = [[UIImageView alloc] initWithImage:[self stretchImage:image2]];
    [bgIV2 setFrame:CGRectMake(28, 170, 253, 250)];
    [self.bgImageView addSubview:bgIV2];
    
    UILabel *tmpCardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 70, 30)];
    [tmpCardNumLabel setText:@"卡号："];
    [self setLabelStyle:tmpCardNumLabel];
    [bgIV2 addSubview:tmpCardNumLabel];
    UILabel *cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 190, 30)];
    [cardNumLabel setTextAlignment:NSTextAlignmentRight];
    [cardNumLabel setText:self.detailModel.account1];
    [self setLabelStyle:cardNumLabel];
    [bgIV2 addSubview:cardNumLabel];
    
    UILabel *tmptradeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, left_w, 30)];
    [tmptradeDateLabel setText:@"交易日期："];
    [self setLabelStyle:tmptradeDateLabel];
    [bgIV2 addSubview:tmptradeDateLabel];
    UILabel *tradeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 150, 30)];
    [tradeDateLabel setTextAlignment:NSTextAlignmentRight];
    [tradeDateLabel setText:self.detailModel.localdate];
    [self setLabelStyle:tradeDateLabel];
    [bgIV2 addSubview:tradeDateLabel];
    
    UILabel *tmpTradeStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, left_w, 30)];
    [tmpTradeStyleLabel setText:@"交易类型："];
    [self setLabelStyle:tmpTradeStyleLabel];
    [bgIV2 addSubview:tmpTradeStyleLabel];
    UILabel *tradeStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 150, 30)];
    [tradeStyleLabel setTextAlignment:NSTextAlignmentRight];
    [tradeStyleLabel setText:self.detailModel.note];
    [self setLabelStyle:tradeStyleLabel];
    [bgIV2 addSubview:tradeStyleLabel];
    
    UILabel *tmpFlowNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, left_w, 30)];
    [tmpFlowNumLabel setText:@"交易流水号："];
    [self setLabelStyle:tmpFlowNumLabel];
    [bgIV2 addSubview:tmpFlowNumLabel];
    UILabel *flowNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 80, 150, 30)];
    [flowNumLabel setTextAlignment:NSTextAlignmentRight];
    [flowNumLabel setText:self.detailModel.snd_log];
    [self setLabelStyle:flowNumLabel];
    [bgIV2 addSubview:flowNumLabel];
    
    UILabel *tmpReferenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, left_w, 30)];
    [tmpReferenceLabel setText:@"参考号："];
    [self setLabelStyle:tmpReferenceLabel];
    [bgIV2 addSubview:tmpReferenceLabel];
    UILabel *referenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 105, 150, 30)];
    [referenceLabel setTextAlignment:NSTextAlignmentRight];
    [referenceLabel setText:self.detailModel.local_log];
    [self setLabelStyle:referenceLabel];
    [bgIV2 addSubview:referenceLabel];
    
    UILabel *tmpbatchNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, left_w, 30)];
    [tmpbatchNumLabel setText:@"批次号："];
    [self setLabelStyle:tmpbatchNumLabel];
    [bgIV2 addSubview:tmpbatchNumLabel];
    UILabel *batchNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 130, 150, 30)];
    [batchNumLabel setTextAlignment:NSTextAlignmentRight];
    [batchNumLabel setText:self.detailModel.snd_cycle];
    [self setLabelStyle:batchNumLabel];
    [bgIV2 addSubview:batchNumLabel];
    
    UILabel *tmpTradeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, left_w, 30)];
    [tmpTradeMoneyLabel setText:@"交易金额："];
    [self setLabelStyle:tmpTradeMoneyLabel];
    [bgIV2 addSubview:tmpTradeMoneyLabel];
    UILabel *tradeMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 155, 150, 30)];
    [tradeMoneyLabel setTextAlignment:NSTextAlignmentRight];
    [tradeMoneyLabel setText:[NSString stringWithFormat:@"￥%@",self.detailModel.amount]];
    [self setLabelStyle:tradeMoneyLabel];
    [bgIV2 addSubview:tradeMoneyLabel];
    
    UILabel *tmpTradeConditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, left_w, 30)];
    [tmpTradeConditionLabel setText:@"交易状态："];
    [self setLabelStyle:tmpTradeConditionLabel];
    [bgIV2 addSubview:tmpTradeConditionLabel];
    UILabel *tradeConditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 180, 150, 30)];
    [tradeConditionLabel setTextAlignment:NSTextAlignmentRight];
    [tradeConditionLabel setText:self.detailModel.rspmsg];
    [self setLabelStyle:tradeConditionLabel];
    [bgIV2 addSubview:tradeConditionLabel];
    
    UILabel *tmpCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, left_w, 30)];
    [tmpCommentLabel setText:@"交易备注："];
    [self setLabelStyle:tmpCommentLabel];
    [bgIV2 addSubview:tmpCommentLabel];
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 205, 150, 30)];
    [commentLabel setTextAlignment:NSTextAlignmentRight];
    [commentLabel setText:self.detailModel.note];
    [self setLabelStyle:commentLabel];
    [bgIV2 addSubview:commentLabel];

    //bg3
    UIImage *image3 = [UIImage imageNamed:@"textInput.png"];
    UIImageView *bgIV3 = [[UIImageView alloc] initWithImage:[self stretchImage:image3]];
    [bgIV3 setFrame:CGRectMake(28, 430, 253, 60)];
    [self.bgImageView addSubview:bgIV3];
    
    UILabel *tmpSignatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 70, 30)];
    [tmpSignatureLabel setText:@"签名："];
    [self setLabelStyle:tmpSignatureLabel];
    [bgIV3 addSubview:tmpSignatureLabel];
    
    NSData *data = [NSData dataFromBase64String:self.detailModel.image];
    UIImage *image = [UIImage imageWithData:data scale:1];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(90, 5, 150, 50)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.image = image;
    [bgIV3 addSubview:imgView];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setFrame:CGRectMake(35, 505+ios7_h, 250, 40)];
    if (ApplicationDelegate.printVersion)
    {
        [self.confirmButton setTitle:@"打印凭条" forState:UIControlStateNormal];
    }
    else
    {
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    [self.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.confirmButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [self.scrollView addSubview:self.confirmButton];
    
    
//    [[Transfer sharedTransfer] startTransfer:nil fskCmd:@"Request_GetExtKsn" paramDic:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDataCenter sharedAppDataCenter].detailModel = self.detailModel;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppDataCenter sharedAppDataCenter].detailModel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) repeatPrint:(NSString *) errReason
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"打印凭条失败。失败原因: %@ ,请检查设备并重新打印。", errReason] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新打印", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        if (ApplicationDelegate.printVersion)
        {
            [[Transfer sharedTransfer] startTransfer:nil fskCmd:@"Print" paramDic:nil];
        }
    }
}

-(IBAction)close:(id)sender
{

    if (ApplicationDelegate.printVersion)
    {
           [[Transfer sharedTransfer] startTransfer:nil fskCmd:@"Print" paramDic:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    NSMutableArray* array=[[NSMutableArray alloc] init];
//    
//    [array addObject:[NSString stringWithFormat:@"11\n商户存根            请妥善保管\n"]];
//    [array addObject:[NSString stringWithFormat:@"12商户名称(MERCHANT NAME):\n    %@", [[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__MERCHERNAME"]]];
//    [array addObject:[NSString stringWithFormat:@"00商户编号(MERCHANT NO):\n    %@", self.detailModel.merchant_id]];
//    [array addObject:[NSString stringWithFormat:@"00终端编号(TERMINAL NAME):\n    %@", self.detailModel.terminal_id]];
//
//    
//    [array addObject:[NSString stringWithFormat:@"00卡号(CARD NO):\n    %@",self.detailModel.account1]];
//    
//    [array addObject:[NSString stringWithFormat:@"00交易类型(TRANS TYPE):\n          %@", self.detailModel.note]];
//    [array addObject:[NSString stringWithFormat:@"00交易日期和时间(DATE/TIME):\n    %@", [DateUtil formatDateTime:[NSString stringWithFormat:@"%@%@", self.detailModel.localdate,self.detailModel.localtime]]]];
//    [array addObject:[NSString stringWithFormat:@"00交易金额(AMOUNT):\n    %@", self.detailModel.amount]];
//    [array addObject:[NSString stringWithFormat:@"00参考号(REFER NO):\n    %@", self.detailModel.local_log]];
//    [array addObject:[NSString stringWithFormat:@"00交易批次号(BATCH NO):\n    %@",self.detailModel.snd_cycle]];
//    [array addObject:[NSString stringWithFormat:@"00交易流水号(SERIAL NO):\n    %@", self.detailModel.snd_log]];
//    
//    [array addObject:[NSString stringWithFormat:@"00备注(REFERENCE):%@", self.detailModel.note]];
//    [array addObject:@"21持卡人签名\n\n\n\n\n\n本人确认以上交易，同意将其计入本卡账户\nI ACKNOWLEDGE SATISFACTORY RECEIPT OF RELATIVE GOODS/SERVICES"];
//    [array addObject:@"22"];
//    
//    [[Transfer sharedTransfer].m_vcom rmPrint3:array pCnt:2 pakLen:350];
}

//#pragma mark- tableview delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (section==0) {
//        return 3;
//    }
//    else if(section ==1)
//    {
//        return 9;
//        
//    }
//    return 1;
//}
//
//-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 35;
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if ( cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
//    cell.detailTextLabel.textColor = [UIColor blackColor];
//    
//    NSString *titleStr;
//    NSString *detailStr;
//    if (indexPath.section==0)
//    {
//        if (indexPath.row==0)
//        {
//            
//            titleStr = @"商户名称";
//            detailStr = self.detailModel.merchant_name;
//        }
//        else if(indexPath.row==1)
//        {
//            titleStr = @"商户编号";
//            detailStr = self.detailModel.merchant_id;
//            cell.detailTextLabel.textColor = [UIColor blueColor];
//        }
//        else if(indexPath.row==2)
//        {
//            titleStr = @"终端编号";
//            detailStr = self.detailModel.terminal_id;
//            cell.detailTextLabel.textColor = [UIColor blueColor];
//        }
//    }
//    else if(indexPath.section==1)
//    {
//        if (indexPath.row==0)
//        {
//            
//            titleStr = @"卡号";
//            detailStr = self.detailModel.account1;
//        }
//        else if(indexPath.row==1)
//        {
//            titleStr = @"交易日期";
//            detailStr = self.detailModel.localdate;
//        }
//        else if(indexPath.row==2)
//        {
//            titleStr = @"交易类型";
//            detailStr = self.detailModel.note;
//        }
//        else if(indexPath.row==3)
//        {
//            titleStr = @"交易流水号";
//            detailStr = self.detailModel.snd_log;
//        }
//        else if(indexPath.row==4)
//        {
//            titleStr = @"参考号";
//            detailStr = self.detailModel.local_log;
//        }
//        else if(indexPath.row==5)
//        {
//            titleStr = @"批次号";
//            detailStr = self.detailModel.snd_cycle;
//        }
//        else if(indexPath.row==6)
//        {
//            titleStr = @"交易金额";
//            detailStr = [NSString stringWithFormat:@"￥%@",self.detailModel.amount];
//        }
//        else if(indexPath.row==7)
//        {
//            titleStr = @"交易状态";
//            detailStr = self.detailModel.rspmsg;
//        }
//        else if(indexPath.row==8)
//        {
//            titleStr = @"交易备注";
//            detailStr = self.detailModel.terminal_id;
//        }
//        
//    }
//    else if (indexPath.section==2)
//    {
//        titleStr = @"签名";
//        detailStr = self.detailModel.terminal_id;
//    }
//    cell.textLabel.text = titleStr;
//    cell.detailTextLabel.text = detailStr;
//    
//    
//    return cell;
//    
//}

@end

//
//  TradeDetailTableViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "TradeDetailTableViewController.h"

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
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, VIEWHEIGHT+41) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView setBackgroundColor:[UIColor clearColor]];
    self.myTableView.backgroundView  = nil;
    [self.view addSubview:self.myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    else if(section ==1)
    {
        return 9;
        
    }
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    NSString *titleStr;
    NSString *detailStr;
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            
            titleStr = @"商户名称";
            detailStr = self.detailModel.merchant_name;
        }
        else if(indexPath.row==1)
        {
            titleStr = @"商户编号";
            detailStr = self.detailModel.merchant_id;
            cell.detailTextLabel.textColor = [UIColor blueColor];
        }
        else if(indexPath.row==2)
        {
            titleStr = @"终端编号";
            detailStr = self.detailModel.terminal_id;
            cell.detailTextLabel.textColor = [UIColor blueColor];
        }
    }
    else if(indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            
            titleStr = @"卡号";
            detailStr = self.detailModel.account1;
        }
        else if(indexPath.row==1)
        {
            titleStr = @"交易日期";
            detailStr = self.detailModel.localdate;
        }
        else if(indexPath.row==2)
        {
            titleStr = @"交易类型";
            detailStr = self.detailModel.note;
        }
        else if(indexPath.row==3)
        {
            titleStr = @"交易流水号";
            detailStr = self.detailModel.snd_log;
        }
        else if(indexPath.row==4)
        {
            titleStr = @"参考号";
            detailStr = self.detailModel.local_log;
        }
        else if(indexPath.row==5)
        {
            titleStr = @"批次号";
            detailStr = self.detailModel.snd_cycle;
        }
        else if(indexPath.row==6)
        {
            titleStr = @"交易金额";
            detailStr = [NSString stringWithFormat:@"￥%@",self.detailModel.amount];
        }
        else if(indexPath.row==7)
        {
            titleStr = @"交易状态";
            detailStr = self.detailModel.rspmsg;
        }
        else if(indexPath.row==8)
        {
            titleStr = @"交易备注";
            detailStr = self.detailModel.terminal_id;
        }
        
    }
    else if (indexPath.section==2)
    {
        titleStr = @"签名";
        detailStr = self.detailModel.terminal_id;
    }
    cell.textLabel.text = titleStr;
    cell.detailTextLabel.text = detailStr;
    
    
    return cell;
    
}

@end

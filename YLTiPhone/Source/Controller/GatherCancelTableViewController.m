//
//  GatherCancelTableViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "GatherCancelTableViewController.h"
#import "GatherCancelCell.h"
#import "ConfirmCancelViewController.h"
#import "StringUtil.h"
#import "DateUtil.h"
#import "TransferSuccessDBHelper.h"

#define HEIGHTFORROW 100

@interface GatherCancelTableViewController ()

@end

@implementation GatherCancelTableViewController

@synthesize myTableView = _myTableView;
@synthesize array = _array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"撤销列表";
    self.hasTopView = true;
    
    //[ApplicationDelegate showProcess:@"正在查询数据"];
    
    TransferSuccessDBHelper *helper = [[TransferSuccessDBHelper alloc] init];
    self.array = [helper queryAllTransfer];
    [ApplicationDelegate hideProcess];
    
    if (self.array && [self.array count] > 0)
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, VIEWHEIGHT) style:UITableViewStylePlain];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        [self.myTableView setBackgroundColor:[UIColor clearColor]];
        self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:self.myTableView];
        

    }
    else
    {
        UIImageView *emptyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyImage.png"]];
        [emptyView setFrame:CGRectMake(97, 180, 126, 80)];
        [self.view addSubview:emptyView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 功能函数
- (void)gotoNextControl
{
    ConfirmCancelViewController *vc = [[ConfirmCancelViewController alloc] initWithModel:[self.array objectAtIndex:selectRow]];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHTFORROW;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GatherCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil)
    {
        cell = [[GatherCancelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   SuccessTransferModel *model = (SuccessTransferModel *)[self.array objectAtIndex:indexPath.row];
    if (model.Flag == 0)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 20, 80, 45)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"revoked"];
        [cell.contentView addSubview:imageView];
    }
    cell.accountLabel.text = model.content[@"apires"][@"CARD"];
    cell.timeLabel.text =model.content[@"apires"][@"XTDE"];
    
    cell.amountLabel.text =[NSString stringWithFormat:@"￥%@", model.content[@"apires"][@"JE"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SuccessTransferModel *model = (SuccessTransferModel *)[self.array objectAtIndex:indexPath.row];
    if (model.Flag == 0)
    {
        return;
    }

    selectRow = indexPath.row;
    if (ApplicationDelegate.deviceType == CDeviceTypeShuaKaTou)
    {
        [[Transfer sharedTransfer] startTransfer:nil fskCmd:@"Request_GetKsn#Request_Pay" paramDic:nil];
    }
    else if(ApplicationDelegate.deviceType == CDeviceTypeIbanShuaKaTou)
    {
        [[Transfer sharedTransfer] startTransfer:nil fskCmd:@"startSwiper" paramDic:nil];
    }
    else if(ApplicationDelegate.deviceType == CDeviceTypeDianFuBao||
            ApplicationDelegate.deviceType == CDeviceTypeYinPinPOS)
    {
        [[Transfer sharedTransfer] startTransfer:nil fskCmd:[NSString stringWithFormat:@"Request_GetExtKsn#Request_VT#Request_GetTrackPlaintext#Request_GetPin|string:%@",[StringUtil amount2String:@""]] paramDic:nil];

    }
}

@end

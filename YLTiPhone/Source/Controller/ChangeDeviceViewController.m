//
//  ChangeDeviceViewController.m
//  YLTiPhone
//
//  Created by 文彬 on 14-9-3.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "ChangeDeviceViewController.h"

@interface ChangeDeviceViewController ()

@end

@implementation ChangeDeviceViewController

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
    self.navigationItem.title = @"更换设备";
    self.hasTopView = YES;
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    images = @[@"0",@"3",@"4"];
    titles = @[@"点付宝",@"刷卡键盘",@"音频POS"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //防止更换设备失败后 设备类型没有重置
    NSString *posType = [UserDefaults objectForKey:kUserPosType];
    if (posType!=nil)
    {
        ApplicationDelegate.deviceType = [posType intValue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_device_%@",images[indexPath.row]]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"      %@",titles[indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0) //点付宝
    {
        ApplicationDelegate.deviceType = CDeviceTypeShuaKaTou;
        [[Transfer sharedTransfer] startTransfer:@"100005" fskCmd:@"Request_GetKsn" paramDic:nil];
    }
    else if(indexPath.row==1) //刷卡键盘、
    {
        ApplicationDelegate.deviceType = CDeviceTypeDianFuBao;
        [[Transfer sharedTransfer] startTransfer:@"100005" fskCmd:@"Request_GetExtKsn" paramDic:nil];
    }
    else if(indexPath.row==2) //音频pos
    {
        ApplicationDelegate.deviceType = CDeviceTypeYinPinPOS;
        [[Transfer sharedTransfer] startTransfer:@"100005" fskCmd:@"Request_GetExtKsn" paramDic:nil];
    }
    NSLog(@"post type:%d",ApplicationDelegate.deviceType);
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

@end

//
//  SearchBankViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "SearchBankViewController.h"
#import "BankModel.h"
#import "UITextField+HideKeyBoard.h"
#import "AddAccountInfoViewController.h"

@interface SearchBankViewController ()

@end

@implementation SearchBankViewController

@synthesize bankDic = _bankDic;
@synthesize receiveDic = _receiveDic;
@synthesize searchTF;
@synthesize addAccountVC, modifyAccountVC;
@synthesize items = _items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              bankDic:(NSMutableDictionary *)bankDic
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _receiveDic = [[NSMutableDictionary alloc] initWithDictionary:bankDic];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"选择支行";
    self.hasTopView = YES;
    
    _bankDic = [[NSMutableDictionary alloc] init];
    _items = [[NSMutableArray alloc] init];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 140+ ios7_h, 300, VIEWHEIGHT-110) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView setBackgroundColor:[UIColor clearColor]];
    self.myTableView.backgroundView = nil;
    [self.view addSubview:self.myTableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    footView.backgroundColor = [UIColor clearColor];
    
    //加载更多按钮
    moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setFrame:CGRectMake(10, 0, 270, 35)];
    moreButton.layer.cornerRadius = 5.0f;
    moreButton.layer.borderColor = [UIColor grayColor].CGColor;
    moreButton.layer.borderWidth = 1.0f;
    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreButton setTitle:@"获取更多" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [moreButton setBackgroundColor:[UIColor clearColor]];
    [footView addSubview:moreButton];
    self.myTableView.tableFooterView = footView;
    
    UIImageView *textFieldImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 50+ios7_h, 200, 35)];
    [textFieldImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [self.view addSubview:textFieldImage1];
    
    //搜索
    self.searchTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 100+ios7_h, 200, 35) isLong:true];
    [self.searchTF.contentTF setPlaceholder:@"输入关键字"];
    self.searchTF.contentTF.delegate = self;
    [self.searchTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    [self.searchTF.contentTF setKeyboardType:UIKeyboardTypeDefault];
//    [self.searchTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    [self.view addSubview:self.searchTF];
    
   
    
    UIButton *selectBankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBankButton setFrame:CGRectMake(230, 100+ios7_h, 80, 35)];
    [selectBankButton setTitle:@"搜索" forState:UIControlStateNormal];
    [selectBankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectBankButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [selectBankButton addTarget:self action:@selector(selectBankButton) forControlEvents:UIControlEventTouchUpInside];
    [selectBankButton setBackgroundImage:[UIImage imageNamed:@"selectBank_normal.png"] forState:UIControlStateNormal];
    [selectBankButton setBackgroundImage:[UIImage imageNamed:@"selectBank_highlight.png"] forState:UIControlStateSelected];
    [selectBankButton setBackgroundImage:[UIImage imageNamed:@"selectBank_highlight.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:selectBankButton];

    
    //说是从第一页开始
    pageCurrent = 1;
    [self requestAction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestAction
{
    //查看支行信息
    [[Transfer sharedTransfer] startTransfer:@"089011" fskCmd:nil paramDic:self.receiveDic];
}

//界面上搜索按钮
- (void)selectBankButton
{
    [self.searchTF.contentTF  resignFirstResponder];
    if ([self.searchTF.contentTF.text isEqualToString:@""]||
        self.searchTF.contentTF.text==nil) {
        [ApplicationDelegate showErrorPrompt:@"请输入关键字"];
    }else{
        //搜索支行信息
        [self.receiveDic setObject:self.searchTF.contentTF.text forKey:@"bankbranchname"];
        [[Transfer sharedTransfer] startTransfer:@"089012" fskCmd:nil paramDic:self.receiveDic];
        [self.items removeAllObjects];
        isSearch  = YES;
       self.myTableView.tableFooterView.hidden = NO;
    }
}

-(void)refreshTabelView
{
//    if ([[self.bankDic objectForKey:@"object"] count] == 0) {
//        [self.myTableView setHidden:YES];
//        UIImageView *emptyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyImage.png"]];
//        [emptyView setFrame:CGRectMake(97, 180, 126, 80)];
//        [self.view addSubview:emptyView];
//    }else {
//        if (self.myTableView == nil) {
//            
//        }
//    }
   
    
    [self.items addObjectsFromArray:[self.bankDic objectForKey:@"object"]];
    [self.myTableView reloadData];
    if (self.items.count<kOnePageSize) //数据只有一页
    {
        self.myTableView.tableFooterView.hidden = YES;
    }
    if (((NSArray*)[self.bankDic objectForKey:@"object"]).count == 0)
    {
        self.myTableView.tableFooterView.hidden = YES;
        [ApplicationDelegate showErrorPrompt:@"无更多信息"];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BankModel *bank = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = bank.name;
    
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    headerView.backgroundColor = [UIColor clearColor];
//    
//    UIImageView *textFieldImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 200, 45)];
//    [textFieldImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
//    [headerView addSubview:textFieldImage1];
//    
//    [headerView addSubview:self.searchTF];
//    
//    UIButton *selectBankButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [selectBankButton setFrame:CGRectMake(220, 10, 80, 45)];
//    [selectBankButton setTitle:@"搜索" forState:UIControlStateNormal];
//    [selectBankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    selectBankButton.titleLabel.font = [UIFont systemFontOfSize:18];
//    [selectBankButton addTarget:self action:@selector(selectBankButton) forControlEvents:UIControlEventTouchUpInside];
//    [selectBankButton setBackgroundImage:[UIImage imageNamed:@"selectBank_normal.png"] forState:UIControlStateNormal];
//    [selectBankButton setBackgroundImage:[UIImage imageNamed:@"selectBank_highlight.png"] forState:UIControlStateSelected];
//    [selectBankButton setBackgroundImage:[UIImage imageNamed:@"selectBank_highlight.png"] forState:UIControlStateHighlighted];
//    [headerView addSubview:selectBankButton];
//    
//    return headerView;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 44;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    footerView.backgroundColor = [UIColor clearColor];
//    
//    moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [moreButton setFrame:CGRectMake(10, 0, 270, 44)];
//    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [moreButton setTitle:@"获取更多" forState:UIControlStateNormal];
//    [moreButton addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:moreButton];
//    
//    return footerView;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //选择一个支行 结果传回上个界面
    BankModel *bank = [_items objectAtIndex:indexPath.row];
    addAccountVC.respBankName = bank.name;
    addAccountVC.respBankCode = bank.code;

    modifyAccountVC.respBankName = bank.name;
    modifyAccountVC.respBankCode = bank.code;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)refresh {
    [self performSelector:@selector(addItem) withObject:nil afterDelay:2.0];
}

- (void)addItem {
    pageCurrent++;
    //加载下一页内容
    if (!isSearch) {
        //查看支行信息 未输入关键字
        [self.receiveDic setObject:[NSString stringWithFormat:@"%d",pageCurrent] forKey:@"page_current"];
        [[Transfer sharedTransfer] startTransfer:@"089011" fskCmd:nil paramDic:self.receiveDic];
    }else{
        //搜索支行信息
        [self.receiveDic setObject:self.searchTF.contentTF.text forKey:@"bankbranchname"];
        [self.receiveDic setObject:[NSString stringWithFormat:@"%d",pageCurrent] forKey:@"page_current"];
        [[Transfer sharedTransfer] startTransfer:@"089012" fskCmd:nil paramDic:self.receiveDic];
    }
    //没有更多内容了
    if ([[self.bankDic objectForKey:@"object"] count] == 0) {
        [moreButton setTitle:@"没有更多数据" forState:UIControlStateNormal];
    }
    [self.myTableView reloadData];
}
@end

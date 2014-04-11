//
//  CatalogViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "CatalogViewController.h"
#import "ParseXMLUtil.h"
#import "CatalogModel.h"
#import "Transfer.h"
#import "Transfer+Action.h"
#import "TimedoutUtil.h"
#import "UpdateAppHelper.h"
#import "JSONKit.h"


#import "ComplementRegisterInfoViewController.h"
#import "ModifyLoginPwdViewController.h"
#import "ModifyPaymentPwdViewController.h"
#import "FindoutPaymentPwdViewController.h"
#import "RealnameLegalizeViewController.h"
#import "QueryBalanceViewController.h"
#import "TransListViewController.h"
#import "AnnouncementListViewController.h"
#import "InputMoneyViewController.h"
#import "GatherCancelTableViewController.h"
#import "AboutSystemViewController.h"
#import "AccountCollectCashViewController.h"
#import "SignInViewController.h"
#import "QueryBalancePwdViewController.h"
#import "BeginGuideViewController.h"
#import "AppDataCenter.h"
#import "MerchantQueryBalanceViewController.h"
#import "ShowContentViewController.h"
#define kSCNavBarImageTag 10

@interface CatalogViewController ()
- (void)initCommonData;
- (void)doAction:(CatalogModel *)catalog;

@end

@implementation CatalogViewController

@synthesize leftScrollView          = _leftScrollView;
@synthesize rightTableView          = _rightTableView;
@synthesize catalogArray            = _catalogArray;
@synthesize currentCatalogArray     = _currentCatalogArray;
@synthesize url = _url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _catalogId = 1;
        _currentCatalogArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self.navigationItem setHidesBackButton:YES];
    
    
    self.hasTopView = false;
    
    self.navigationItem.hidesBackButton = YES;
    //iphone5适配更改背景图大小　统一使用大背景 by xs
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shade-5.png"]];
    
    self.catalogArray = [ParseXMLUtil parseCatalogXML];
    
    flag = 0;
    
    //右边显示具体二级菜单界面
    //IOS7把group方式的cell全部拉长，没有了左右10PX的空白 所以需要调整一下
    if (DeviceVersion >= 7)
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 15, 220, 480) style:UITableViewStyleGrouped];
        _leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 80, VIEWHEIGHT +41 +64)];
    }
    else
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 0, 240, 480) style:UITableViewStyleGrouped];
        _leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 80, VIEWHEIGHT +41 +64)];
    }
    
    self.rightTableView.backgroundColor = [UIColor clearColor];
//    self.rightTableView.backgroundView = nil;
    self.rightTableView.opaque = NO;
    self.rightTableView.delegate        = self;
    self.rightTableView.dataSource      = self;
    [self.rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.rightTableView];
    
    //左边可滑动竖向排列九空格
    self.leftScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"catalog_left_bg.png"]];
    [self.leftScrollView setContentSize:CGSizeMake(80, 300)];
    self.leftScrollView.delegate = self;
    [self.view addSubview:self.leftScrollView];
    
    
    [self initCommonData];
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.rightTableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];

}


-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
//    UIImage *navbackground = [UIImage imageNamed:@"navbar.png"];  //获取图片
//    UIImage *hfbbackground = [UIImage imageNamed:@"catalog_nav.png"];
//    CGSize finalSize = [navbackground size];
//    CGSize hfbSize = [hfbbackground size];
//    UIGraphicsBeginImageContext(finalSize);
//    [navbackground drawInRect:CGRectMake(0,0,finalSize.width,finalSize.height)];
//    [hfbbackground drawInRect:CGRectMake(60,0,hfbSize.width,hfbSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //if iOS 5.0 and later
        
        [navBar setBackgroundImage:[UIImage imageNamed:@"catalog_nav.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"catalog_nav.png"]];
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }
    }
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [ApplicationDelegate hideProcess];
}

- (void)backButtonAction
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.catalogArray = nil;
    self.leftScrollView = nil;
    self.rightTableView = nil;
    self.currentCatalogArray = nil;
}

#pragma mark -
#pragma mark local functions

- (void)initCommonData
{
    [self.leftScrollView setContentSize:CGSizeMake(80, 640)];
    self.leftScrollView.showsHorizontalScrollIndicator = NO;
    self.leftScrollView.showsVerticalScrollIndicator = NO;
    
    //左边的button放在scrollView上
    
    UIButton *btn;
    slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slidebg.png"]];
    for (int i = 0; i < [self.catalogArray count]; i++) {
        CatalogModel *catalog = [self.catalogArray objectAtIndex:i];
        if (catalog.parentId != 0)
            return;
        
        CGRect frame;
        btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        btn.tag = catalog.catalogId;
        frame.size.width = 44;//设置按钮坐标及大小
        frame.size.height = 44;
        frame.origin.x  = 18;
        frame.origin.y  = i*90 + 14;
        [btn setFrame:frame];
        [btn setBackgroundColor:[UIColor clearColor]];
        if (i+1 == _catalogId) {
            slideBg.frame = CGRectMake(7, btn.frame.origin.y - 5, 64, 74);
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png",catalog.iconId]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftScrollView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.frame = CGRectMake(14, btn.frame.origin.y + 45, 60, 25);
        label.text = catalog.title;
        label.textColor=[UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.backgroundColor = [UIColor clearColor];
        [self.leftScrollView addSubview:label];
        
        [self.leftScrollView addSubview:slideBg];
    }
}

//响应按钮事件
- (void)selectedTab:(UIButton *)button
{
    flag = button.tag;
	[self performSelector:@selector(slideTabBg:) withObject:button];
    _catalogId = button.tag;
    [self.rightTableView reloadData];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.rightTableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

//切换滑块位置
- (void)slideTabBg:(UIButton *)btn {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	[UIView setAnimationDelegate:self];
    slideBg.frame = CGRectMake(8, btn.frame.origin.y-5, 64, 74);
	[UIView commitAnimations];
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.duration = 0.50;
	animation.delegate = self;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeForwards;
	NSMutableArray *values = [NSMutableArray array];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	animation.values = values;
	[btn.layer addAnimation:animation forKey:nil];
}

#pragma mark -
#pragma tableView methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self.currentCatalogArray removeAllObjects];
    
    for (CatalogModel *model in self.catalogArray) {
        if (model.parentId == _catalogId) {
            [self.currentCatalogArray addObject:model];
        }
    }
    return [self.currentCatalogArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    
    CatalogModel *catalog = ((CatalogModel *)[self.currentCatalogArray objectAtIndex:indexPath.section]);
    
    cell.textLabel.text = catalog.title;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (catalog.active) {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        // cell.userInteractionEnabled = YES;
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        // cell.userInteractionEnabled = NO;
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *selectBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 229, 45)];
    [selectBgView setImage:[UIImage imageNamed:@"child_catalog_select.png"]];
    [selectBgView sizeToFit];
    
    cell.selectedBackgroundView = selectBgView;
    
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 229, 45)];
    UIImage *bgImage = [UIImage imageNamed:@"catalogwhite"];
    [bgView setImage:bgImage];
    [bgView sizeToFit];
    
    cell.backgroundView = bgView;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(180, 9, 25, 25)];
    [image setImage:[UIImage imageNamed:@"suffix_normal.png"]];
    [image setHighlightedImage:[UIImage imageNamed:@"suffix_selected.png"]];
    [cell.contentView addSubview:image];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogModel *catalogModel = (CatalogModel *)[self.currentCatalogArray objectAtIndex:indexPath.section];
    
    [self doAction:catalogModel];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - * 右边tableView事件

- (void)doAction:(CatalogModel *)catalog
{
    
    // 首先判断该交易是否已经开通
    if (!catalog.active) {
        [ApplicationDelegate showText:[NSString stringWithFormat:@"%@ 尚未开通，敬请期待", catalog]];
        return;
    }
    
    // 判断是否需要检查冲正
    if (catalog.needReverse) {
        if ([[Transfer sharedTransfer] reversalAction])
            return;
    }
    
    switch (catalog.catalogId) {
            
        case 11://公告查询
        {
            AnnouncementListViewController *announcementVC = [[AnnouncementListViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:announcementVC animated:YES];
            break;
        }
            
        case 12://完善注册信息
        {
            ComplementRegisterInfoViewController *signInVC = [[ComplementRegisterInfoViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:signInVC animated:YES];
            break;
        }
            
        case 13://实名认证
        {
            RealnameLegalizeViewController *settleAccountsVC = [[RealnameLegalizeViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:settleAccountsVC animated:YES];
            break;
        }
        
        case 14://签到
        {
//            if (![[AppDataCenter sharedAppDataCenter].status isEqualToString:@"9"]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"等待终审！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//                return;
//            }
            SignInViewController *signInVC = [[SignInViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:signInVC animated:YES];
            break;
        }
            
//        case 15://用户引导
//        {
//            BeginGuideViewController *beginGuideViewController = [[BeginGuideViewController alloc] initWithNibName:nil bundle:nil];
//            
//            [self.navigationController pushViewController:beginGuideViewController animated:YES];
//            break;
//        }
        
          
        case 21://收款 先输入金额
        {
//            if (![[AppDataCenter sharedAppDataCenter].status isEqualToString:@"9"]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"等待终审！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//                return;
//            }else if(![AppDataCenter sharedAppDataCenter].hasSign){
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"用户尚未签到，请先签到！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alertView.tag = 300;
//                [alertView show];
//                return;
//            }
            InputMoneyViewController *inputMoneyVC = [[InputMoneyViewController alloc] initWithNibName:@"InputMoneyViewController" bundle:nil];
            [self.navigationController pushViewController:inputMoneyVC animated:YES];
            break;
        }
            
        case 22://收款撤销
        {
//            if (![[AppDataCenter sharedAppDataCenter].status isEqualToString:@"9"]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"等待终审！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//                return;
//            }else if(![AppDataCenter sharedAppDataCenter].hasSign){
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"用户尚未签到，请先签到！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alertView.tag = 300;
//                [alertView show];
//                return;
//            }
            GatherCancelTableViewController *gatherCancelVC = [[GatherCancelTableViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:gatherCancelVC animated:YES];
            break;
        }

        case 31://商户提款
        {
//            if (![[AppDataCenter sharedAppDataCenter].status isEqualToString:@"9"]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"等待终审！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//                return;
//            }else if(![AppDataCenter sharedAppDataCenter].hasSign){
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"用户尚未签到，请先签到！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alertView.tag = 300;
//                [alertView show];
//                return;
//            }
            AccountCollectCashViewController *collectCashVC = [[AccountCollectCashViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:collectCashVC animated:YES];
            break;
        }
            
        case 32://商户余额查询
        {
//            if (![[AppDataCenter sharedAppDataCenter].status isEqualToString:@"9"]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"等待终审！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//                return;
//            }else if(![AppDataCenter sharedAppDataCenter].hasSign){
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"用户尚未签到，请先签到！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alertView.tag = 300;
//                [alertView show];
//                return;
//            }
            MerchantQueryBalanceViewController *vc = [[MerchantQueryBalanceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 41://查询银行卡余额
        {
//            if (![[AppDataCenter sharedAppDataCenter].status isEqualToString:@"9"]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"等待终审！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//                return;
//            }else if(![AppDataCenter sharedAppDataCenter].hasSign){
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"用户尚未签到，请先签到！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alertView.tag = 300;
//                [alertView show];
//                return;
//            }
            QueryBalanceViewController *queryBalanceVC = [[QueryBalanceViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:queryBalanceVC animated:YES];
            break;
        }
            
        case 42://交易查询
        {
            TransListViewController *vc = [[TransListViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    
        case 51://收款人管理
        {
            break;
        }
        case 52://银行账户付款
        {
            break;
        }
            
        case 61://修改登录密码
        {
            ModifyLoginPwdViewController *settleAccountsVC = [[ModifyLoginPwdViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:settleAccountsVC animated:YES];
            break;
        }
            
        case 62://修改支付密码
        {
            ModifyPaymentPwdViewController *signOutVC = [[ModifyPaymentPwdViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:signOutVC animated:YES];
            break;
        }
            
        case 63://找回支付密码
        {
            FindoutPaymentPwdViewController *modifiMerchantVC = [[FindoutPaymentPwdViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:modifiMerchantVC animated:YES];
            break;
        }
        case 64://关于系统
        {
            AboutSystemViewController *aboutSystemVC = [[AboutSystemViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:aboutSystemVC animated:YES];
            break;
        }
        case 65://软件更新
        {
            [self checkUpdate];
            break;
        }
        case 66://版本号
        {
            
            break;
        }
//        case 62://退出登录
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil, nil];
//            [alert setTag:100];
//            [alert show];
//            
//            break;
//        }
        default:
            break;
    }
    
}


-(void)checkUpdate
{
    
    [[Transfer sharedTransfer] startTransfer:@"089018" fskCmd:nil paramDic:nil];
    
}

-(void)showAlertViewUpdate:(NSDictionary *) dic {
    NSDictionary *dic_version = [[dic objectForKey:@"apires"] objectFromJSONString];
    self.url = [dic_version objectForKey:@"url"];
    NSString *version = [dic_version objectForKey:@"version"];
    int version_d = [version intValue];
    if(version_d > version_num){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"有新版本，是否下载更新？！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
        alertView.tag = 400;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已经是最新版本！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];

    }
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [[TimedoutUtil sharedInstance].timer invalidate];
            ApplicationDelegate.hasLogin = NO;
            [ApplicationDelegate.rootNavigationController popToRootViewControllerAnimated:YES];
        }
    } else if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaults stringForKey:@"trackViewUrl"]]];
        }
    } else if (alertView.tag == 300) {
        if (buttonIndex == 1) {
            NSDictionary *dict = @{@"username":[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"]};
            [[Transfer sharedTransfer] startTransfer:@"086000" fskCmd:@"Request_GetKsn" paramDic:dict];
        }
    } else if (alertView.tag == 400) {
        if (buttonIndex == 1) {
            
            ShowContentViewController *vc = [[ShowContentViewController alloc] initWithUrl:self.url];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end

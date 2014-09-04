//
//  BeginGuideViewController.m
//  YLTiPhone
//
//  Created by 霍庚浩 on 14-4-2.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "BeginGuideViewController.h"
#import "CatalogViewController.h"
#import "UIDevice+Resolutions.h"




@interface BeginGuideViewController ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    float viewwide;
    float viewheight;
    int jcount;
}

@end

@implementation BeginGuideViewController

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
    //NSLog(@"%d",[UIDevice currentResolution]);
   //判断用户的机型，从而确定view的大小
    switch ([UIDevice currentResolution]) {

        case UIDevice_iPhoneHiRes:
            viewheight = 960/2-20;
            viewwide = 640/2;
            break;
        case UIDevice_iPhoneStandardRes:
            viewheight = 480-20;
            viewwide = 320;
        case UIDevice_iPhoneTallerHiRes:
            viewheight = 1136/2-20;
            viewwide = 640/2;
        default:
            break;
    }
    
    if (APPTYPE==CAppTypeYLT)
    {
        jcount = 5;
    }
    else if(APPTYPE == CAppTypeWYZF)
    {
        jcount = 5;
    }
    
    self.navigationController.navigationBarHidden = YES;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        //因为ios7.0的特殊性，需要一些配置
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewwide, viewheight+20)];
        _scrollView = scrollView;
    }
    else
    {
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewwide, viewheight)];
        _scrollView = scrollView;
    }
    
    for (int i = 0; i<jcount; i++) {
        //加载图片
        UIImage *ima = [UIImage imageNamed:[NSString stringWithFormat:@"beginguide0%d.png",i+1]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:ima];
        imageView.frame = CGRectMake(i*viewwide, 0, viewwide, viewheight);
    
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(viewwide*jcount, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    //加载进入主界面的按钮
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(105+(viewwide*(jcount-1)), viewheight-90, 120, 35);
    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"LoginButton_normal.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"LoginButton_highlight.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(enterLoginView:) forControlEvents:UIControlEventTouchDown];
    [_scrollView addSubview:btn];
    
    // 设置非选中页的圆点颜色
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    _pageControl = pageControl;
    _pageControl.center = CGPointMake(viewwide * 0.5, viewheight-15);
    _pageControl.bounds = CGRectMake(0, 0, 150, 50);
    _pageControl.numberOfPages = jcount; // 一共显示多少个圆点（多少页）
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    // 设置选中页的圆点颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControl];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView的代理方法
#pragma mark 当scrollView正在滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    NSLog(@"%d", page);
    
    // 设置页码
    _pageControl.currentPage = page;
    
}

//按钮行为，跳转入登录界面
- (void)enterLoginView:(UIButton *)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationController.navigationBarHidden = NO;
//    CatalogViewController *controller = [[CatalogViewController alloc] initWithNibName:nil bundle:nil];
    [ApplicationDelegate.rootNavigationController pushViewController:loginViewController animated:YES];
    
    //优乐通有提示页  在此处将提示页从导航栈里移除  否则其他地方的逻辑得修改
    if (APPTYPE ==CAppTypeYLT||APPTYPE==CAppTypeWYZF)
    {
        NSMutableArray *temArr = [NSMutableArray arrayWithArray:ApplicationDelegate.rootNavigationController.viewControllers];
        [temArr removeObjectAtIndex:0];
        ApplicationDelegate.rootNavigationController.viewControllers = temArr;
    }
   
    
}
@end

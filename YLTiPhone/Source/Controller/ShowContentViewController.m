//
//  ShowFileContentViewController.m
//  LKOA4iPhone
//
//  Created by  STH on 7/31/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "ShowContentViewController.h"

@interface ShowContentViewController ()

@end

@implementation ShowContentViewController

@synthesize webView = _webView;
@synthesize progressInd = _progressInd;
@synthesize fileName = _fileName;
@synthesize link = _link;
@synthesize htmlStr = _htmlStr;

-(id) initWithFileName:(NSString *) fileName
{
    if (self = [super init]) {
        _fileName = fileName;
        _link = nil;
        _htmlStr = nil;
    }
    
    return self;
}

-(id) initWithUrl:(NSString *) url
{
    if (self = [super init]) {
        _link = url;
        _fileName = nil;
        _htmlStr = nil;
    }
    
    return self;
}

-(id) initWithHtmlString:(NSString *) htmlStr
{
    if (self = [super init]) {
        _htmlStr = htmlStr;
        _link = nil;
        _fileName = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"big_bg"]]];
    self.navigationItem.title = @"版本更新路径";

    float height = 416.0f;
    if (iPhone5) {
        height = 504.0f;
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, height - 63)];
    [self.webView setUserInteractionEnabled:YES];
    // YES, 初始太小，但是可以放大；NO，初始可以，但是不再支持手势。 FUCK！！！
    self.webView.scalesPageToFit = YES; // 设置网页和屏幕一样大小，使支持缩放操作
    [self.webView setDelegate:self];
    
    
    // 这是一种取巧的方案，先设置成scalesPageToFit ＝ NO，两秒后再设置成scalesPageToFit ＝ YES。但是实际效果是PDF可以实现预计的效果，其他的不行。
    // [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setScalesPageToFit) userInfo:nil repeats:NO];
    
    if (self.link) {
        [self showWithUrl:self.link];
    } else if (self.fileName) {
        [self showWithFileName:self.fileName];
    } else if (self.htmlStr) {
        [self showWithHtmlString:self.htmlStr];
    }
}

- (void) setScalesPageToFit
{
    [self.webView setScalesPageToFit:YES];
}

-(void) showWithFileName:(NSString *) fileName
{
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        self.navigationItem.title = fileName;
    }
    
    // Bundle
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:nil];
    
    // Document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}

-(void) showWithUrl:(NSString *) url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

-(void) showWithHtmlString:(NSString *) html
{
    [self.webView loadHTMLString:html baseURL:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '500%'"];//通过 javaScript的语言进行大小的控制
    [self.view addSubview:self.webView];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    // 测试发现，当为EXCEL文件时（即扩展名为xls或xlsx),则一直在屏幕上显示加载不消失，故采用如下特殊处理之。
    if (self.fileName && [[self.fileName pathExtension] rangeOfString:@"xls"].location != NSNotFound) {
        return ;
    }
    
    [self showWaiting];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    /***
     
     // http://blog.csdn.net/kmyhy/article/details/7198920
     // http://www.icab.de/blog/2010/12/27/changing-the-range-of-the-zoom-factor-for-uiwebview-objects/
     
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IncreaseZoomFactor" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCode];
    [self.webView stringByEvaluatingJavaScriptFromString:@"increaseMaxZoomFactor()"];
    ***/
    [self hideWaiting];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件打开失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//显示进度滚轮指示器
-(void)showWaiting {
    _progressInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
//    _progressInd.center=CGPointMake(self.view.center.x,240);
    _progressInd.center = self.view.center;
    [_progressInd setColor:[UIColor blackColor]];
    [self.view addSubview:_progressInd];
    [_progressInd startAnimating];
}

//消除滚动轮指示器
-(void)hideWaiting
{
    [_progressInd stopAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [self hideWaiting];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end

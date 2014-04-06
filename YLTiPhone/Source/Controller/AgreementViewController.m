//
//  AgreementViewController.m
//  YLTiPhone
//
//  Created by liao jia on 14-4-5.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController
@synthesize label_agreement = _label_agreement;

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

    self.navigationItem.title = @"服务协议";
    self.hasTopView = true;
    
    float height = 416.0f;
    if (iPhone5) {
        height = 568.0f;
    }
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20+ios7_h, 320, height +30)];
    [webView setBackgroundColor:[UIColor clearColor]];
    
    //使用loadHTMLString()方法显示网页内容
    [webView loadHTMLString:[self getHtmlString] baseURL:nil];
    
    [self.view addSubview:webView];
}

//读取html文件内容
- (NSString *)getHtmlString{
    
    //文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"html"];
    
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return contents;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

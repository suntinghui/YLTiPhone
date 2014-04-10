//
//  MerchantQueryBalanceResultViewController.m
//  YLTiPhone
//
//  Created by liao jia on 14-4-10.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "MerchantQueryBalanceResultViewController.h"
#import "StringUtil.h"
@interface MerchantQueryBalanceResultViewController ()

@end

@implementation MerchantQueryBalanceResultViewController

@synthesize dic_rece = _dic_rece;
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
    
    self.hasTopView = true;
    self.navigationItem.title = @"商户余额";
    NSString *resultImageName = @"success.png";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:resultImageName]];
    [imageView setFrame:CGRectMake(122, 80, 77, 75)];
    [self.view addSubview:imageView];
    
    NSString *field54 = [self.dic_rece objectForKey:@"field54"];
    NSString *had_balance = [[field54 substringWithRange:NSMakeRange(0, 20)] substringFromIndex:8];
    NSString *no_balance = [[field54 substringFromIndex:20] substringFromIndex:8];
    UILabel *label_one = [[UILabel alloc] initWithFrame:CGRectMake(40, 175, 85, 40)];
    [label_one setText:@"已到账余额"];
    [label_one setBackgroundColor:[UIColor clearColor]];
    [label_one setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:label_one];
    UILabel *label_had = [[UILabel alloc] initWithFrame:CGRectMake(130, 175, 150, 40)];
    
    [label_had setText:[StringUtil stringWithMoney:[NSNumber numberWithFloat:[had_balance floatValue]/100.0] locale:@"zh_CN"]];
    [label_had setTextAlignment:NSTextAlignmentRight];
    [label_had setBackgroundColor:[UIColor clearColor]];
    [label_had setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:label_had];
    
    UILabel *label_two = [[UILabel alloc] initWithFrame:CGRectMake(40, 210, 85, 40)];
    [label_two setText:@"未到账余额"];
    [label_two setBackgroundColor:[UIColor clearColor]];
    [label_two setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:label_two];
    UILabel *label_no = [[UILabel alloc] initWithFrame:CGRectMake(130, 210, 150, 40)];
    [label_no setText:[StringUtil stringWithMoney:[NSNumber numberWithFloat:[no_balance floatValue]/100.0] locale:@"zh_CN"]];
    [label_no setBackgroundColor:[UIColor clearColor]];
    [label_no setFont:[UIFont systemFontOfSize:15]];
    [label_no setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:label_no];
    
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 360, 297, 42)];
    [confirmButton setTitle:@"确  定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)confirmButtonAction:(id)sender
{
    [self popToCatalogViewController];
}
@end

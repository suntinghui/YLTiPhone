//
//  AboutSystemViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AboutSystemViewController.h"
#import "UIDevice+Resolutions.h"


@interface AboutSystemViewController ()

@end

@implementation AboutSystemViewController

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
    self.navigationItem.title = @"关于系统";
    self.hasTopView = true;
    
    UIImageView *aboutSystemBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutSystemBg.png"]];
    [aboutSystemBg setFrame:CGRectMake(0, 50, 320, 290)];
    [self.view addSubview:aboutSystemBg];
    
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 380+([UIDevice isRunningOniPhone5] ? 88:0), 100, 30)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    versionLabel.text = @"V1.0.0";
    [self.view addSubview:versionLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

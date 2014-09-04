//
//  AccCollectCashInputMoneyViewController.m
//  YLTiPhone
//
//  Created by xushuang on 14-1-21.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "AccCollectCashInputMoneyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UITextField+HideKeyBoard.h"
#import "StringUtil.h"
#import "AccCollectCashConfirmViewController.h"
#import "ParseXMLUtil.h"
#import "CityModel.h"

#define Action_Tag_SelectType  100

@interface AccCollectCashInputMoneyViewController ()

@end

@implementation AccCollectCashInputMoneyViewController

@synthesize receiveDic = _receiveDic;
@synthesize inputMoneyTF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  dic:(NSDictionary *)dic
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _receiveDic = [[NSDictionary alloc] initWithDictionary:dic];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"账户提现";
    self.hasTopView = YES;

    UIView *accountInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, 20+ios7_h, 300, 250)];
    accountInfoView.backgroundColor = [UIColor whiteColor];
    accountInfoView.layer.borderWidth = 1;
    accountInfoView.layer.cornerRadius = 5;
    accountInfoView.layer.borderColor = [UIColor grayColor].CGColor;
    

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 25)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"姓名";
    [accountInfoView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 100, 25)];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:15];
    label2.text = @"手机号";
    [accountInfoView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 150, 25)];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = [UIFont systemFontOfSize:15];
    label3.text = @"当日可提现余额";
    [accountInfoView addSubview:label3];
    
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(5, 95, 150, 25)];
    label8.backgroundColor = [UIColor clearColor];
    label8.font = [UIFont systemFontOfSize:15];
    label8.text = @"不可提现余额";
    [accountInfoView addSubview:label8];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(5, 125, 100, 25)];
    label4.backgroundColor = [UIColor clearColor];
    label4.font = [UIFont systemFontOfSize:15];
    label4.text = @"收款银行";
    [accountInfoView addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(5, 155, 150, 25)];
    label5.backgroundColor = [UIColor clearColor];
    label5.font = [UIFont systemFontOfSize:15];
    label5.text = @"开户行所在城市";
    [accountInfoView addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(5, 185, 100, 25)];
    label6.backgroundColor = [UIColor clearColor];
    label6.font = [UIFont systemFontOfSize:15];
    label6.text = @"银行账户";
    [accountInfoView addSubview:label6];
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(5, 215, 100, 25)];
    label7.backgroundColor = [UIColor clearColor];
    label7.font = [UIFont systemFontOfSize:15];
    label7.text = @"联行号";
    [accountInfoView addSubview:label7];
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 170, 25)];
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.font = [UIFont systemFontOfSize:15];
    namelabel.text = [self.receiveDic objectForKey:@"accountname"];
    [namelabel setTextAlignment:NSTextAlignmentRight];
    [accountInfoView addSubview:namelabel];
    
    UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, 170, 25)];
    phonelabel.backgroundColor = [UIColor clearColor];
    phonelabel.font = [UIFont systemFontOfSize:15];
    [phonelabel setTextAlignment:NSTextAlignmentRight];
    phonelabel.text = [self.receiveDic objectForKey:@"tel"];
    [accountInfoView addSubview:phonelabel];
    
    UILabel *balancelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 65, 170, 25)];
    balancelabel.backgroundColor = [UIColor clearColor];
    balancelabel.font = [UIFont systemFontOfSize:15];
    [balancelabel setTextAlignment:NSTextAlignmentRight];
    balancelabel.text = [StringUtil stringWithMoney:[self.receiveDic objectForKey:@"balance"] locale:@"zh_CN"];
    [accountInfoView addSubview:balancelabel];
    
    UILabel *unbalancelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 95, 170, 25)];
    unbalancelabel.backgroundColor = [UIColor clearColor];
    unbalancelabel.font = [UIFont systemFontOfSize:15];
    [unbalancelabel setTextAlignment:NSTextAlignmentRight];
    unbalancelabel.text = [StringUtil stringWithMoney:[self.receiveDic objectForKey:@"unbalance"] locale:@"zh_CN"];
    [accountInfoView addSubview:unbalancelabel];
    
    UILabel *banklabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 125, 170, 40)];
    banklabel.backgroundColor = [UIColor clearColor];
    banklabel.font = [UIFont systemFontOfSize:15];
    banklabel.numberOfLines = 0;
    [balancelabel setTextAlignment:NSTextAlignmentRight];
    banklabel.lineBreakMode = UILineBreakModeCharacterWrap;
    banklabel.text = [self.receiveDic objectForKey:@"banks"];
    [accountInfoView addSubview:banklabel];
    
    UILabel *citylabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 155, 170, 25)];
    citylabel.backgroundColor = [UIColor clearColor];
    citylabel.font = [UIFont systemFontOfSize:15];
    [citylabel setTextAlignment:NSTextAlignmentRight];
    [accountInfoView addSubview:citylabel];
    NSArray *cityArray = [[NSArray alloc] initWithArray:[ParseXMLUtil parseCityXML]];
    for (CityModel *model in cityArray)
    {
        if ([model.parentCode isEqualToString:self.receiveDic[@"area"]]&&
            [model.code isEqualToString:self.receiveDic[@"city"]])
        {
            citylabel.text = model.name;
            break;
        }
    }
    
    UILabel *acclabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 185, 170, 25)];
    acclabel.backgroundColor = [UIColor clearColor];
    acclabel.font = [UIFont systemFontOfSize:15];
    [acclabel setTextAlignment:NSTextAlignmentRight];
    acclabel.text = [self.receiveDic objectForKey:@"bankaccount"];
    [accountInfoView addSubview:acclabel];
    
    UILabel *ylNumlabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 215, 170, 25)];
    ylNumlabel.backgroundColor = [UIColor clearColor];
    ylNumlabel.font = [UIFont systemFontOfSize:15];
    [ylNumlabel setTextAlignment:NSTextAlignmentRight];
    ylNumlabel.text = [self.receiveDic objectForKey:@"bankno"];
    [accountInfoView addSubview:ylNumlabel];
    
    scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ios7_h+40, 320, self.view.frame.size.height)];
    [self.view addSubview:scrView];
    scrView.contentSize = CGSizeMake(320, 550);
    [scrView addSubview:accountInfoView];
    
    
    UIImageView *textFieldImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 285+ios7_h, 300, 45)];
    [textFieldImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [scrView addSubview:textFieldImage1];
    self.inputMoneyTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 285+ios7_h, 300, 45) isLong:true];
    [self.inputMoneyTF.contentTF setPlaceholder:@"请输入金额"];
    self.inputMoneyTF.contentTF.delegate = self;
    [self.inputMoneyTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self.inputMoneyTF.contentTF hideKeyBoard:scrView:2 hasNavBar:YES];
    [scrView addSubview:self.inputMoneyTF];
    

    UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeButton setFrame:CGRectMake(10, 345+ios7_h,300, 42)];
    [typeButton setTitle:@"普通提现（免手续费）" forState:UIControlStateNormal];
    [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    typeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    typeButton.tag = Action_Tag_SelectType;
    [typeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    [typeButton setBackgroundImage:[UIImage imageNamed:@"textInput"] forState:UIControlStateNormal];

    [scrView addSubview:typeButton];

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 400+ios7_h, 297, 42)];
    [confirmButton setTitle:@"确    定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [scrView addSubview:confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIButton *button = (UIButton*)[scrView viewWithTag:Action_Tag_SelectType];
    if (buttonIndex==0)
    {
        [button setTitle:@"普通提现（免手续费）" forState:UIControlStateNormal];
        type = 0;
    }
    else if(buttonIndex == 1)
    {
        [button setTitle:@"快速提现" forState:UIControlStateNormal];
        type = 1;
    }
}

#pragma mark - 功能函数
-(BOOL)checkValue
{
    if([self.inputMoneyTF.contentTF.text isEqualToString:@""]||
       self.inputMoneyTF.contentTF.text==nil){
        [ApplicationDelegate showErrorPrompt:@"请输入金额"];
        return NO;
        
    }
    else if([self.inputMoneyTF.contentTF.text floatValue]<100)
    {
        [ApplicationDelegate showErrorPrompt:@"最小金额为100元"];
        return NO;
    }
    
    if (type==0) //普通提现
    {
        if ([self.inputMoneyTF.contentTF.text floatValue]>[self.receiveDic[@"balance"] floatValue])
        {
            [ApplicationDelegate showErrorPrompt:@"余额不足"];
            return NO;
        } 
    }
    else //快速提现
    {
        if ([self.inputMoneyTF.contentTF.text intValue]>[self.receiveDic[@"unbalance"] floatValue])
        {
            [ApplicationDelegate showErrorPrompt:@"余额不足"];
            return NO;
        }
    }
    return YES;
}


#pragma mark - 按钮点击事件
- (IBAction)selectType:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"普通提现（免手续费）" otherButtonTitles:@"快速提现", nil];
    [sheet showInView:self.view];
    
}
-(IBAction)confirmButtonAction:(id)sender
{
    if ([self checkValue]) {
        //跳转到确认界面
        AccCollectCashConfirmViewController *vc = [[AccCollectCashConfirmViewController alloc] initWithNibName:nil bundle:nil money:self.inputMoneyTF.contentTF.text];
        vc.type = type;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end

//
//  ComplementRegisterInfoViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-25.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "ComplementRegisterInfoViewController.h"
#import "UITextField+HideKeyBoard.h"
#import <QuartzCore/QuartzCore.h>
#import "ComplementRegisterModifyController.h"

#define right_x 105
#define right_w 185
#define right_y 5
#define right_h 30
#define left_w 60
#define left_x 10

@interface ComplementRegisterInfoViewController ()

@end

@implementation ComplementRegisterInfoViewController

@synthesize merchantNameTF;
@synthesize cardIDNumTF;
@synthesize emailTF;
@synthesize setupPaymentPWDTF;
@synthesize confirmPaymentPWDTF;
@synthesize label_name;
@synthesize label_cardno;
@synthesize label_status;
@synthesize label_type;
@synthesize btn_edit;

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
    
    self.navigationItem.title = @"完善注册信息";
    self.hasTopView = true;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 300, 145)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1;
    bgView.layer.cornerRadius = 5;
    bgView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:bgView];
    
    UILabel *name_label = [[UILabel alloc] initWithFrame:CGRectMake(left_x, right_y, left_w, right_h)];
    name_label.backgroundColor= [UIColor clearColor];
    name_label.font = [UIFont systemFontOfSize:15.0f];
    name_label.text = @"商户名称";
    [bgView addSubview:name_label];
    label_name = [[UILabel alloc] initWithFrame:CGRectMake(right_x, right_y, right_w, right_h)];
    label_name.backgroundColor= [UIColor clearColor];
    label_name.font = [UIFont systemFontOfSize:15.0f];
    [label_name setTextAlignment:NSTextAlignmentRight];
    [bgView addSubview:label_name];
    
    UILabel *type_label = [[UILabel alloc] initWithFrame:CGRectMake(left_x, right_y+35, left_w, right_h)];
    type_label.backgroundColor= [UIColor clearColor];
    type_label.font = [UIFont systemFontOfSize:15.0f];
    type_label.text = @"证件类型";
    [bgView addSubview:type_label];
    label_type = [[UILabel alloc] initWithFrame:CGRectMake(right_x, right_y+35, right_w, right_h)];
    label_type.backgroundColor= [UIColor clearColor];
    label_type.font = [UIFont systemFontOfSize:15.0f];
    label_type.text = @"身份证";
    [label_type setTextAlignment:NSTextAlignmentRight];
    [bgView addSubview:label_type];
    
    UILabel *cardno_label = [[UILabel alloc] initWithFrame:CGRectMake(left_x, right_y+35*2, left_w, right_h)];
    cardno_label.backgroundColor= [UIColor clearColor];
    cardno_label.font = [UIFont systemFontOfSize:15.0f];
    cardno_label.text = @"证件号码";
    [bgView addSubview:cardno_label];
    label_cardno = [[UILabel alloc] initWithFrame:CGRectMake(right_x, right_y+35*2, right_w, right_h)];
    label_cardno.backgroundColor= [UIColor clearColor];
    label_cardno.font = [UIFont systemFontOfSize:15.0f];
    [label_cardno setTextAlignment:NSTextAlignmentRight];
    [bgView addSubview:label_cardno];
    
    UILabel *status_label = [[UILabel alloc] initWithFrame:CGRectMake(left_x, right_y+35*3, left_w, right_h)];
    status_label.backgroundColor= [UIColor clearColor];
    status_label.font = [UIFont systemFontOfSize:15.0f];
    status_label.text = @"商户状态";
    [bgView addSubview:status_label];
    label_status = [[UILabel alloc] initWithFrame:CGRectMake(right_x, right_y+35*3, right_w, right_h)];
    label_status.backgroundColor= [UIColor clearColor];
    label_status.font = [UIFont systemFontOfSize:15.0f];
    [label_status setTextAlignment:NSTextAlignmentRight];
    [bgView addSubview:label_status];
    
    btn_edit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_edit setFrame:CGRectMake(10, right_y+35*3+140, 300, 44)];
    
    [btn_edit setTitle:@"编 辑" forState:UIControlStateNormal];
    [btn_edit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_edit.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn_edit addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn_edit setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [btn_edit setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [btn_edit setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [btn_edit setHidden:YES];
    [self.view addSubview:btn_edit];
    
    [self getRegisterInfo];
}

-(IBAction)editAction:(id)sender
{
    ComplementRegisterModifyController *vc = [[ComplementRegisterModifyController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

-(void)getRegisterInfo{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    
    [[Transfer sharedTransfer] startTransfer:@"089013" fskCmd:nil paramDic:dic];
    
}

-(void)fromLogic:(UserModel*) tmp_model
{
    if(tmp_model.merchant_name != nil){
       [label_name setText:tmp_model.merchant_name];
    }
    if(tmp_model.pid != nil){
        [label_cardno setText:tmp_model.pid];
    }
    
    NSString *status ;
    if([tmp_model.is_complete isEqualToString:@"9"]){
        [btn_edit setHidden:NO];
    }
    
    if([tmp_model.is_complete isEqualToString:@"0"]){
        status = @"已注册未完善用户信息";
    }
    if([tmp_model.is_complete isEqualToString:@"1"]){
        status = @"已完善未审核";
    }
    if([tmp_model.is_complete isEqualToString:@"2"]){
        status = @"初审通过，等待复审";
    }
    if([tmp_model.is_complete isEqualToString:@"3"]){
        status = @"复审通过";
    }
    if([tmp_model.is_complete isEqualToString:@"4"]){
        status = @"审核不通过";
    }
    if([tmp_model.is_complete isEqualToString:@"7"]){
        status = @"已注销";
    }
    if([tmp_model.is_complete isEqualToString:@"8"]){
        status = @"已冻结";
    }
    if([tmp_model.is_complete isEqualToString:@"9"]){
        status = @"终审通过";
    }
    
    [label_status setText:status];
    
}
-(IBAction)confirmButtonAction:(id)sender
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"PHONENUM"];
    [dic setObject:self.merchantNameTF.contentTF.text forKey:@"merchant_name"];
    [dic setObject:self.cardIDNumTF.contentTF.text forKey:@"pid"];
    [dic setObject:self.emailTF.contentTF.text forKey:@"email"];
    [dic setObject:self.setupPaymentPWDTF.md5Value forKey:@"paypass"];
    
    [[Transfer sharedTransfer] startTransfer:@"089010" fskCmd:nil paramDic:dic];
}
@end

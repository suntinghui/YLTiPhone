//
//  RealnameLegalizeViewController.m
//  YLTiPhone
//
//  Created by xushuang on 14-1-19.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "RealnameLegalizeViewController.h"
#import "UIImage+Scaling.h"

@interface RealnameLegalizeViewController ()

@end

@implementation RealnameLegalizeViewController

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
    self.navigationItem.title = @"实名认证";
    self.hasTopView = YES;

    imageFlag = 0;
    defaultImg = [UIImage imageNamed:@"head_small"];
    
    
    if (self.pageType == 1){
        //未进行实名认证
        //scrollview 上面4个label  4个imageview 上面放4个button
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, VIEWHEIGHT)];
        [scrollView setContentSize:CGSizeMake(320, 700)];
        scrollView.showsVerticalScrollIndicator = false;
        [self.view addSubview:scrollView];
    
        
        UIButton *img13Button = [UIButton buttonWithType:UIButtonTypeCustom];
        img13Button.backgroundColor = [UIColor clearColor];
        [img13Button setFrame:CGRectMake(150, 10, 130, 160)];
        [img13Button setTag:10001];
        [img13Button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        [img13Button setBackgroundImage:defaultImg forState:UIControlStateNormal];
        [scrollView addSubview:img13Button];
        
        UIButton *img17Button = [UIButton buttonWithType:UIButtonTypeCustom];
        img17Button.backgroundColor = [UIColor clearColor];
        [img17Button setFrame:CGRectMake(150, 180, 130, 160)];
        [img17Button setTag:10002];
        [img17Button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        [img17Button setBackgroundImage:defaultImg forState:UIControlStateNormal];
        [scrollView addSubview:img17Button];
        
        UIButton *img14Button = [UIButton buttonWithType:UIButtonTypeCustom];
        img14Button.backgroundColor = [UIColor clearColor];
        [img14Button setFrame:CGRectMake(150, 350, 130, 160)];
        [img14Button setTag:10003];
        [img14Button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        [img14Button setBackgroundImage:defaultImg forState:UIControlStateNormal];
        [scrollView addSubview:img14Button];
        
        UIButton *img15Button = [UIButton buttonWithType:UIButtonTypeCustom];
        img15Button.backgroundColor = [UIColor clearColor];
        [img15Button setFrame:CGRectMake(150, 520, 130, 160)];
        [img15Button setTag:10004];
        [img15Button setBackgroundImage:defaultImg forState:UIControlStateNormal];
        [img15Button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:img15Button];
        
        
        UILabel *img13Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        img13Label.backgroundColor= [UIColor clearColor];
        img13Label.font = [UIFont systemFontOfSize:15.0f];
        img13Label.text = @"上传头像";
        [scrollView addSubview:img13Label];
        
        UILabel *img17Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 100, 30)];
        img17Label.backgroundColor= [UIColor clearColor];
        img17Label.font = [UIFont systemFontOfSize:15.0f];
        img17Label.text = @"身份证正面";
        [scrollView addSubview:img17Label];
        
        UILabel *img14Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, 200, 30)];
        img14Label.backgroundColor= [UIColor clearColor];
        img14Label.font = [UIFont systemFontOfSize:15.0f];
        img14Label.text = @"身份证反面";
        [scrollView addSubview:img14Label];
        
        UILabel *cardTypeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 520, 100, 30)];
        cardTypeLabel2.backgroundColor= [UIColor clearColor];
        cardTypeLabel2.font = [UIFont systemFontOfSize:15.0f];
        cardTypeLabel2.text = @"合照";
        [scrollView addSubview:cardTypeLabel2];
        

        confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setFrame:CGRectMake(10, 45, 60, 30)];
        [confirmButton setTitle:@"上传" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmButton];
        
    }else{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 300, 100)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.borderWidth = 1;
        bgView.layer.cornerRadius = 5;
        bgView.layer.borderColor = [UIColor grayColor].CGColor;
        [self.view addSubview:bgView];
        
        UILabel  *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 30)];
        nameLabel.backgroundColor= [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.text = @"真实姓名";
        [bgView addSubview:nameLabel];
        
        UILabel *cardTypeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 100, 30)];
        cardTypeLabel1.backgroundColor= [UIColor clearColor];
        cardTypeLabel1.font = [UIFont systemFontOfSize:15.0f];
        cardTypeLabel1.text = @"身份证";
        [bgView addSubview:cardTypeLabel1];
        
        UILabel *stateLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 100, 30)];
        stateLabel1.backgroundColor= [UIColor clearColor];
        stateLabel1.font = [UIFont systemFontOfSize:15.0f];
        stateLabel1.text = @"商户状态";
        [bgView addSubview:stateLabel1];
        
        nameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 160, 30)];
        nameLabel1.backgroundColor= [UIColor clearColor];
        nameLabel1.font = [UIFont systemFontOfSize:15.0f];
        nameLabel1.textAlignment = UITextAlignmentRight;
        [bgView addSubview:nameLabel1];
        
        cardTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 160, 30)];
        cardTypeLabel.backgroundColor= [UIColor clearColor];
        cardTypeLabel.font = [UIFont systemFontOfSize:15.0f];
        cardTypeLabel.textAlignment = UITextAlignmentRight;
        [bgView addSubview:cardTypeLabel];
        
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 160, 30)];
        stateLabel.backgroundColor= [UIColor clearColor];
        stateLabel.font = [UIFont systemFontOfSize:15.0f];
        stateLabel.textAlignment = UITextAlignmentRight;
        [bgView addSubview:stateLabel];

        
        nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake(10, 170, 300, 40);
        nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [nextBtn setTitle:@"提交材料" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
        [self.view addSubview:nextBtn];
        [nextBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.hidden = YES;
        
        [self getRegisterInfo];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUserModel:(UserModel *)userModel
{
    _userModel = userModel;
    nameLabel1.text = self.userModel.merchant_name;
    
    NSString *status;
    if([self.userModel.status isEqualToString:@"0"]){
        status = @"已注册未完善用户信息";
    }
    if([self.userModel.status isEqualToString:@"1"]){
        status = @"已完善未审核";
    }
    if([self.userModel.status isEqualToString:@"2"]){
        status = @"初审通过，等待复审";
    }
    if([self.userModel.status isEqualToString:@"3"]){
        status = @"复审通过";
    }
    if([self.userModel.status isEqualToString:@"4"]){
        status = @"审核不通过";
    }
    if([self.userModel.status isEqualToString:@"7"]){
        status = @"已注销";
    }
    if([self.userModel.status isEqualToString:@"8"]){
        status = @"已冻结";
    }
    if([self.userModel.status isEqualToString:@"9"]){
        status = @"终审通过";
    }
    
    stateLabel.text = status;
    cardTypeLabel.text = self.userModel.pid;
    
    if(![self.userModel.status isEqualToString:@"9"]){
        [nextBtn setHidden:NO];
    }
    
}

#pragma mark - http请求
-(void)getRegisterInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    
    [[Transfer sharedTransfer] startTransfer:@"089013" fskCmd:nil paramDic:dic];
    
}

- (IBAction)chooseImage:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 10001:
            imageFlag = 10001;
            break;
        case 10002:
            imageFlag = 10002;
            break;
        case 10003:
            imageFlag = 10003;
            break;
        case 10004:
            imageFlag = 10004;
            break;
        default:
            break;
    }
    
    
    //判断设备是否支持摄像头
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {

        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

- (void)buttonClick
{
    RealnameLegalizeViewController *realNameLegalizController = [[RealnameLegalizeViewController alloc]init];
    realNameLegalizController.userModel = self.userModel;
    realNameLegalizController.pageType = 1;
    [self.navigationController pushViewController:realNameLegalizController animated:YES];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIButton *button = (UIButton*)[scrollView viewWithTag:imageFlag];
    [button setBackgroundImage:image forState:UIControlStateNormal];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}


-(BOOL)checkValue
{
    for (int i=10001; i<10005; i++)
    {
        UIButton *button = (UIButton*)[scrollView viewWithTag:i];
        if ([button backgroundImageForState:UIControlStateNormal]==defaultImg)
        {
            [ApplicationDelegate showErrorPrompt:@"请将四张照片补充完整"];
            return NO;

        }
    }

    return YES;
}


- (IBAction)confirmButtonAction:(id)sender
{
    if ([self checkValue]) {
        //sdk中提供了方法可以直接调用
        UIImage *image13 = [[(UIButton*)[scrollView viewWithTag:10001]  backgroundImageForState:UIControlStateNormal]  imageByScalingAndCroppingForSize:CGSizeMake(150, 150)];
        NSData *dataObj13 = UIImageJPEGRepresentation(image13, 1.0);
        NSString *image13Base64 = [dataObj13 base64EncodedString];
        
        UIImage *image14 = [[(UIButton*)[scrollView viewWithTag:10002]  backgroundImageForState:UIControlStateNormal] imageByScalingAndCroppingForSize:CGSizeMake(150, 150)];
        NSData *dataObj14 = UIImageJPEGRepresentation(image14, 1.0);
        NSString *image14Base64 = [dataObj14 base64EncodedString];
        
        UIImage *image15 = [[(UIButton*)[scrollView viewWithTag:10003]  backgroundImageForState:UIControlStateNormal] imageByScalingAndCroppingForSize:CGSizeMake(150, 150)];
        NSData *dataObj15 = UIImageJPEGRepresentation(image15, 1.0);
        NSString *image15Base64 = [dataObj15 base64EncodedString];
        
        UIImage *image17 = [[(UIButton*)[scrollView viewWithTag:10004]  backgroundImageForState:UIControlStateNormal] imageByScalingAndCroppingForSize:CGSizeMake(150, 150)];
        NSData *dataObj17 = UIImageJPEGRepresentation(image17, 1.0);
        NSString *image17Base64 = [dataObj17 base64EncodedString];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
        [dic setObject:self.userModel.merchant_id forKey:@"merchant_id"];
        [dic setObject:image13Base64 forKey:@"img13"];
        [dic setObject:image14Base64 forKey:@"img14"];
        [dic setObject:image15Base64 forKey:@"img15"];
        [dic setObject:image17Base64 forKey:@"img17"];
        //089020 实名认证
        [[Transfer sharedTransfer] startTransfer:@"089020" fskCmd:nil paramDic:dic];
    }
}

@end

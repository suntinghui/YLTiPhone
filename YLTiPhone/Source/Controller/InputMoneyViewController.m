//
//  InputMoneyViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "InputMoneyViewController.h"
#import "ConfirmCancelResultViewController.h"
#import "StringUtil.h"
#import "DemoClient.h"
#import "Transfer+Action.h"
#import "Transfer.h"
#import "InputPasswordViewController.h"

@interface InputMoneyViewController ()

@end

@implementation InputMoneyViewController

@synthesize moneyStr = _moneyStr;
@synthesize displayLabel = _displayLabel;
@synthesize bgView = _bgView;
@synthesize numCount = _numCount;
@synthesize clearButton = _clearButton;
@synthesize fifteenDouble = _fifteenDouble;
@synthesize des = _des;
@synthesize dateView = _dateView;

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
    self.hasTopView = NO;
    self.navigationItem.title = @"输入金额";
    
    self.des = 0.00;
    self.numCount = 0;
    self.moneyStr = [NSMutableString stringWithString:@"0.00"];
    [self displayMoneyStr:self.moneyStr];
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate *curDate = [NSDate date];//获取当前日期
    NSString * curTime = [formater stringFromDate:curDate];
    NSLog(@"%@",curTime);
    for (int i = curTime.length-1; i>=0; i--) {
        [self.dateView addSubview:[self getDateTimeImage:[curTime characterAtIndex:i]-48 countIndex:curTime.length-i-1]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -按钮点击
-(IBAction)buttonAction:(id)sender{
    switch (((UIButton*)sender).tag) {
        case 1001://1
        case 1002://2
        case 1003://3
        case 1004://4
        case 1005://5
        case 1006://6
        case 1007://7
        case 1008://8
        case 1009://9
        case 1000://0
        {
            [self pressNumericButton:((UIButton*)sender).tag%1000];
            break;
        }
        case 1010://删除
        {
            [self pressNumericButton:((UIButton*)sender).tag%1000];
            break;
        }
        case 1011://确定
        {
            if ([self.moneyStr isEqualToString:@"0.00"]) {
                [ApplicationDelegate showErrorPrompt:@"请输入有效金额"];
                
            } else if ([self.moneyStr stringByReplacingOccurrencesOfString:@"." withString:@""].length > 12){
                [ApplicationDelegate showErrorPrompt:@"输入金额过长"];
                
            } else
            {
                
                
                // 因为在这里有可能交易后验证服务器响应数据时点付宝发生异常，这时应该检查冲正。
                if ([[Transfer sharedTransfer] reversalAction]) {
                    return ;
                }
                
#ifdef DEMO
                [DemoClient setDemoAmount:[StringUtil amount2String:self.moneyStr]];
#endif
                
                if (ApplicationDelegate.isAishua)
                {
                    [[Transfer sharedTransfer] startTransfer:nil fskCmd:@"Request_Pay" paramDic:nil];
                }
                else
                {
                    //提示用户刷卡 输入密码 然后跳转到签购单页面
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[StringUtil amount2String:self.moneyStr] forKey:@"field4"];
                    [[Transfer sharedTransfer] startTransfer:@"020022" fskCmd:[NSString stringWithFormat:@"Request_GetDes#Request_GetPin|string:%@",[StringUtil amount2String:self.moneyStr]] paramDic:dic];
                    //                ConfirmCancelResultViewController *confirmVC = [[ConfirmCancelResultViewController alloc] initWithNibName:nil bundle:nil];
                    //                [self.navigationController pushViewController:confirmVC animated:YES];
                }
                
            }
            
            break;
        }
        case 1012://清除
        {
            [self pressNumericButton:((UIButton*)sender).tag%1000];
            break;
        }
        default:
            break;
    }
    
}

-(void)pressNumericButton:(int) tag
{
    self.moneyStr = (NSMutableString*)[self formatString:self.moneyStr tag:tag];
    [self displayMoneyStr:self.moneyStr];
}


#pragma mark - 功能函数
- (void)setCardInfoDic:(NSDictionary *)cardInfoDic
{
    _cardInfoDic = cardInfoDic;
    
    if (self.cardInfoDic!=nil)
    {
        InputPasswordViewController *inputPasswordController = [[InputPasswordViewController alloc]init];
        inputPasswordController.moneyStr = self.moneyStr;
        inputPasswordController.fromVC = 0;
        [self.navigationController pushViewController:inputPasswordController animated:YES];
    }
    
}


-(NSString*)formatString:(NSString*)moneyStr tag:(int)tag
{
    double temp = [moneyStr doubleValue];
    if (tag == 10) {// 删除一位
        self.des = temp / 10;// -0.005防止四舍五入
    } else if(tag == 12){
        self.des = 0.00;
    }else if(moneyStr.length < 15){
        self.des = temp * 10 + 0.01 * tag;
    }
    NSString* str = [NSString stringWithFormat:@"%.3f", self.des];
    return [str substringWithRange:NSMakeRange(0, str.length-1)];
    
}

-(void)displayMoneyStr:(NSString*)moneyStr
{
    for (UIView *view in self.bgView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = moneyStr.length-1; i>=0; i--) {
        [self.bgView addSubview:[self getDigitMoneyImage:[moneyStr characterAtIndex:i]-48 countIndex:moneyStr.length-i-1]];
    }
    
}

-(UIImageView*)getDigitMoneyImage:(int)index countIndex:(int)countIndex
{
    float width = 35.0f;
    float height = 40.0f;
    float origin_x_const = 210.f;
    float origin_y = 10.0f;
    //设置图片缩小比例
    if(self.moneyStr.length > 12) {
        width = 15.0f;
        height = 20.0f;
        origin_y = 22.0f;
    }else if(self.moneyStr.length > 10) {
        width = 20.0f;
        height = 25.0f;
        origin_y = 18.0f;
    }else if (self.moneyStr.length > 8){
        width = 25.0f;
        height = 30.0f;
        origin_y = 14.0f;
    }else if (self.moneyStr.length >7){
        width = 30.0f;
        height = 35.0f;
        origin_y = 12.0f;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(origin_x_const - width*countIndex, origin_y, width, height)];
    NSString *imageName = nil;
    if (index == -2) {
        imageName = @"digit_green_dot.png";
    }else{
        imageName =  [NSString stringWithFormat:@"digit_green_%d.png",index];
    }
    [imageView setImage:[UIImage imageNamed:imageName]];
    return imageView;
}
-(UIImageView*)getDateTimeImage:(int)index  countIndex:(int)countIndex
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150  - 7*countIndex, 0, 7, 20)];
    NSString *imageName = nil;
    if (index == -3) {
        imageName = @"digit_little_dash.png";
    }else{
        imageName =  [NSString stringWithFormat:@"digit_little_%d.png",index];
    }
    [imageView setImage:[UIImage imageNamed:imageName]];
    return imageView;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}


@end


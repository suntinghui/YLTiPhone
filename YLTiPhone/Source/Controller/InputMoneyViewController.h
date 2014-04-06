//
//  InputMoneyViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"

@interface InputMoneyViewController : AbstractViewController

@property(nonatomic, strong)NSMutableString *moneyStr;
@property(nonatomic, strong)IBOutlet UILabel *displayLabel;
@property(nonatomic, strong)IBOutlet UIView *bgView;
@property(nonatomic, strong)IBOutlet UIView *dateView;
@property(nonatomic, assign)int numCount;
@property(nonatomic, strong)IBOutlet UIButton *clearButton;
@property(nonatomic, assign)double fifteenDouble;
@property(nonatomic, assign)double des;
@property(nonatomic, strong)NSDictionary *cardInfoDic;//刷卡获取到的卡信息
-(IBAction)buttonAction:(id)sender;
-(void)pressNumericButton:(int) tag;
-(NSString*)formatString:(NSString*)moneyStr tag:(int)tag;
-(void)displayMoneyStr:(NSString*)moneyStr;
-(UIImageView*)getDigitMoneyImage:(int)index countIndex:(int)countIndex;
-(UIImageView*)getDateTimeImage:(int)index  countIndex:(int)countIndex;

@end

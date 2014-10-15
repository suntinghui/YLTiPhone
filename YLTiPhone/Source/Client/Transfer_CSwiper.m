//
//  Transfer+Transfer_CSwiper.m
//  YLTiPhone
//
//  Created by 文彬 on 14-10-9.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "Transfer_CSwiper.h"
#import "NSObject+MutPerformSel.h"
#import "StringUtil.h"
#import "DateUtil.h"
#import "Transfer+Action.h"
#import "AppDataCenter.h"
#import "ConfirmCancelResultViewController.h"
#import "ConvertUtil.h"
#import "InputMoneyViewController.h"
#import "QueryBalanceViewController.h"
#import "GatherCancelTableViewController.h"
#import "TradeDetailTableViewController.h"
#import "Transfer+FSK.h"

@implementation Transfer (Transfer_CSwiper)

- (void)swiper
{
     [[ICSwiperController shareInstance] startCSwiper:0 Random:nil AppendData:nil Time:30];
}
- (void)startSwiper
{
    NSLog(@"startSwiper");
    [ICSwiperController shareInstance].delegate = self;
   
    [NSThread detachNewThreadSelector:@selector(swiper) toTarget:self withObject:nil];
}

- (void)iTypeGetKsn
{
    [ICSwiperController shareInstance].delegate = self;
    
    NSString *ksn = [[ICSwiperController shareInstance] getKsn];
    NSLog(@"KSN IS:%@",ksn);
    [AppDataCenter sharedAppDataCenter].__TERID = ksn;
    
    [self performSelectorOnMainThread:@selector(fskActionDone) withObject:nil waitUntilDone:NO];
    // 执行下一个方法
    [self runFSKCmd];
}
- (void)onReturnDecodeCompleted:(NSString *)formatID
                      Ksn:(NSString *)ksn
                EncTracks:(NSData *)encTracks
             Track1Length:(int)track1Length
             Track2Length:(int)track2Length
             Track3Length:(int)track3Length
             RandomNumber:(NSData *)randomNumber
                MaskedPAN:(NSString *)maskedPAN
               ExpiryDate:(NSString *)expiryDate
           CardHolderName:(NSString *)cardHolderName
                      Mac:(NSString *)mac
{
    NSLog(@"刷卡结束");
    NSLog(@"%@",[NSString stringWithFormat:@"ksn:%@\nencTracks:%@\ntrack1Length:%d\ntrack2Length:%d\ntrack3Length:%d\nrandomNumber:%@\nmaskedPAN:%@", ksn, encTracks, track1Length, track2Length, track3Length, randomNumber, maskedPAN]);
    
    NSString *entracks = [ConvertUtil data2HexString:encTracks];
    NSString *random = [ConvertUtil data2HexString:randomNumber];
    NSDictionary *cardInfo = @{@"ksn":ksn,
                               @"encTracks":entracks,
                               kTrac1Length:[NSString stringWithFormat:@"%d",track1Length],
                               kTrac2Length:[NSString stringWithFormat:@"%d",track2Length],
                               kTrac3Length:[NSString stringWithFormat:@"%d",track3Length],
                               @"randomNumber":random,
                               kCardNum:maskedPAN};
        
    [AppDataCenter sharedAppDataCenter].cardInfoDict = cardInfo;
    
//    [AppDataCenter sharedAppDataCenter].__PSAMNO =[StringUtil ASCII2Hex:ksn];
    [AppDataCenter sharedAppDataCenter].__RANDOM = random;
    [AppDataCenter sharedAppDataCenter].__ENCTRACKS = entracks;
    [AppDataCenter sharedAppDataCenter].__TERID = ksn;
    
    
    if ( [ApplicationDelegate.topViewController isKindOfClass:[InputMoneyViewController class]] || [ApplicationDelegate.topViewController isKindOfClass:[QueryBalanceViewController class]])
    {
        InputMoneyViewController *inputMoneyController = (InputMoneyViewController*)ApplicationDelegate.topViewController;
        inputMoneyController.cardInfoDic = cardInfo;
        
    }
    //消费撤销列表刷卡后
    else if([ApplicationDelegate.topViewController isKindOfClass:[GatherCancelTableViewController class]])
    {
        if ([ApplicationDelegate.topViewController respondsToSelector:@selector(gotoNextControl)])
        {
            [ApplicationDelegate.topViewController performSelector:@selector(gotoNextControl) withObject:nil];
        }
    }
    
    [self performSelectorOnMainThread:@selector(fskActionDone) withObject:nil waitUntilDone:NO];
    
    // 执行下一个方法
    [self runFSKCmd];

}

- (void)onReturnDevicePlugged
{
    [ApplicationDelegate showSuccessPrompt:@"刷卡器插入手机"];
}

- (void)onReturnDeciceUnplugged
{
    NSLog(@"onDeciceUnplugged");
    [ApplicationDelegate showSuccessPrompt:@"刷卡器已从手机拔出"];
}

//通知监听器控制器CSwiperController正在搜索刷卡器
- (void)onReturnWaitingForDevice
{
   NSLog(@"onWaitingForDevice");
}

//通知监听器没有刷卡器硬件设备
- (void)onReturnNoDeviceDetected
{
    NSLog(@"onNoDeviceDetected");
}

- (void)showPro
{
    [ApplicationDelegate hideProcessNow];
    [ApplicationDelegate performSelector:@selector(showProcess:) withObject:@"准备就绪，请刷卡" afterDelay:0.5];
}
- (void)onReturnWaitingForCardSwipe
{
     NSLog(@"onWaitingForCardSwipe");
    [self showPro];
    [self performSelectorOnMainThread:@selector(showPro) withObject:nil waitUntilDone:NO];
    
}

- (void)onReturnCardSwipeDetected
{
     NSLog(@"onCardSwipeDetected");
}

//通知监听器开始解析或读取卡号、磁道等相关信息
- (void)onReturnDecodingStart
{
    NSLog(@"onDecodingStart");
}

- (void)onReturnError:(int)errorCode ErrorMsg:(NSString *)errorMsg
{
   
    [ApplicationDelegate hideProcess];
    [ApplicationDelegate showText:errorMsg];
    
    NSLog(@"onError errorCode:%d , ErrorMessage:%@",errorCode,errorMsg);
}

//通知监听器控制器CSwiperController的操作被中断
- (void)onReturnInterrupted
{
    [ApplicationDelegate showErrorPrompt:@"操作被中断"];
}

- (void)onReturnTimeout
{
    [ApplicationDelegate showErrorPrompt:@"操作超时"];
}

- (void)onReturnDecodeError:(IDecodeResult)decodeResult
{
    
}
@end

//
//  Transfer+StypeSwiper.m
//  YLTiPhone
//
//  Created by 文彬 on 14/10/23.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "Transfer+StypeSwiper.h"

@implementation Transfer (StypeSwiper)



#pragma mark -对外函数

// 获得设备的信息
- (void)getTerminalID
{
    [[ZftZXBS getInstance] setListener:self];
    if ([ZftZXBS ispluged]) {
        /**
         *  发送获得设备信息指令
         *
         *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
         */
        
        [[ZftZXBS getInstance]  getDeviceInfo];
    }
}

// 获取Pin
- (void)getPin
{
    [[ZftZXBS getInstance] setListener:self];
    if([ZftZXBS ispluged])
    {
        /**
         *  发送获取PIN的指令
         *
         *  @param pin pin
         *
         *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
         */
        
        [[ZftZXBS getInstance]  GetPinBlock:@"123456"];
    }
}

// 请求刷卡或者插入IC卡
- (void)swipeCard
{
    [[ZftZXBS getInstance] setListener:self];
    if([ZftZXBS ispluged])
    {
        /**
         *  发送请求刷卡指令
         *
         *  @param factor 分散因子
         *
         *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
         */
        
        NSInteger result = [[ZftZXBS getInstance] requestSwipeCard:nil];
        if(result == SUCCESS)
        {
        }
    }
}

// 取消刷卡
- (void)cancelSwipe
{
    [[ZftZXBS getInstance] setListener:self];
    if([ZftZXBS ispluged])
    {
        /**
         *  取消刷卡
         *
         *  @return 是否成功取消刷卡，成功则返回0，失败返回1；
         */
        
        [[ZftZXBS getInstance]  SwiperCardCancel];
    }
}


// 更新秘钥
- (void)sTypeUpdateKey:(NSString *)pinKey MacKey:(NSString *) macKey DesKey:(NSString *) desKey
{
    [[ZftZXBS getInstance] setListener:self];
    if([ZftZXBS ispluged])
    {
        /**
         *  发送更新秘钥的指令
         *
         *  @param TDK TDK
         *  @param PinKey Pin
         *  @param MacKey Mac
         *
         *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
         */
        
        NSInteger sendMsgResultCode = [[ZftZXBS getInstance] Change_KeyWithKey1:desKey andKey2:pinKey andKey3:macKey];
        if(sendMsgResultCode != SUCCESS)
        {
        }
    }
}


#pragma mark -sdk回调
/**
 *  刷卡器插入后的回调
 */
-(void)onPlugin
{
    
}

/**
 *  刷卡器拔出后的回调
 */
-(void)onPlugout
{
}

/**
 *  发生错误的回调
 *
 *  @param errCode 错误码
 */
-(void)onError:(NSString *)errCode
{
    
   
}

/**
 *  获得磁条卡卡号的回调
 *
 *  @param accNo 磁条卡卡号
 */
-(void)onCardNum:(NSString *)accNo
{
    NSLog(@"卡号信息是:%@",accNo);
}

/**
 *  获得磁条卡卡磁信息和分散因子的回调
 *
 *  @param encTrack 卡磁信息
 *  @param factor 分散因子
 */
- (void)onCardDataTrack2:(NSString *)encTrack2 andTrack3:(NSString *)encTrack3 andFactor:(NSString *)factor
{
    
    NSLog(@"2磁信息是:%@\n3磁信息是:%@\n分散因子是:%@",encTrack2,encTrack3,factor);
}

/**
 *  更新秘钥的回调
 *
 *  @param code    0表示更新成功 -2表示更新失败
 */
-(void)onCheckKey:(NSInteger)code
{
    if(code == SUCCESS)
    {
        NSLog(@"密钥更新成功");
    }
    else{
         NSLog(@"密钥更新失败");
    }
}

// 获得PIN的回调
-(void)onGetPINBlock:(NSString *)PIN_Block
{
    NSLog(@"获取pin：%@",PIN_Block);
}

// 得到IC卡卡号后回调的方法
-(void)onICCard:(NSString *)cardNum
{
  
    NSLog(@"IC卡卡号：%@",cardNum);
    
    if([ZftZXBS ispluged])
    {
        /**
         *  发送获得IC卡55域数据的指令
         *
         *  @param amount    交易金额
         *  @param transdate 交易日期
         *  @param type      交易类型
         *  @param time      交易时间时分秒
         *
         *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
         */
        
        [[ZftZXBS getInstance] getIcCard55DataWithAmount:@"1" Transdate:@"140918" Type:@"02" TransTime:@"155555"];
    }
}

/**
 *  获得55域数据的回调
 *
 *  @param Message_55 55域数据信息
 */
-(void)onGET55Message:(NSString *)Message_55
{
    NSLog(@"55数据:%@",Message_55);
    
    if([ZftZXBS ispluged])
    {
        /**
         *  发送获得非55域的指令
         *
         *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
         */
        
        [[ZftZXBS getInstance]  getIcCardNo55Data];
    }
}

/**
 *  获得非55域数据的回调
 *  @param cardNum 卡号
 *  @param sqn 序列号
 *  @param encTrack 卡磁
 */
-(void)onGETNO55Message:(NSString *)cardNum andCRDSQN:(NSString *)sqn andencTrack:(NSString *)encTrack
{
    NSString *str=[NSString stringWithFormat:@"非55数据:卡号%@\n序列号%@\n卡磁%@",cardNum,sqn,encTrack];
}

/**
 *  获得设备信息的回调
 *
 *  @param Adc     设备电量
 *  @param devType 设备类型
 *  @param devId   设备ID
 *  @param devTag  设备标示
 */
-(void)onDeviceInfo:(NSInteger)Adc andDevType:(NSString *)devType anddevId:(NSString *)devId anddevtag:(NSString *)devTag
{
    NSString * str= [NSString stringWithFormat:@"%ld\n%@\n%@\n%@\n",(long)Adc,devType,devId,devTag];
    NSLog(@"adc:%ld",(long)Adc);
}

/**
 *  获得IC卡插入后的回调
 *
 *  @param status YES表示IC卡已插入设备
 */
- (void)onGetSCardStatus:(BOOL)status
{
    NSLog(@"status = %d",status);
   
}
@end

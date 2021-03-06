//
//  AppDataCenter.m
//  POS2iPhone
//
//  Created by  STH on 11/28/12.
//  Copyright (c) 2012 RYX. All rights reserved.
//

#import "AppDataCenter.h"
#import "DateUtil.h"
#import "ParseXMLUtil.h"
#import "StringUtil.h"

@interface AppDataCenter ()

// 取系统追踪号，6个字节数字定长域
- (NSString *) getTraceAuditNum;
- (NSString *) getBatchNum;
- (NSString *) getUUID;
- (NSString *) getCurrentVersion;
// 只在注册和登陆时使用该方法。
- (NSString *) getPhoneNum;
// 在交易页面调用
- (NSString *) getPhoneNumWithLabel;
- (NSString *) getMercherName;

@end

@implementation AppDataCenter

@synthesize __PSAMNO,__TERSERIALNO,__PSAMRANDOM,__PSAMPIN,__PSAMMAC,__PSAMTRACK,__PAN,__ENCCARDNO,__VENDOR,__TERID,__CARDNO,__FIELD22;
@synthesize __TRACEAUDITNUM,__BATCHNUM,__ADDRESS,__PHONENUM,__CURRENTVERSION,__VERSIONCODE,__SERVEREDATE;
@synthesize transferNameDic = _transferNameDic;
@synthesize reversalDic = _reversalDic;
@synthesize hasSign = _hasSign;
@synthesize __FIELD35,__FIELD36;

@synthesize __RANDOM, __ENCTRACKS;
@synthesize status = _status;
static AppDataCenter *instance = nil;

/*
 synchronized   这个主要是考虑多线程的程序，这个指令可以将{ } 内的代码限制在一个线程执行，如果某个线程没有执行完，其他的线程如果需要执行就得等着。
 */
+ (AppDataCenter *) sharedAppDataCenter
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[AppDataCenter alloc] init];
        }
    }
    
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        __VERSIONCODE = 0;
        __ADDRESS = @"UNKNOWN";
        __FIELD22 = @"021";
        __SERVEREDATE = [DateUtil getSystemDate2];
        _hasSign = false;

    }
    
    return self;
}

/*
 是从制定的内存区域读取信息创建实例，所以如果需要的单例已经有了，就需要禁止修改当前单例。所以返回 nil
 */
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    
    return nil;
}

// 必须全大写
- (NSString *) getValueWithKey:(NSString *) key
{
    NSString *property = [[key uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([property isEqualToString:@"__TRACEAUDITNUM"]){
        return [self getTraceAuditNum];
    } else if ([property isEqualToString:@"__BATCHNUM"]){
        return [self getBatchNum];
    } else if ([property isEqualToString:@"__YYYYMMDD"]){
        return [DateUtil getSystemDate2];
    } else if ([property isEqualToString:@"__YYYY-MM-DD"]){
        return [DateUtil getSystemDate];
    } else if ([property isEqualToString:@"__HHMMSS"]) {
        return [DateUtil getSystemTime];
    } else if ([property isEqualToString:@"__MMDD"]){
        return [DateUtil getSystemMonthDay];
    } else if ([property isEqualToString:@"__UUID"]){
        return [self getUUID];
    } else if ([property isEqualToString:@"__PHONENUM"]){
        return [self getPhoneNum];
    } else if ([property isEqualToString:@"__PHONENUMWITHLABEL"]){
        return [self getPhoneNumWithLabel];
    } else if ([property isEqualToString:@"__CURRENTVERSION"]){
        return [self getCurrentVersion];
    } else if ([property isEqualToString:@"__VERSIONCODE"]){
        return [self getCurrentVersion];
    } else if ([property isEqualToString:@"__MERCHERNAME"]){
        return [self getMercherName];
    }
//    else if([property isEqualToString:@"__ENCTRACKS"]) {
//        return [AppDataCenter sharedAppDataCenter].__ENCTRACKS;
//    }
    else if([property isEqualToString:@"__ENCTRACKS"]) {
        
        if (ApplicationDelegate.deviceType == CDeviceTypeShuaKaTou||
            ApplicationDelegate.deviceType==CDeviceTypeIbanShuaKaTou)
        {
            return [AppDataCenter sharedAppDataCenter].__ENCTRACKS;
        }
        else if(ApplicationDelegate.deviceType == CDeviceTypeDianFuBao
                ||ApplicationDelegate.deviceType == CDeviceTypeYinPinPOS)
        {
            return @"";
//            return [AppDataCenter sharedAppDataCenter].__PSAMTRACK;
        }
        
    }
    else if ([property isEqualToString:@"__TERID"]){
        
        if (ApplicationDelegate.deviceType==CDeviceTypeShuaKaTou||
            ApplicationDelegate.deviceType == CDeviceTypeIbanShuaKaTou)
        {
               return self.__TERID;
        }
        else if(ApplicationDelegate.deviceType == CDeviceTypeDianFuBao||
                ApplicationDelegate.deviceType == CDeviceTypeYinPinPOS)
        {
            return self.__PSAMNO;
        }
     
    }
    else if([property isEqualToString:@"__TERSERIALNO"])
    {
        return self.__TERSERIALNO;
    }
    else if([property isEqualToString:@"__PSAMNO"])
    {
        return self.__PSAMNO;
    }
    else if ([property isEqualToString:@"__TRK2"])
    {
        
        if (ApplicationDelegate.deviceType == CDeviceTypeShuaKaTou)
        {
            if (self.cardInfoDict[kTrack2]==nil)
            {
                return @"";
            }
            return self.cardInfoDict[kTrack2];
        }
        else if(ApplicationDelegate.deviceType == CDeviceTypeDianFuBao||
                ApplicationDelegate.deviceType == CDeviceTypeYinPinPOS)
        {
            if (self.__FIELD35==nil)
            {
                return @"";
            }
            return self.__FIELD35;
        }
    
    }
    else if([property isEqualToString:@"__TRK3"])
    {
       
        if (ApplicationDelegate.deviceType == CDeviceTypeShuaKaTou)
        {
            if (self.cardInfoDict[kTrack3]==nil)
            {
                return @"";
            }
            return self.cardInfoDict[kTrack3];
        }
        else if(ApplicationDelegate.deviceType == CDeviceTypeDianFuBao||
                ApplicationDelegate.deviceType == CDeviceTypeYinPinPOS)
        {
            if(self.__FIELD36==nil)
                return @"";
            
            return self.__FIELD36;
        }
     
    }
    else if([property isEqualToString:@"__CARD"])
    {
        if (self.cardInfoDict[kCardNum]==nil)
        {
            return @"";
        }
        return  self.cardInfoDict[kCardNum];
    }
    else if([property isEqualToString:@"__TID"])
    {
        return self.terminal_id;
    }
    else if([property isEqualToString:@"__PIN"])
    {
        return self.__PSAMPIN;
    }
    else if([property isEqualToString:@"__RANDOM"])
    {
        if (self.__RANDOM==nil)
        {
            int random = (arc4random() % 100) + 1;
            self.__RANDOM = [NSString stringWithFormat:@"%016d",random];
        }
        return self.__RANDOM;
    }
    else if([property isEqualToString:@"__MBSE"])
    {
        NSArray *arr = [self.__ADDRESS componentsSeparatedByString:@","];
        if (arr.count==3)
        {
            return self.__ADDRESS;
        }
        else
        {
            return @"0,0,unknow";
        }
        
        return @"";
    }
    else {
        SEL selector = NSSelectorFromString(property);
        if ([self respondsToSelector:selector]) {
            // warning:performSelector may cause a leak because its selector is unknown
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [self performSelector:selector];
            #pragma clang diagnostic pop
        } else {
            NSLog(@"ERROR:NOT FOUNT KEY : %@ IN getValue METHOD !", key);
        }
        
    }
    
    return @"";
}

- (NSString *) getTraceAuditNum
{
//    NSInteger number = [UserDefaults integerForKey:TRACEAUDITNUM];
//    if (number == 0) {
//        number = 1;
//    }
//    
//    [UserDefaults setInteger:(number+1)==1000000?1:(number+1) forKey:TRACEAUDITNUM];
//    [UserDefaults synchronize];
//    
//    number +=980000; //add wenbin 20140322
//    
//    __TRACEAUDITNUM = [NSString stringWithFormat:@"%06ld", (long)number];
//    
//    return self.__TRACEAUDITNUM;
    
    
    NSInteger number = [UserDefaults integerForKey:TRACEAUDITNUM];
   
    [UserDefaults setInteger:(number+1) forKey:TRACEAUDITNUM];
    [UserDefaults synchronize];
    
    __TRACEAUDITNUM = [NSString stringWithFormat:@"%06ld", (long)number];
    
    return self.__TRACEAUDITNUM;
}

// 签到后更新批次号
- (void) setBatchNum:(NSString *) batchNum
{
    __BATCHNUM = [NSString stringWithString:batchNum];
    
    [UserDefaults setObject:batchNum forKey:BATCHNUM];
    [UserDefaults synchronize];
}

- (NSString *) getBatchNum
{
    if (__BATCHNUM) {
        return __BATCHNUM;
    } 
    
    __BATCHNUM = [UserDefaults stringForKey:BATCHNUM];
    if (__BATCHNUM == nil) {
        __BATCHNUM = @"000001";
    }
    
    return __BATCHNUM;
}

- (NSString *) getUUID
{
    return [UserDefaults stringForKey:UUIDSTRING] == nil ? @"" : [UserDefaults stringForKey:UUIDSTRING];
}

- (NSString *) getMercherName
{
#ifdef DEMO
    return @"中国联通";
#else
    return [UserDefaults stringForKey:MERCHERNAME] == nil ? @"" : [UserDefaults stringForKey:MERCHERNAME];
#endif
    
}

- (NSString *) getCurrentVersion
{
    NSInteger currentVersion = [UserDefaults integerForKey:VERSION];
    return __CURRENTVERSION = [NSString stringWithFormat:@"%ld", (long)currentVersion];
}

- (void) setPhoneNum:(NSString *) phoneNum
{
    __PHONENUM = [NSString stringWithString:phoneNum];
    
    [UserDefaults setObject:phoneNum forKey:PHONENUM];
    [UserDefaults synchronize];
}

- (void) setAddress:(NSString *) addr
{
    __ADDRESS = [NSString stringWithString:addr];
}
    
// 只在注册和登陆时使用该方法。
- (NSString *) getPhoneNum
{
    if (__PHONENUM) {
        return __PHONENUM;
    }
    
    __PHONENUM = [UserDefaults stringForKey:PHONENUM];
    if (__PHONENUM == nil) {
        
        __PHONENUM = self.temPhone;
    }
    
    return __PHONENUM;
}

// 在交易页面调用
- (NSString *) getPhoneNumWithLabel
{
    return [NSString stringWithFormat:@"注册号码:%@", [self getPhoneNum]];
}

- (void) setVersionCode:(NSInteger) versionCode
{
    __VERSIONCODE = versionCode;
}

- (void) setServerDate:(NSString *) date
{
    __SERVEREDATE = [NSString stringWithString:date];
}

- (NSString *) getServerDate
{
    return [DateUtil formatMonthDay:__SERVEREDATE];
}

- (NSDictionary *)transferNameDic
{
    if (nil == _transferNameDic || [_transferNameDic count] == 0) {
        _transferNameDic = [ParseXMLUtil parseTransferMapXML];
    }
    
    return _transferNameDic;
}

- (NSDictionary *)reversalDic
{
    if (nil == _reversalDic || [_reversalDic count] == 0) {
        _reversalDic = [ParseXMLUtil parseReversalMapXML];
    }
    
    return _reversalDic;
}

- (NSString *) getPosType
{
    NSString *type;
    switch (ApplicationDelegate.deviceType) {
        case CDeviceTypeShuaKaTou:
        {
            type = @"0";
        }
            break;
        case CDeviceTypeDianFuBao:
        {
            type = @"3";
        }
            break;
        case CDeviceTypeYinPinPOS:
        {
            type = @"4";
        }
            break;
        case CDeviceTypeIbanShuaKaTou: //TODO 
        {
            type = @"2";
        }
            break;
        default:
            break;
    }
    
    return type;
}

- (NSString *) getPosName
{
    NSString *type;
    switch (ApplicationDelegate.deviceType) {
        case CDeviceTypeShuaKaTou:
        {
            type = @"刷卡头";
        }
            break;
        case CDeviceTypeDianFuBao:
        {
            type = @"刷卡键盘";
        }
            break;
        case CDeviceTypeYinPinPOS:
        {
            type = @"音频POS";
        }
            break;
        case CDeviceTypeIbanShuaKaTou:
        {
            type = @"I版刷卡头";
        }
            break;
        default:
            break;
    }
    
    return type;
}
@end

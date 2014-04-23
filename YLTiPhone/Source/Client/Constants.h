//
//  Constants.h
//  POS2iPhone
//
//  Created by  STH on 11/27/12.
//  Copyright (c) 2012 RYX. All rights reserved.
//

#import "AppDelegate.h"


#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define UserDefaults [NSUserDefaults standardUserDefaults]


// HTTP
#define HOST                                @"api.vastpay.cn:8443"
//#define HOST                                @"58.221.92.138:8443"
#define FILEURL                             @"http://106.120.253.181:8888/pos/xmlFiles/"
#define JSONURL                             @"yunpaiApi/api/"

typedef enum  //程序类型
{
    CAppTypeHFB, //盒付宝
    CAppTypeBFB, //便付宝
    CAppTypeGFB, //广付宝
    CAppTypeYLT  //优乐通
}CAppType;

#define APPTYPE CAppTypeBFB   //打包时修改成对应标志

//原以为iphone4和iphone5的self.view.bounds.size.height是不一样的，但错了，是一样的，都是548
//所以不能这么设定适配的屏幕高度　4和5没区别
//#define VIEWHEIGHT                          self.view.bounds.size.height - 105
//改成这样就OK了 其中105包括　20的状态条　44的导航 41的手机号码显示条
#define VIEWHEIGHT                          [UIScreen mainScreen].bounds.size.height - 105

#define ios7_h                              (DeviceVersion>=7 ? -50:0)
#define ios7_x                              (DeviceVersion>=7 ? 10:0)

//判断设备是否是iPhone5
#define iPhone5                             ([UIScreen instancesRespondToSelector:@selector (currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

//判断设备是否是IOS7 systemVersion
#define DeviceVersion    [[[UIDevice currentDevice] systemVersion] floatValue]

#define kOnePageSize    20

// DataBase
#define kDataBaseName                       @"POS2iPhone.db"

#define kTransferSuccessTableName           @"TransferSuccessTable"
#define kReversalTableName                  @"ReversalTable"
#define kPayeeAccountTableName              @"PayeeAccountTable"
#define kUploadSignImageTableName           @"UploadSignImageTable"
#define kAnnouncementTableName              @"AnnouncementTable"

// NSUserDefault
#define TRACEAUDITNUM 					    @"traceAuditNum"
#define BATCHNUM							 @"batchNum"
#define PASSWORD							 @"password"
#define PHONENUM							 @"phoneNum"
#define PWDLOGIN                            @"loginpwd"
#define REMBERPWD                           @"remberpwd"
#define VERSION                             @"version"

#define ALREAD_SHOWGUIDE                    @"ALREAD_SHOWGUIDE"

#define UUIDSTRING                          @"UUIDString"

#define MERCHERNAME                         @"mercherName"

#define MERCHANT_ID                         @"merchant_id"
//服务器返回商户名称
#define MERCHANT_NAME                        @"merchant_name"
//身份证
#define PID                                 @"pid"
//身份认证 0 未认证  1 已认证
#define IS_IDENTIFY                         @"is_identify"
//完善注册信息 0 未完善  1 已完善
#define IS_COMPLETE                         @"is_complete"

//md5key
#define MD5KEY                              @"md5key"


// 程序中最新公告编号
#define SYSTEM_ANNOUNCEMENT_LASTEST_NUM		@"SystemAnnouncementLastestNum"
#define SERVER_ANNOUNCEMENT_LASTEST_NUM		@"ServerAnnouncementLastestNum"

// 流量相关值
#define TRAFFIC_MONTH                           @"traffic_month"
#define MONTH_WIFISEND                          @"month_wifi_send"
#define MONTH_WIFIRECEIVE                       @"month_wifi_receive"
#define MONTH_MOBILESEND                        @"month_mobile_send"
#define MONTH_MOBILESRECEIVE                    @"month_mobile_receive"

#define TRAFFIC_DAY                             @"traffic_day"
#define DAY_WIFISEND                            @"day_wifi_send"
#define DAY_WIFIRECEIVE                         @"day_wifi_receive"
#define DAY_MOBILESEND                          @"day_mobile_send"
#define DAY_MOBILESRECEIVE                      @"day_mobile_receive"

// 公钥相关值
#define PUBLICKEY_MOD                           @"publickey_mod"
#define PUBLICKEY_EXP                           @"publickey_exp"
#define PUBLICKEY_VERSION                       @"publickey_version"
#define PUBLICKEY_TYPE                          @"publickey_type"

#define INIT_PUBLICKEY_MOD					@ "D9D0D2224E6E84899184BBCD389F8EE08EB09EBA123948309804113B3F829D24D6093F1AFC153D113FAB8673114F4FABFDAAC9BB1B58B9E569B255BA4C338A2465642411A5EB0D68B78BB1B4E45AFF51580C3802AE01FF4DCF976D4CC681944C478FE3490A051F2B4894C321703C4D091E5365718509B20D23D78BBAD163E405"
#define INIT_PUBLICKEY_EXP					@"010001"

#define INIT_PUBLICKEY_VERSION				@"000000000000"

#define DEVICEID                               @"deviceId"

#define version_num                         101

#define IsFirstEnter                       @"ISFIRSTENTER"



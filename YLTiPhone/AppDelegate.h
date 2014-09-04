//
//  AppDelegate.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MBProgressHUD.h"


typedef enum{
    CDeviceTypeDianFuBao, //刷卡键盘
    CDeviceTypeShuaKaTou, //小刷卡头
    CDeviceTypeYinPinPOS  //大音频pos
    
}CDeviceType;

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>

{
    Reachability                *hostReach;
    MBProgressHUD               *HUD;
}

@property (nonatomic, strong) UIWindow                          *window;
@property (nonatomic, strong) UINavigationController            *rootNavigationController;
@property (nonatomic, assign) BOOL                              hasLogin;
//@property (nonatomic, assign) BOOL                              isAishua;

@property (nonatomic, assign) BOOL                              printVersion;
@property (nonatomic, strong) NSString                          *proName; //程序名字
@property (nonatomic, assign) CDeviceType   deviceType; //设备类型


- (UIViewController *) topViewController;

- (void) gotoSuccessViewController:(NSString *) msg;
- (void) gotoFailureViewController:(NSString *) msg;

- (BOOL) checkNetAvailable; // 检测网络方法一，可能有问题
- (BOOL) checkExistenceNetwork; // 检测网络方法二。。。

- (void) showText:(NSString *) msg;
- (void) showProcess:(NSString *) msg;
- (void) hideProcess;

- (void) showSuccessPrompt:(NSString *) msg;
- (void) showErrorPrompt:(NSString *) msg;
- (void) showErrorPrompt:(NSString *) msg ViewController:(UIViewController *) vc;

- (NSString *)getDateStrWithDate:(NSDate*)someDate withCutStr:(NSString*)cutStr hasTime:(BOOL)hasTime;


@end


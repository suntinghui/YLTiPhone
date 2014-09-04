//
//  AppDelegate.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AppDelegate.h"
#import "FileOperatorUtil.h"
#import "LoginViewController.h"
#import "StringUtil.h"
#import "ResultViewController.h"
#import "BaseDBHelper.h"
#import "HttpManager.h"
#import "Transfer.h"
#import "Transfer+FSK.h"
#import "LocationHelper.h"
#import "Reachability.h"
#import "DateUtil.h"
#import "TimedoutUtil.h"
#import "EncryptionUtil.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDDispatchQueueLogFormatter.h"
#import "BeginGuideViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize rootNavigationController = _rootNavigationController;
@synthesize hasLogin = _hasLogin;
//@synthesize isAishua = _isAishua;
@synthesize printVersion = _printVersion;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSString *isFirstEnter = [UserDefaults objectForKey:IsFirstEnter];
    
    if ((APPTYPE == CAppTypeYLT||APPTYPE==CAppTypeWYZF)&&isFirstEnter==nil)
    {
        BeginGuideViewController *slitViewController = [[BeginGuideViewController alloc] initWithNibName:nil bundle:nil];
        self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:slitViewController];
        [UserDefaults setObject:@"NO" forKey:IsFirstEnter];
    }
    else //集付宝没有提示页
    {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    }
    
    self.proName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    self.window.rootViewController = self.rootNavigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.hasLogin = NO;
    
//    self.isAishua = NO; //TODO
    
    [[LocationHelper sharedLocationHelper] startLocate];
    
    // 初始化应用
    [self initApp];
    
    [[Transfer sharedTransfer]initFSK];
    
    
    /**
     // 监测网络情况
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(reachabilityChanged:)
     name: kReachabilityChangedNotification
     object: nil];
     hostReach = [Reachability reachabilityWithHostname:HOST];
     [hostReach startNotifier];
     ***/
    
    // 请求允许通知
    //    [[UIApplication sharedApplication]
    //     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
    //                                         UIRemoteNotificationTypeBadge |
    //                                         UIRemoteNotificationTypeSound)];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDDispatchQueueLogFormatter *formatter = [[DDDispatchQueueLogFormatter alloc] init];
	[formatter setReplacementString:@"socket" forQueueLabel:GCDAsyncSocketQueueName];
	[formatter setReplacementString:@"socket-cf" forQueueLabel:GCDAsyncSocketThreadName];
	
	[[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskAll;
//}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) initApp
{
    [BaseDBHelper createDataBase];
    
    //添加xml后要修改此处 否则会报data is nil 解析xml出错
//    int currentVersion = [UserDefaults integerForKey:VERSION];
//    if (0 == currentVersion) {
    if (true){
        //应该不需要了
//        [FileOperatorUtil copyXML2Document];
        
        [UserDefaults setInteger:1 forKey:VERSION];
        
        // 由于手机接入平台的种种原因，接受LXK的建议，每个应用只初始化一个UUID，而不是每次启动应用都生成一个UUID。--用于验证码。
        [UserDefaults setObject:[StringUtil getUUID] forKey:UUIDSTRING];
        
        [UserDefaults synchronize];
    }
}

- (void) gotoSuccessViewController:(NSString *) msg
{
    [self.rootNavigationController pushViewController:[[ResultViewController alloc] initwithSuccessMsg:msg] animated:YES];
}

- (void) gotoFailureViewController:(NSString *) msg
{
    [self.rootNavigationController pushViewController:[[ResultViewController alloc] initWithFailureMsg:msg] animated:YES];
}

- (UIViewController *) topViewController
{
    // 在此时机更新时间，是不是有点太过操作频繁。。。
    [[TimedoutUtil sharedInstance] updateLastedTime];
    
    return [self.rootNavigationController topViewController];
}

- (BOOL) checkNetAvailable
{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"无法链接到互联网，请检查您的网络设置"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

- (BOOL) checkExistenceNetwork
{
	BOOL isExistenceNetwork;
	Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			isExistenceNetwork=FALSE;
            //   NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            //   NSLog(@"GRPS 或 3G 网络");
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
            //  NSLog(@"WIFI网络");
            break;
    }
    
	if (!isExistenceNetwork) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"无法链接到互联网，请检查您的网络设置"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
	}
    
	return isExistenceNetwork;
}

#pragma mark - Reachability
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"网络链接已断开"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)setDeviceType:(CDeviceType)deviceType
{
    _deviceType = deviceType;
    
//    [[Transfer sharedTransfer]initFSK]; //修改设备类型后重新初始化刷卡操作类
    
    if(ApplicationDelegate.deviceType==CDeviceTypeShuaKaTou)
    {
        [[Transfer sharedTransfer].m_vcom setMode:VCOM_TYPE_F2F recvMode:VCOM_TYPE_F2F];
        [[Transfer sharedTransfer].m_vcom setMac:false]; //add wenbin 20140328
        
        [ApplicationDelegate setPrintVersion:NO];
        
    }else if(ApplicationDelegate.deviceType == CDeviceTypeDianFuBao
             ||ApplicationDelegate.deviceType == CDeviceTypeYinPinPOS)
    {
        [[Transfer sharedTransfer].m_vcom setMode:VCOM_TYPE_FSK recvMode:VCOM_TYPE_F2F];
    }
}

#pragma mark - MBHUD
- (void) showText:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self topViewController].view.window animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
    //hud.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	hud.labelText = msg;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:2];
}

- (void) showProcess:(NSString *) msg
{
    @try {
        if (!HUD){
            // 使用window是为了屏蔽左上角的返回按纽在弹出等待框后仍然可响应点击事件。
            HUD = [[MBProgressHUD alloc] initWithView:[self topViewController].view.window];
            [[self topViewController].view.window addSubview:HUD];
            
            HUD.delegate = self;
            //HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
            HUD.labelText = msg;
            [HUD show:YES];
        } else {
            HUD.labelText = msg;
        }
    }
    @catch (NSException *exception) {
        if (!HUD){
            // 如果在ViewDidLoad中调用showProgress方法会崩溃
            HUD = [[MBProgressHUD alloc] initWithView:[self topViewController].view];
            [[self topViewController].view addSubview:HUD];
            
            HUD.delegate = self;
            //HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
            HUD.labelText = msg;
            [HUD show:YES];
        } else {
            HUD.labelText = msg;
        }
    }
}

- (void) hideProcess
{
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:0.5];
}

- (void) hideHUD
{
    [HUD hide:YES];
}

- (void) showSuccessPrompt:(NSString *) msg
{
    if(HUD){
        [self hideProcess];
    }
    
    MBProgressHUD *successHUD = [[MBProgressHUD alloc] initWithView:[self topViewController].view.window];
	[[self topViewController].view.window addSubview:successHUD];
    
	successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/success.png"]];
	//successHUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	successHUD.mode = MBProgressHUDModeCustomView;
	
	//successHUD.delegate = self;
	successHUD.labelText = msg;
	
	[successHUD show:YES];
	[successHUD hide:YES afterDelay:2];
}

- (void) showErrorPrompt:(NSString *) msg
{
    if(HUD){
        [self hideProcess];
    }
    
    MBProgressHUD *errHUD = [[MBProgressHUD alloc] initWithView:[self topViewController].view.window];
	[[self topViewController].view.window addSubview:errHUD];
    //errHUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	errHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/error.png"]];
	
	errHUD.mode = MBProgressHUDModeCustomView;
	
	errHUD.labelText = msg;
	
	[errHUD show:YES];
	[errHUD hide:YES afterDelay:2];
}

- (void) showErrorPrompt:(NSString *) msg ViewController:(UIViewController *) vc
{
    MBProgressHUD *errHUD = [[MBProgressHUD alloc] initWithView:vc.view.window];
    [vc.view.window addSubview:errHUD];
    errHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/error.png"]];
    //errHUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    errHUD.mode = MBProgressHUDModeCustomView;
    errHUD.labelText = msg;
    [errHUD show:YES];
    [errHUD hide:YES afterDelay:2];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	
    //[hud removeFromSuperview];
	HUD = nil;
}


/**
 *	@brief	获取指定日期的字符串表达式 需要当前日期时传入：[NSDate date] 即可 注意时区转换
 *
 *	@param 	someDate 	指定的日期 NSDate类型
 *	@param 	typeStr 	分割线类型 @"/" 或者@“-”  传nil时默认没有分隔符
 *  @param  hasTime     是否需要返回时间
 *	@return	返回的日期字符串  格式为 2012-13-23 或者 2013/13/23 或2012-12-12 12:11:11 或2102/12/12 12:12:12
 */
- (NSString *)getDateStrWithDate:(NSDate*)someDate withCutStr:(NSString*)cutStr hasTime:(BOOL)hasTime
{
    if (cutStr == nil) {
        cutStr = @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *str = nil;
    if (hasTime) {
        str = [NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm:ss",cutStr,cutStr];
    }
    else
    {
        str = [NSString stringWithFormat:@"yyyy%@MM%@dd",cutStr,cutStr];
    }
	[formatter setDateFormat:str];
	NSString *date = [formatter stringFromDate:someDate];
	return date;
}

@end

// UINavigationController
@implementation UINavigationController (Rotation_IOS6)

- (BOOL)shouldAutorotate {
    
    if ([[self.viewControllers lastObject] isKindOfClass:NSClassFromString(@"")])
    {
      return YES;
    }
    return NO;
    
    return [[self.viewControllers lastObject] shouldAutorotate];
    
}

- (NSUInteger)supportedInterfaceOrientations {
    
    if ([[self.viewControllers lastObject] isKindOfClass:NSClassFromString(@"")])
    {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
    
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    if ([[self.viewControllers lastObject] isKindOfClass:NSClassFromString(@"")])
    {
        return 0;
    }
    return UIInterfaceOrientationPortrait;
    
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end

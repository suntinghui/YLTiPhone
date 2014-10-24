//
//  UpdateAppHelper.m
//  POS2iPhone
//
//  Created by  STH on 5/17/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "UpdateAppHelper.h"
#import "MKNetworkKit.h"
#import "JSONKit.h"

/**
 
 设置版本号是在plist文件中设置Bundle version属性
 
 http://blog.csdn.net/nicktang/article/details/6875234
 
 ***/

//#define APPURL          @"http://itunes.apple.com/lookup?id=com.ryx.mer.POS2iPhone"
//#define APPURL          @"http://itunes.apple.com/lookup?id=600265765"

#define ITUNES_HOST  @"itunes.apple.com"
//#define APP_URL      @"lookup?id=600265765"
//#define APP_URL      @"lookup?id=com.ryx.mer.POS2iPhone"
#define APP_URL      ([NSString stringWithFormat:@"lookup?id=%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]])

@implementation UpdateAppHelper

+ (void) checkUpdateWithsuccessHandler:(UpdateAppBlack) successBlock
        errorHandler:(MKNKErrorBlock) errorBlock
{
    
#ifdef DEMO
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前已是最新版本。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
    
#else
    [ApplicationDelegate showProcess:@"正在检查新版本..."];
    
    MKNetworkEngine *workEngine = [[MKNetworkEngine alloc] initWithHostName:ITUNES_HOST];
    
    MKNetworkOperation *op = [workEngine operationWithPath:APP_URL params:nil httpMethod:@"POST"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice.
         // if you are interested only in new values, move that code within the else block
         if([completedOperation isCachedResponse]) {
             NSLog(@"Data from cache %@", [completedOperation responseString]);
         }
         else {
             NSLog(@"Data from server %@", [completedOperation responseString]);
         }
         
         NSDictionary *respDic = [[completedOperation responseString] objectFromJSONString];
         NSLog(@"response json:%@", respDic);
         
         
         NSString *trackViewUrl = nil;
         
         // 取当前系统最新版本号
         NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
         NSString *localVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
         
         // 取appstore上的版本号
         int count = [[respDic objectForKey:@"resultCount"] intValue];
         if (count == 1) {
             NSString *lastestVersion = [[[respDic objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
             
             if (![lastestVersion isEqualToString:localVersion]) {
                 trackViewUrl = [[[respDic objectForKey:@"results"] objectAtIndex:0] objectForKey:@"trackViewUrl"];
             }
         }
         
         [ApplicationDelegate hideProcess];
         
         successBlock(trackViewUrl);
         
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         NSLog(@"MKNetwork request error : %@", [error localizedDescription]);
         
         [ApplicationDelegate hideProcess];
         
         errorBlock(error);
     }];
    
    [workEngine enqueueOperation:op];
    
#endif
    
}


/****

static NSString *trackViewUrl;

+ (NSString *) trackViewUrl
{
    return trackViewUrl;
}

// 检查是否有新版本
+ (BOOL) checkUpdate
{
#ifndef DEMO
    return NO;
    
#else
    
    // 取当前系统最新版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:APPURL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [results objectFromJSONString];
    NSLog(@"update dic: %@", dic);
    
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:localVersion]) {
            trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
            
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
    

#endif
}
 
  ****/

@end
 


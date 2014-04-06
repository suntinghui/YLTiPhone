//
//  TrafficUtil.m
//  POS2iPhone
//
//  Created by  STH on 4/27/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "TrafficUtil.h"

@implementation TrafficUtil

static TrafficUtil *instance = nil;

+ (TrafficUtil *) sharedInstance
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[TrafficUtil alloc] init];
        }
    }
    
    return instance;
}

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

- (id)init
{
    NSLog(@"初始化流量统计...");
    
    if (self = [super init])
    {
        NSString *date = [[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__MMDD"];
        NSString *month = [date substringWithRange:NSMakeRange(0, 2)];
        NSString *day = [date substringWithRange:NSMakeRange(2, 2)];
        
        if (![UserDefaults stringForKey:TRAFFIC_MONTH]){
            [UserDefaults setObject:month forKey:TRAFFIC_MONTH];
        }
        
        if (![UserDefaults stringForKey:TRAFFIC_DAY]) {
            [UserDefaults setObject:day forKey:TRAFFIC_DAY];
        }
        
        if (![month isEqualToString:[UserDefaults stringForKey:TRAFFIC_MONTH]]) {
            [UserDefaults setDouble:0 forKey:MONTH_MOBILESEND];
            [UserDefaults setDouble:0 forKey:MONTH_MOBILESRECEIVE];
            [UserDefaults setDouble:0 forKey:MONTH_WIFISEND];
            [UserDefaults setDouble:0 forKey:MONTH_WIFIRECEIVE];
        }
        
        if (![day isEqualToString:[UserDefaults stringForKey:TRAFFIC_DAY]]) {
            [UserDefaults setDouble:0 forKey:DAY_MOBILESEND];
            [UserDefaults setDouble:0 forKey:DAY_MOBILESRECEIVE];
            [UserDefaults setDouble:0 forKey:DAY_WIFISEND];
            [UserDefaults setDouble:0 forKey:DAY_WIFIRECEIVE];
        }
        
        [UserDefaults synchronize];
    }
    
    return self;
}

- (void) setTraffic:(int) type length:(double) length
{
    double monthTotalLength = 0;
    double dayTotalLength = 0;
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi) {
        // WIFI
        monthTotalLength = [UserDefaults doubleForKey:type==TYPE_SEND?MONTH_WIFISEND:MONTH_WIFIRECEIVE];
        [UserDefaults setDouble:(monthTotalLength+length) forKey:type==TYPE_SEND?MONTH_WIFISEND:MONTH_WIFIRECEIVE];
        
        dayTotalLength = [UserDefaults doubleForKey:type==TYPE_SEND?DAY_WIFISEND:DAY_WIFIRECEIVE];
        [UserDefaults setDouble:(dayTotalLength+length) forKey:type==TYPE_SEND?DAY_WIFISEND:DAY_WIFIRECEIVE];
    } else {
        // 3G or GPRS
        monthTotalLength = [UserDefaults doubleForKey:type==TYPE_SEND?MONTH_MOBILESEND:MONTH_MOBILESRECEIVE];
        [UserDefaults setDouble:(monthTotalLength+length) forKey:type==TYPE_SEND?MONTH_MOBILESEND:MONTH_MOBILESRECEIVE];
        
        dayTotalLength = [UserDefaults doubleForKey:type==TYPE_SEND?DAY_MOBILESEND:DAY_MOBILESRECEIVE];
        [UserDefaults setDouble:(dayTotalLength+length) forKey:type==TYPE_SEND?DAY_MOBILESEND:DAY_MOBILESRECEIVE];
    }
    
    [UserDefaults synchronize];
}

- (NSDictionary *) getTraffic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSNumber numberWithDouble:[UserDefaults doubleForKey:MONTH_WIFISEND]] forKey:MONTH_WIFISEND];
    [dic setObject:[NSNumber numberWithDouble:[UserDefaults doubleForKey:MONTH_WIFIRECEIVE]] forKey:MONTH_WIFIRECEIVE];
    [dic setObject:[NSNumber numberWithDouble:[UserDefaults doubleForKey:MONTH_MOBILESEND]] forKey:MONTH_MOBILESEND];
    [dic setObject:[NSNumber numberWithDouble:[UserDefaults doubleForKey:MONTH_MOBILESRECEIVE]] forKey:MONTH_MOBILESRECEIVE];
    
    [dic setObject:[NSNumber numberWithDouble:[UserDefaults doubleForKey:DAY_WIFISEND]] forKey:DAY_WIFISEND];
    [dic setObject:[NSNumber numberWithDouble:[UserDefaults doubleForKey:DAY_WIFIRECEIVE]] forKey:DAY_WIFIRECEIVE];
    [dic setObject:[NSNumber numberWithDouble:[UserDefaults doubleForKey:DAY_MOBILESEND]] forKey:DAY_MOBILESEND];
    [dic setObject:[NSNumber numberWithDouble:[UserDefaults doubleForKey:DAY_MOBILESRECEIVE]] forKey:DAY_MOBILESRECEIVE];
    
    return dic;
}



@end

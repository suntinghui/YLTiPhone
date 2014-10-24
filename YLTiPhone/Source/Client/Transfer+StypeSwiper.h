//
//  Transfer+StypeSwiper.h
//  YLTiPhone

//  S版刷卡头调用及回调

//  Created by 文彬 on 14/10/23.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "Transfer.h"
#import "ZftZXBS.h"

@interface Transfer (StypeSwiper)<SwiperDelegate>

// 获得设备的信息
- (void)getTerminalID;

// 获取Pin
- (void)getPin;

// 请求刷卡或者插入IC卡
- (void)swipeCard;

// 取消刷卡
- (void)cancelSwipe;


// 更新秘钥
- (void)sTypeUpdateKey:(NSString *)pinKey MacKey:(NSString *) macKey DesKey:(NSString *) desKey;

@end

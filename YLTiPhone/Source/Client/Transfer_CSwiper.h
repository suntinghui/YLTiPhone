//
//  Transfer+Transfer_CSwiper.h
//  YLTiPhone

//  I版刷卡头调用及回调

//  Created by 文彬 on 14-10-9.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "Transfer.h"
#import "ICSwiper.h"

@interface Transfer (Transfer_CSwiper)<ICSwiperStateChangedListener>

- (void)startSwiper;
- (void)iTypeGetKsn;

@end

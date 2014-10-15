//
//  ICSwiperHandle.h
//  YLTiPhone
//
//  Created by 文彬 on 14-10-11.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICSwiper.h"

@interface ICSwiperHandle : NSObject<ICSwiperStateChangedListener>
{
    ICSwiperController *cSwiperController;
}

+ (ICSwiperHandle *) sharedICSwiper;

- (void)startSwiper;

@end

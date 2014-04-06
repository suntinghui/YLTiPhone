//
//  UpdateAppHelper.h
//  POS2iPhone
//
//  Created by  STH on 5/17/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

@interface UpdateAppHelper : MKNetworkEngine <UIAlertViewDelegate>

typedef void (^UpdateAppBlack) (NSString *url);

+ (void) checkUpdateWithsuccessHandler:(UpdateAppBlack) successBlock
                          errorHandler:(MKNKErrorBlock) errorBlock;

@end

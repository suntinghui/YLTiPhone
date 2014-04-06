//
//  ResultViewController.h
//  POS2iPhone
//
//  Created by jia liao on 1/11/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"

#define LONGINVC 0
#define CARALOGVC 1

@interface ResultViewController : AbstractViewController

@property(nonatomic, assign)BOOL isSuccess;
@property(nonatomic, strong)NSString *navTitle;
@property(nonatomic, strong)NSString *resultMsg;
@property(nonatomic, strong)NSString *messageExplain;
@property(nonatomic, assign)NSInteger popIndex;

- (id)initWithTitle:(NSString*)navTitle resultFlag:(BOOL)isSuccess resultMsg:(NSString*)resultMsg detailMsg:(NSString*)messageExplain popIndex:(NSInteger) popIndex;

- (id) initwithSuccessMsg:(NSString *) msg;

- (id) initWithFailureMsg:(NSString *) msg;

@end

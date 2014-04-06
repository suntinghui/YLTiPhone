//
//  GatherCancelTableViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "SuccessTransferModel.h"

@interface GatherCancelTableViewController : AbstractViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView           *myTableView;
@property (nonatomic, strong) NSArray               *array;
@property (nonatomic, strong) SuccessTransferModel  *model;

@end

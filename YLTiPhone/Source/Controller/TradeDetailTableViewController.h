//
//  TradeDetailTableViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "TransferDetailModel.h"

@interface TradeDetailTableViewController : AbstractViewController<UITableViewDataSource,
UITableViewDelegate>

@property(nonatomic, strong)UITableView *myTableView;
@property (strong, nonatomic) TransferDetailModel *detailModel;

@end

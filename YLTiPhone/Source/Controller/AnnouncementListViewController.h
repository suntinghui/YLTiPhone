//
//  AnnouncementListViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

//公告列表+详情
#import "AbstractViewController.h"

@interface AnnouncementListViewController : AbstractViewController<UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray          *_announcementList;
}
@property (nonatomic, strong) NSMutableArray  *announcementList;
@property(nonatomic, strong)UITableView *myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
     announcementList:(NSMutableArray *)announcementList;
- (void)requestAction;
- (void)refreshTabelView;
@end

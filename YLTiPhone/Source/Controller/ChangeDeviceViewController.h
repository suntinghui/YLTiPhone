//
//  ChangeDeviceViewController.h
//  YLTiPhone
//
//  Created by 文彬 on 14-9-3.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeDeviceViewController : AbstractViewController<UITableViewDataSource,
    UITabBarDelegate>
{
    NSArray *images;
    NSArray *titles;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

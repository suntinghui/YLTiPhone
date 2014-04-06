//
//  CatalogViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"

@class CatalogModel;

@interface CatalogViewController : AbstractViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, UIAlertViewDelegate>
{
    UIScrollView            *_leftScrollView;
    UITableView             *_rightTableView;
    
    NSInteger               _catalogId;
    NSArray                 *_catalogArray;
    NSMutableArray          *_currentCatalogArray;
    
    UIImageView				*slideBg;   //按钮滑动背景
    NSInteger               flag;
    UIImageView             *logoImage;
}
@property (nonatomic, retain) UIScrollView          *leftScrollView;
@property (nonatomic, retain) UITableView           *rightTableView;
@property (nonatomic, retain) NSArray               *catalogArray;
@property (nonatomic, retain) NSMutableArray        *currentCatalogArray;

- (void)getMerchantInfoAction;

@end

//
//  SearchBankViewController.h
//  YLTiPhone
//  新增商户记录--支行选择
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "LeftTextField.h"
#import "AddAccountInfoViewController.h"
#import "ModifyAccountInfoViewController.h"

@interface SearchBankViewController : AbstractViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableDictionary            *_bankDic; //服务器获取
    NSMutableDictionary             *_receiveDic;//上个界面传下来
    NSMutableArray                  *_items;//界面展示的银行信息存放
    
    NSInteger                       pageCurrent;
    
    UIButton *moreButton;
    BOOL isSearch;  //是否为搜索状态
}
@property (nonatomic, strong) LeftTextField    *searchTF;   //账号
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableDictionary      *bankDic;
@property (nonatomic, strong) NSMutableDictionary     *receiveDic; //从前一个页面传过来
@property (nonatomic, strong) NSMutableArray          *items;

@property (nonatomic, assign) AddAccountInfoViewController *addAccountVC;
@property (nonatomic, assign) ModifyAccountInfoViewController *modifyAccountVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              bankDic:(NSMutableDictionary *)bankDic;

- (void)requestAction;
-(void)refreshTabelView;

@end

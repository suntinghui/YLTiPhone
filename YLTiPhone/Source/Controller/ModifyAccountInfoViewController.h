//
//  ModifyAccountInfoViewController.h
//  YLTiPhone
//  暂时废弃 改成修改账户和新增账户复用一个页面
//  Created by xushuang on 14-1-21.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "LeftTextField.h"

@interface ModifyAccountInfoViewController : AbstractViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIToolbarDelegate, UIActionSheetDelegate>
{
    NSInteger           areaFlag;
    NSInteger           bankFlag;
    NSInteger           cityFlag;
    
    NSDictionary        *_receiveDic;
}
@property (nonatomic, strong) LeftTextField    *receiveAcctNumTF;   //账号
@property (nonatomic, strong) LeftTextField    *confirmReceiveAcctNumTF;//确认账号
@property (nonatomic, strong) LeftTextField    *accountInfoTF;//账户名称

@property (nonatomic, strong) UIButton      *selectBankButton;
@property (nonatomic, strong) UIButton      *selectAreaButton;
@property (nonatomic, strong) UIButton      *selectCityButton;
@property (nonatomic, strong) UIButton      *banksBranchButton;

@property (nonatomic, strong) NSArray           *bankArray;
@property (nonatomic, strong) NSArray           *areaArray;
@property (nonatomic, strong) NSArray           *cityArray;
@property (nonatomic, strong) NSMutableArray           *selectCityArray;

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIPickerView  *picker;

@property (nonatomic, strong) NSString  *respBankCode;
@property (nonatomic, strong) NSString  *respBankName;

@property (nonatomic, strong) NSDictionary      *receiveDic;

- (void)selectButton:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  dic:(NSDictionary *)dic;
@end


//
//  AddAccountInfoViewController.h
//  YLTiPhone
//  新增商户记录--省市区选择页面
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "LeftTextField.h"

@interface AddAccountInfoViewController : AbstractViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIToolbarDelegate, UIActionSheetDelegate>
{
    NSInteger           areaFlag;
    NSInteger           bankFlag;
    NSInteger           cityFlag;
}

@property (nonatomic, strong) LeftTextField    *receiveAcctNumConfirmTF;   //账号
@property (nonatomic, strong) LeftTextField    *accountInfo;//确认账号
@property (nonatomic, strong) LeftTextField    *reciveAccountNumTF;//账户名称

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

@property (nonatomic, strong) NSString  *respBankCode; //选择的银行代码
@property (nonatomic, strong) NSString  *respBankName; //选择的银行名称

@property (nonatomic, strong) NSMutableDictionary *accountDict; //修改账户时前一个页面传过来的账号信息
@property (nonatomic, assign) int pageType; //0:新增账户 1：修改账户



- (void)selectButton:(id)sender;

@end

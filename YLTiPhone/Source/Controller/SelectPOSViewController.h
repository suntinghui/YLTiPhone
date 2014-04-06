//
//  SelectPOSViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"

@interface SelectPOSViewController : AbstractViewController<UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate,UIToolbarDelegate>

@property (nonatomic, strong) UIButton      *selectPosButton;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIPickerView  *picker;

@property (nonatomic, strong) NSArray *posArray;

@end

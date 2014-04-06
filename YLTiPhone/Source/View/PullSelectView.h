//
//  PullSelectView.h
//  POS2iPhone
//
//  Created by jia liao on 1/18/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankModel;
@interface PullSelectView : UIView<UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>

@property(nonatomic, strong)UILabel *leftLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UIActionSheet *actionSheet;
@property(nonatomic, strong)UIPickerView *picker;
@property(nonatomic, strong)NSArray *array;
@property(nonatomic, strong)BankModel *selectBankModel;
- (id)initWithFrame:(CGRect)frame;
@end

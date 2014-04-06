//
//  PullSelectAccountVirew.h
//  POS2iPhone
//
//  Created by jia liao on 2/1/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayeeAccountModel.h"
@protocol PullSelectAccountDelegate <NSObject>
-(void)nameAndBankChange;
@end
@interface PullSelectAccountVirew : UIView<UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>

@property(nonatomic, strong)UILabel *leftLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UIActionSheet *actionSheet;
@property(nonatomic, strong)UIPickerView *picker;
@property(nonatomic, strong)NSArray *array;
@property(nonatomic, strong)PayeeAccountModel *selectAccountModel;
@property(nonatomic, weak)id<PullSelectAccountDelegate>delegate;
- (id)initWithFrame:(CGRect)frame array:(NSArray*)array;
- (void)nameAndBankDisplay;
@end


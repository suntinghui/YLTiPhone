//
//  ComplementRegisterInfoViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-25.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

//完善注册信息
#import "AbstractViewController.h"
#import "LeftImageTextField.h"
#import "PwdLeftTextField.h"
#import "UserModel.h"

@interface ComplementRegisterInfoViewController : AbstractViewController<UITextFieldDelegate>

@property(nonatomic, strong)LeftImageTextField *merchantNameTF;
@property(nonatomic, strong)LeftImageTextField *cardIDNumTF;
@property(nonatomic, strong)LeftImageTextField *emailTF;
@property(nonatomic, strong)PwdLeftTextField *setupPaymentPWDTF;
@property(nonatomic, strong)PwdLeftTextField *confirmPaymentPWDTF;

@property(nonatomic, strong)UILabel *label_name;
@property(nonatomic, strong)UILabel *label_type;
@property(nonatomic, strong)UILabel *label_cardno;
@property(nonatomic, strong)UILabel *label_status;
@property(nonatomic, strong)UIButton *btn_edit;

-(void)fromLogic:(UserModel*) tmp_model;

@end

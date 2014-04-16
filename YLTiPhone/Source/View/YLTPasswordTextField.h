//
//  YLTPasswordTextField.h
//  YLTiPhone
//
//  Created by xushuang on 14-1-16.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomKeyBoardView.h"

@interface YLTPasswordTextField : UIView<UITextFieldDelegate, RandomKeyBoardDelegate>

@property(nonatomic, strong) UITextField                *pwdTF;
@property(nonatomic, strong) RandomKeyBoardView         *randomKeyBoardView;
@property(nonatomic, strong, readonly)NSString          *rsaValue;
@property(nonatomic, strong) NSString                   *md5Value;

- (void) numberKeyBoardInput:(NSInteger) number;
- (void) numberKeyBoardDelete;
- (void) numberKeyBoardConfim;
- (void) numberKeyBoardClear;
- (void) numberKeyBoardAbout;
- (void) setRsa;
- (void) clearInput;
- (void)setTextFieldValue:(NSString*)values;
@end


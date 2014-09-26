//
//  LoginViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "LeftTextField.h"
#import "PasswordTextField.h"

#import "YLTPasswordTextField.h"

@interface LoginViewController : AbstractViewController<UITextFieldDelegate,
    UINavigationControllerDelegate,
    UIAlertViewDelegate,
    UIActionSheetDelegate>
{
    BOOL            agreeButtonTouch;

}
@property(nonatomic, strong)IBOutlet LeftTextField    *phoneNumTF;
@property(nonatomic, strong)IBOutlet YLTPasswordTextField    *passwordTF;
@property(nonatomic, strong)IBOutlet UIButton   *forgetPwdButton;
@property(nonatomic, strong)IBOutlet UIButton   *loginButton;
@property(nonatomic, strong)IBOutlet UIButton   *registerButton;
@property(nonatomic, strong)NSString *url;

-(IBAction)loginAction:(id)sender;
-(IBAction)regesterAction:(id)sender;
-(void)showAlertViewUpdate:(NSDictionary *) dic;
- (void)getUserRate;
@end

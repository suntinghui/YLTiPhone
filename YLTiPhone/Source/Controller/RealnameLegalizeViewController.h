//
//  RealnameLegalizeViewController.h
//  YLTiPhone
//
//  Created by xushuang on 14-1-19.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "UserModel.h"

@interface RealnameLegalizeViewController : AbstractViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger               imageFlag;
    UILabel *nameLabel1;
    UILabel *cardTypeLabel;
    UILabel *stateLabel;
    UIButton *nextBtn;
    UIScrollView *scrollView;
    UIButton *confirmButton;
}


@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, assign) int pageType; //0:商户状态页面 1：照片上传页面

- (IBAction)chooseImage:(id)sender;
- (IBAction)confirmButtonAction:(id)sender;

@end

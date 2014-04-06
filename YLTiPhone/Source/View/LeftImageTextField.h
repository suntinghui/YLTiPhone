//
//  LeftImageTextField.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-25.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftImageTextField : UIView <UITextFieldDelegate>


@property(nonatomic, strong)UIImageView *leftImage;
@property(nonatomic, strong)UITextField *contentTF;

-(NSString *)getContent;

- (id)initWithFrame:(CGRect)frame
          leftImage:(NSString *)leftImage
     leftImageFrame:(CGRect)leftImageFrame
             prompt:(NSString *)prompStr
       keyBoardType:(int) keyBoardType;

- (id)initWithFrame:(CGRect)frame
          leftImage:(NSString *)leftImage
     leftImageFrame:(CGRect)leftImageFrame
             prompt:(NSString *)prompStr
       keyBoardType:(int) keyBoardType
        bgImageName:(NSString *)bgImageName;

-(void)setLeftWidth:(float)width;

@end

//
//  LeftImageTextField.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-25.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "LeftImageTextField.h"


#define STRETCH 5

@implementation LeftImageTextField

@synthesize leftImage = _leftImage;
@synthesize contentTF = _contentTF;

- (id)initWithFrame:(CGRect)frame
          leftImage:(NSString *)leftImage
     leftImageFrame:(CGRect)leftImageFrame
             prompt:(NSString *)prompStr
       keyBoardType:(int) keyBoardType
        bgImageName:(NSString *)bgImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[self stretchImage:[UIImage imageNamed:bgImageName]]];
        [bgImageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:bgImageView];
        
        self.leftImage = [[UIImageView alloc] initWithFrame:leftImageFrame];
        [self.leftImage setImage:[self stretchImage:[UIImage imageNamed:leftImage]]];
        [self addSubview:self.leftImage];
        
        if (DeviceVersion >= 7) {
            self.contentTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 5, frame.size.width*2/3, frame.size.height*4/5)];
        }else{
            self.contentTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 12, frame.size.width*2/3, frame.size.height*4/5)];
        }
        
        [self.contentTF setTextColor:[UIColor blackColor]];
        [self.contentTF setBackgroundColor:[UIColor clearColor]];
        [self.contentTF setKeyboardType:keyBoardType];
        [self.contentTF setFont:[UIFont systemFontOfSize:15]];
        [self.contentTF setPlaceholder:prompStr];
        self.contentTF.delegate = self;
        [self addSubview:self.contentTF];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
          leftImage:(NSString *)leftImage
     leftImageFrame:(CGRect)leftImageFrame
             prompt:(NSString *)prompStr
       keyBoardType:(int) keyBoardType
{
    if (self = [self initWithFrame:frame leftImage:leftImage leftImageFrame:leftImageFrame prompt:prompStr keyBoardType:keyBoardType bgImageName:@"textInput.png"])
    {
        
    }
    
    return self;
}

-(NSString *)getContent
{
    return self.contentTF.text;
}

-(void)setLeftWidth:(float)width
{
    if (width > 70) {
        [self.leftImage setFrame:CGRectMake(10, 5, width, self.frame.size.height*3/4)];
        [self.contentTF setFrame:CGRectMake(10+width, 12, self.frame.size.width*2/3, self.frame.size.height*4/5)];
    }
    
}

-(UIImage *)stretchImage:(UIImage *) image
{
    UIImage *returnImage = nil;
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion == 5.0) {
        returnImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, STRETCH, STRETCH, STRETCH)];
    }else if(systemVersion >= 6.0){
        returnImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(25, STRETCH, STRETCH, STRETCH)resizingMode:UIImageResizingModeTile];
    }
    return returnImage;
}


- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    NSLog(@"keyboardWillShow");
    float height = 216.0;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self setFrame:frame];
    [UIView commitAnimations];
}

@end

//
//  SignViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "SignViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Scaling.h"
#import "Transfer+Action.h"
#import "StringUtil.h"

#define STRETCH             5
#define kSCNavBarImageTag   10
#define NUMBERS             @"0123456789\n"

@interface SignViewController ()

@end

@implementation SignViewController
@synthesize amountLabel = _amountLabel;
@synthesize signPanel = _signPanel;
@synthesize delegate = _delegate;
@synthesize phoneNumTF = _phoneNumTF;

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"请您签名";
    // Do any additional setup after loading the view from its nib.
    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:YES];
//    
//    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//    //设置旋转动画
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:duration];
//    
//    //设置导航栏旋转
//    self.navigationController.navigationBar.frame = CGRectMake(-224, 224, 480, 32);
//    self.navigationController.navigationBar.transform = CGAffineTransformMakeRotation(M_PI*1.5);
//    
//    //设置视图旋转
//    self.view.bounds = CGRectMake(0, -54, self.view.frame.size.width, self.view.frame.size.height);
//    self.view.transform = CGAffineTransformMakeRotation(M_PI*1.5);
//    [UIView commitAnimations];
    
//    self.navigationItem.title = @"请您签名";//ios上title没有显示 所以改成了下面的方法
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 32)];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"请您签名";
//    label.font = [UIFont boldSystemFontOfSize:15];
//    self.navigationItem.titleView  =label;
//    
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    
//    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        //if iOS 5.0 and later
//        [navBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
//    }
//    else
//    {
//        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
//        if (imageView == nil)
//        {
//            imageView = [[UIImageView alloc] initWithImage:
//                         [self stretchImage:[UIImage imageNamed:@"navbar.png"]]];
//            [imageView setTag:kSCNavBarImageTag];
//            [navBar insertSubview:imageView atIndex:0];
//        }
//    }
    
    [self.amountLabel setText:[Transfer sharedTransfer].receDic[@"apires"][@"JE"]];
    
    self.phoneNumTF.delegate = self;
    
//    UIImage *buttonNormalImage = [UIImage imageNamed:@"backbutton_normal.png"];
//    UIImage *buttonSelectedImage = [UIImage imageNamed:@"backbutton_selected.png"];
//    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [aButton setImage:buttonNormalImage forState:UIControlStateNormal];
//    [aButton setImage:buttonSelectedImage forState:UIControlStateSelected];
//    aButton.frame = CGRectMake(0.0,0.0,buttonNormalImage.size.width,buttonNormalImage.size.height);
//    [aButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
//    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.hidesBackButton = YES;
    
    // 签名面板
//    self.signPanel = [[HandSignPanel alloc] initWithFrame:CGRectMake(0,124 , 320 , 300+(iPhone5?88:0)) withText:[[Transfer sharedTransfer].receDic objectForKey:@"MD5"]];
//    [self.view addSubview:self.signPanel];
    
    self.painCanvasView = [[PaintMaskView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.painCanvasView  makePaintMaskViewEnable:YES];
    [self.painCanvasView setColorWithRed:0 Green:0 Blue:0];
    [self.painCanvasView setPaintLineWidth:3];
    [self.view insertSubview:self.painCanvasView atIndex:1];
    
    //    UIImageView *bottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_bottom.png"]];
    //    [bottomImage setFrame:CGRectMake(0, 243, 480 + (iPhone5?88:0), 77)];
    //    [self.view addSubview:bottomImage];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000  //ios7适配
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:YES];
//    //设置导航栏旋转
//    self.navigationController.navigationBar.transform = CGAffineTransformMakeRotation(0);
//    self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//
//- (BOOL)prefersStatusBarHidden//for iOS7.0
//{
//    return YES;
//}

#pragma mark-  IBAciton Methods
//确定
-(IBAction)finish:(id)sender
{
    if (self.phoneNumTF.text.length >0&&self.phoneNumTF.text.length < 11) {
        [ApplicationDelegate showErrorPrompt:@"手机号不能少于11位" ViewController:self];
        return ;
    }
    
    //[ApplicationDelegate showProcess:@"正在处理请稍候..."];
//    if (![self.signPanel isDraw]) {
//        [ApplicationDelegate showErrorPrompt:@"请先完成签名" ViewController:self];
//        
//        return;
//    }
    
    if (self.painCanvasView.drawImage.image==nil)
    {
        [ApplicationDelegate showErrorPrompt:@"请先完成签名" ViewController:self];
        return;
    }
    
    // 生成签名图片
//	UIGraphicsBeginImageContext(self.signPanel.bounds.size);
//	[self.signPanel.layer renderInContext:UIGraphicsGetCurrentContext()];
//	UIImage* tempImage=UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	//UIImageWriteToSavedPhotosAlbum([image imageByScalingAndCroppingForSize:CGSizeMake(48, 17)], self, nil, nil);
    
    UIImage *imagetem = [UIImage imageNamed:@"sign_middle.png"];
    UIGraphicsBeginImageContext(self.painCanvasView.bounds.size);
    [imagetem drawInRect:self.painCanvasView.bounds];
    [self.painCanvasView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* tempImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    
    // 压缩图片并生成Base64格式
    UIImage *image = [tempImage imageByScalingAndCroppingForSize:self.painCanvasView.drawImage.frame.size];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSString *imageBase64 = [data base64EncodedString];
    
    // 添加数据
    // TODO 手机号
    [[Transfer sharedTransfer].receDic setObject:(self.phoneNumTF.text ? self.phoneNumTF.text:@"") forKey:@"receivePhoneNo"];
    [[Transfer sharedTransfer].receDic setObject:imageBase64 forKey:@"fieldImage"];
    [[Transfer sharedTransfer].receDic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__UUID"] forKey:@"imei"];
    
    [[Transfer sharedTransfer] uploadSignImageAction];
    
    [ApplicationDelegate hideProcess];
    
    // 签购单界面执行delegate方法，并关闭本界面
    [self.delegate abstractViewControllerDone:tempImage];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//清除
-(IBAction)myPalttealllineclear
{
//	[self.signPanel myalllineclear];
    [self.painCanvasView clearPaintMask];
}

-(IBAction)close:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
////手指开始触屏开始
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	UITouch* touch=[touches anyObject];
//	myBeganpoint=[touch locationInView:self.view ];
//	
//	[self.signPanel Introductionpoint1];
//	[self.signPanel Introductionpoint3:myBeganpoint];
//	
//}
////手指移动时候发出
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	NSArray* MovePointArray=[touches allObjects];
//	myMovepoint=[[MovePointArray objectAtIndex:0] locationInView:self.signPanel];
//	[self.signPanel Introductionpoint3:myMovepoint];
//    [self.signPanel setNeedsDisplay];
//}
//
////当手指离开屏幕时候
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	[self.signPanel Introductionpoint2];
//    [self.signPanel setNeedsDisplay];
//}



// //IOS6默认不开启旋转，如果subclass需要支持屏幕旋转，重写这个方法return YES即可
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
// //IOS6默认支持竖屏
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    //    return UIInterfaceOrientationMaskLandscapeLeft;
//    return 0;
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTF) {
        if ([string isEqualToString:@"\n"]) {
            [textField resignFirstResponder];
            return NO;
        }
        
        if(range.location>=11){
            return NO;
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
    }
    
    return YES;
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


@end

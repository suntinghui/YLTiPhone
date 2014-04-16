//
//  AbstractViewController.m
//  POS2iPhone
//
//  Created by jia liao on 1/6/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "AbstractViewController.h"
#import "TopView.h"

#define STRETCH                 5
#define kSCNavBarImageTag       10

@implementation AbstractViewController

@synthesize hasTopView = _hasTopView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //iphone5适配更改背景图大小　统一使用大背景 by xs 
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"shade-5.png"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.view.bounds = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height );
    }
    
     //本机号码
    if (self.hasTopView) {
        TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, 320, 41)];
        [self.view addSubview:topView];
    }
    
    //自定义UINavigationBar 和返回按钮
        
    UINavigationBar *navBar = self.navigationController.navigationBar;

    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
         //if iOS 5.0 and later
        [navBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar.png"]];
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }
    }
    
    if (!self.navigationItem.hidesBackButton){
        // 返回按纽
        UIImage *buttonNormalImage = [UIImage imageNamed:@"back_button_normal.png"];
        UIImage *buttonSelectedImage = [UIImage imageNamed:@"back_button_normal.png"];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setImage:buttonNormalImage forState:UIControlStateNormal];
        [aButton setImage:buttonSelectedImage forState:UIControlStateSelected];
        aButton.frame = CGRectMake(0.0,0.0,buttonNormalImage.size.width,buttonNormalImage.size.height);
        [aButton addTarget:self action:@selector(backBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
        self.navigationItem.leftBarButtonItem = backButton;
    }
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)
    {
//        if ([self.view window] == nil)// 是否是正在使用的视图
//        {
//            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
//        }
        if ([ApplicationDelegate.topViewController isKindOfClass:[self class]]&&![self isKindOfClass:NSClassFromString(@"RealnameLegalizeViewController")])
        {
             self.view = nil;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.superview.frame;

    int offset = frame.origin.y + 50 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
//    float height = self.view.frame.size.height;
    float height = [UIScreen mainScreen].bounds.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        
        if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView*)[self.view.subviews objectAtIndex:0]).frame = rect
            ;
        }else{
            self.view.frame = rect;
        }
        
    }
    [UIView commitAnimations];
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
//    CGRect rect = CGRectMake(0.0f, 0.0f,320,416);
    CGRect rect = CGRectMake(0.0f, 0.0f,320,VIEWHEIGHT + 41);
    self.view.frame = rect;
    [UIView commitAnimations];

}


//// IOS5默认支持竖屏
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//// IOS6默认不开启旋转，如果subclass需要支持屏幕旋转，重写这个方法return YES即可
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//// IOS6默认支持竖屏
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

-(IBAction)bgButtonAction:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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

-(IBAction)backBUttonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)popToCatalogViewController
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)popToLoginViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setLabelStyle:(UILabel*)label
{
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
}

-(void)showError:(NSString *) error{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    return;

}
@end

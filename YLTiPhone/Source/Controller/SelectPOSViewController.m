//
//  SelectPOSViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "SelectPOSViewController.h"

@interface SelectPOSViewController ()

@end

@implementation SelectPOSViewController

@synthesize selectPosButton, actionSheet, picker, posArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"选择终端";
    
    //选择终端下拉框
//    UIImageView *bankImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 50, 304, 45)];
//    [bankImage setImage:[UIImage imageNamed:@"selectField_normal.png"]];
//    [self.view addSubview:bankImage];
    
    selectPosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPosButton setFrame:CGRectMake(10, 50, 297, 45)];
    [selectPosButton setTitle:@"刷卡键盘" forState:UIControlStateNormal];
    [selectPosButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectPosButton.titleLabel .font = [UIFont boldSystemFontOfSize:18];
    [selectPosButton addTarget:self action:@selector(selectPOSButton) forControlEvents:UIControlEventTouchUpInside];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_highlight.png"] forState:UIControlStateSelected];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_highlight.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:selectPosButton];
    
    selectPosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPosButton setFrame:CGRectMake(10, 110, 297, 45)];
    [selectPosButton setTitle:@"音频POS" forState:UIControlStateNormal];
    [selectPosButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectPosButton.titleLabel .font = [UIFont boldSystemFontOfSize:18];
    [selectPosButton addTarget:self action:@selector(selectPOSButton) forControlEvents:UIControlEventTouchUpInside];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_highlight.png"] forState:UIControlStateSelected];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_highlight.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:selectPosButton];
    
    selectPosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPosButton setFrame:CGRectMake(10, 170, 297, 45)];
    [selectPosButton setTitle:@"刷卡头" forState:UIControlStateNormal];
    [selectPosButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectPosButton.titleLabel .font = [UIFont boldSystemFontOfSize:18];
    [selectPosButton addTarget:self action:@selector(selectPOSButton) forControlEvents:UIControlEventTouchUpInside];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_highlight.png"] forState:UIControlStateSelected];
    [selectPosButton setBackgroundImage:[UIImage imageNamed:@"selectField_highlight.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:selectPosButton];
    
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 120, 297, 42)];
    [confirmButton setTitle:@"确   认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateSelected];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:confirmButton];
    
    posArray = [[NSArray alloc] initWithObjects:@"刷卡键盘",@"音频pos",@"刷卡头", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmButtonAction:(id)sender
{
    //保存客户选择信息  存哪里？
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectPOSButton
{
    //弹出pickerview
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40, 320, 190)];
    self.picker.showsSelectionIndicator=YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [self.actionSheet addSubview:self.picker];
    
    UIToolbar *tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320,40)];
    tools.barStyle = UIBarStyleBlack;
    tools.delegate = self;
    tools.barTintColor = [UIColor clearColor];
    [self.actionSheet addSubview:tools];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(btnActinDoneClicked:)];
    doneButton.imageInsets=UIEdgeInsetsMake(200, 5, 50, 30);
    
    UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [[NSArray alloc]initWithObjects:flexSpace,flexSpace,doneButton,nil];
    
    [tools setItems:array];
    
    
    [self.actionSheet showFromRect:CGRectMake(0,480, 320,200) inView:self.view animated:YES];
    [self.actionSheet setBounds:CGRectMake(0,0, 320, 411)];
}

#pragma mark -btnActinDoneClicked
-(IBAction)btnActinDoneClicked:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

#pragma mark -UIPickerViewDataSource and UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.posArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.posArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.selectPosButton setTitle:[self.posArray objectAtIndex:row] forState:UIControlStateNormal];
}

@end

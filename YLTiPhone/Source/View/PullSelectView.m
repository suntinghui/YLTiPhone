//
//  PullSelectView.m
//  POS2iPhone
//
//  Created by jia liao on 1/18/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "PullSelectView.h"
#import "BankModel.h"
#import "ParseXMLUtil.h"

@implementation PullSelectView

@synthesize leftLabel = _leftLabel;
@synthesize contentLabel = _contentLabel;
@synthesize actionSheet = _actionSheet;
@synthesize picker = _picker;
@synthesize array = _array;
@synthesize selectBankModel = _selectBankModel;

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        self.array = [ParseXMLUtil parseBankXML];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [bgImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"textInput.png"]]];
        [self addSubview:bgImageView];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-70, frame.size.height)];
        _selectBankModel = (BankModel*)[self.array objectAtIndex:0];
        [self.contentLabel setText:((BankModel*)[self.array objectAtIndex:0]).name];
        [self.contentLabel setTextColor:[UIColor blackColor]];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self addSubview:self.contentLabel];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(255, 1, 42, 42)];
        [button setImage:[UIImage imageNamed:@"pullButton.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}

-(IBAction)buttonAction:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40, 320, 190)];
    self.picker.showsSelectionIndicator=YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [self.actionSheet addSubview:self.picker];
        
    UIToolbar *tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320,40)];
    tools.barStyle=UIBarStyleBlackOpaque;
    [self.actionSheet addSubview:tools];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(btnActinDoneClicked:)];
    doneButton.imageInsets=UIEdgeInsetsMake(200, 5, 50, 30);
    
    UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [[NSArray alloc]initWithObjects:flexSpace,flexSpace,doneButton,nil];
    
    [tools setItems:array];
    
    [self.actionSheet showFromRect:CGRectMake(0,480, 320,200) inView:self animated:YES];
    [self.actionSheet setBounds:CGRectMake(0,0, 320, 411)];
    
}

#pragma mark -UIPickerViewDataSource and UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.array count];
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
    return [((BankModel *)[self.array objectAtIndex:row]) name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.contentLabel setText:[((BankModel *)[self.array objectAtIndex:row]) name]];
    self.selectBankModel = (BankModel *)[self.array objectAtIndex:row];
}

#pragma mark -btnActinDoneClicked
-(IBAction)btnActinDoneClicked:(id)sender
{
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    
}

@end

//
//  AddAccountInfoViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AddAccountInfoViewController.h"
#import "SearchBankViewController.h"
#import "ParseXMLUtil.h"
#import "BankModel.h"
#import "UITextField+HideKeyBoard.h"
#import "AreaModel.h"
#import "CityModel.h"

@interface AddAccountInfoViewController ()

@end

@implementation AddAccountInfoViewController

@synthesize receiveAcctNumConfirmTF, accountInfo, reciveAccountNumTF;
@synthesize bankArray, areaArray, cityArray, selectCityArray;
@synthesize selectAreaButton, selectBankButton, selectCityButton,banksBranchButton;
@synthesize actionSheet, picker;
@synthesize respBankCode, respBankName;

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
    if (self.pageType == 0)
    {
        self.navigationItem.title = @"新增账户记录";
        NSString *accountname = self.accountDict[@"accountname"];
        NSString *merchannae = self.accountDict[@"merchant_name"];
        
        self.accountDict = [[NSMutableDictionary alloc]init];
        [self.accountDict setObject:accountname forKey:@"accountname"];
        [self.accountDict setObject:merchannae forKey:@"merchant_name"];
        
    }
    else
    {
        self.navigationItem.title = @"修改账户记录";
    }
    
    self.hasTopView = YES;
    bankFlag = 0;
    areaFlag = 0;
    cityFlag = 0;
    respBankCode = @"";
    
    bankArray = [[NSArray alloc] initWithArray:[ParseXMLUtil parseBankXML]];
    areaArray = [[NSArray alloc] initWithArray:[ParseXMLUtil parseAreaXML]];
    cityArray = [[NSArray alloc] initWithArray:[ParseXMLUtil parseCityXML]];
    selectCityArray = [[NSMutableArray alloc] init];

    for (CityModel *model in cityArray) {
        if ([model.parentCode isEqualToString:[((AreaModel *)[self.areaArray objectAtIndex:areaFlag]) code]])
        {
            [selectCityArray  addObject:model];
        }
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40+ios7_h, 320, VIEWHEIGHT + 41)];
    [scrollView setContentSize:CGSizeMake(320, VIEWHEIGHT+240)];
    scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:scrollView];
    
    UILabel *receiveAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    receiveAccountLabel.backgroundColor = [UIColor clearColor];
    receiveAccountLabel.text = @"收款账户信息";
    receiveAccountLabel.font = [UIFont systemFontOfSize:17.0f];
    [scrollView addSubview:receiveAccountLabel];
    
    //收款账号输入框背景
    UIImageView *accountInfoImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 40, 304, 45)];
    [accountInfoImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [scrollView addSubview:accountInfoImage1];
    self.reciveAccountNumTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 47, 300, 35) isLong:true];
    [self.reciveAccountNumTF.contentTF setPlaceholder:@"收款账号"];
    self.reciveAccountNumTF.contentTF.delegate = self;
    [self.reciveAccountNumTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    [self.reciveAccountNumTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self.reciveAccountNumTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    self.reciveAccountNumTF.contentTF.text = self.accountDict[@"bankaccount"];
    [scrollView addSubview:self.reciveAccountNumTF];
    
    //收款账号输入框背景
    UIImageView *textFieldImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 95, 304, 45)];
    [textFieldImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [scrollView addSubview:textFieldImage1];
    
    self.receiveAcctNumConfirmTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 102, 300, 35) isLong:true];
    [self.receiveAcctNumConfirmTF.contentTF setPlaceholder:@"确认收款账号"];
    self.receiveAcctNumConfirmTF.contentTF.delegate = self;
    [self.receiveAcctNumConfirmTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    [self.receiveAcctNumConfirmTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self.receiveAcctNumConfirmTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    self.receiveAcctNumConfirmTF.contentTF.text = self.accountDict[@"bankaccount"];
    [scrollView addSubview:self.receiveAcctNumConfirmTF];
    
 
    
    //银行信息
    UILabel *bankInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, 300, 35)];
    bankInfoLabel.backgroundColor = [UIColor clearColor];
    bankInfoLabel.text = @"银行信息";
    bankInfoLabel.font = [UIFont systemFontOfSize:17.0f];
    [scrollView addSubview:bankInfoLabel];
    
    //选择银行下拉框
    selectBankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBankButton setFrame:CGRectMake(10, 190, 300, 45)];
    [selectBankButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    [selectBankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectBankButton.tag = 90001;
    [selectBankButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectBankButton];
    
    //省份下拉框
    selectAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectAreaButton setFrame:CGRectMake(10, 245, 300, 45)];
    [selectAreaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAreaButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    selectAreaButton.tag = 90002;
    [selectAreaButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectAreaButton];
    
    //城市下拉框
    selectCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectCityButton setFrame:CGRectMake(10, 300, 300, 45)];
    [selectCityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectCityButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    selectCityButton.tag = 90003;
    [selectCityButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectCityButton];
    
    
    banksBranchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [banksBranchButton setFrame:CGRectMake(10, 355, 297, 42)];
    [banksBranchButton setTitle:@"请选择支行" forState:UIControlStateNormal];
    [banksBranchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    banksBranchButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [banksBranchButton addTarget:self action:@selector(selectBankButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [banksBranchButton setBackgroundImage:[UIImage imageNamed:@"selectBank_normal.png"] forState:UIControlStateNormal];
    [banksBranchButton setBackgroundImage:[UIImage imageNamed:@"selectBank_highlight.png"] forState:UIControlStateSelected];
    [banksBranchButton setBackgroundImage:[UIImage imageNamed:@"selectBank_highlight.png"] forState:UIControlStateHighlighted];
    [scrollView addSubview:banksBranchButton];
    
    //账号信息
    UILabel *accountInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 415, 300, 35)];
    accountInfoLabel.backgroundColor = [UIColor clearColor];
    accountInfoLabel.text = @"账号信息";
    accountInfoLabel.font = [UIFont systemFontOfSize:17.0f];
    [scrollView addSubview:accountInfoLabel];
    //账号信息输入框背景
    UIImageView *textFieldImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 450, 304, 45)];
    [textFieldImage2 setImage:[UIImage imageNamed:@"textInput.png"]];
    [scrollView addSubview:textFieldImage2];
    
    self.accountInfo = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 457, 300, 35) isLong:true];
    [self.accountInfo.contentTF setPlaceholder:@"账号信息"];
    self.accountInfo.contentTF.delegate = self;
    [self.accountInfo.contentTF setFont:[UIFont systemFontOfSize:15]];
    [self.accountInfo.contentTF setKeyboardType:UIKeyboardTypeDefault];
    [self.accountInfo.contentTF hideKeyBoard:scrollView:2 hasNavBar:YES];
    self.accountInfo.contentTF.text = self.accountDict[@"mastername"];
    [scrollView addSubview:self.accountInfo];

    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 520, 297, 42)];
    if (self.pageType == 0)
    {
        self.accountInfo.contentTF.enabled = NO;
         self.accountInfo.contentTF.text = self.accountDict[@"accountname"];
        
         [selectBankButton setTitle:[((BankModel *)[self.bankArray objectAtIndex:0]) name] forState:UIControlStateNormal];
        
         [selectAreaButton setTitle:[((AreaModel *)[self.areaArray objectAtIndex:0]) name] forState:UIControlStateNormal];
        
        [selectCityButton setTitle:[((CityModel *)[self.selectCityArray objectAtIndex:0]) name] forState:UIControlStateNormal];
        
        [confirmButton setTitle:@"确认添加" forState:UIControlStateNormal];
        
    }
    else
    {
         [selectBankButton setTitle:self.accountDict[@"banks"] forState:UIControlStateNormal];
        
        int index=0;
        
        for (BankModel *model in self.bankArray)
        {
            if ([model.name isEqualToString:self.accountDict[@"banks"]])
            {
                bankFlag = index;
                break;
            }
            index++;
        }
        
        index=0;
        for (AreaModel *model in self.areaArray)
        {
            if ([model.code isEqualToString:self.accountDict[@"area"]])
            {
                [selectAreaButton setTitle:model.name forState:UIControlStateNormal];
                areaFlag = index;
                break;
            }
            index++;
        }
        
        for (CityModel *model in cityArray)
        {
            if ([model.parentCode isEqualToString:self.accountDict[@"area"]]&&
                [model.code isEqualToString:self.accountDict[@"city"]])
            {
                [selectCityButton setTitle:model.name forState:UIControlStateNormal];
                
                [selectCityArray removeAllObjects];
                for (CityModel *model in cityArray)
                {
                    if ([model.parentCode isEqualToString:self.accountDict[@"area"]])
                    {
                        [selectCityArray  addObject:model];
                    }
                }
                break;
            }
        }
   
        index=0;
        for (CityModel *model in selectCityArray)
        {
            if ([model.code isEqualToString:self.accountDict[@"city"]])
            {
                [selectCityArray  addObject:model];
                cityFlag = index;
            }
            
              index++;
        }

        [confirmButton setTitle:@"确认修改" forState:UIControlStateNormal];
        self.accountInfo.contentTF.enabled = NO;
    }
    
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [scrollView addSubview:confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectButton:(id)sender
{
    //弹出pickerview
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40, 320, 190)];
    self.picker.showsSelectionIndicator=YES;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 90001:
            self.picker.tag = 10000;
            break;
        case 90002:
            self.picker.tag = 20000;
            break;
        case 90003:
            self.picker.tag = 30000;
            break;
        default:
            break;
    }
    
    
    [self.actionSheet addSubview:self.picker];
    
    UIToolbar *tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320,40)];
    tools.barStyle = UIBarStyleBlack;
    tools.delegate = self;
//    tools.barTintColor = [UIColor clearColor];
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
    if (self.picker.tag == 10000) //选择银行
    {
        
    }
    else if (self.picker.tag == 20000) //选择省份
    {
        
    }
    else if (self.picker.tag == 30000) //选择市区
    {
        
    }
    
    [self.actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

//查找支行
- (void)selectBankButtonAction
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"PHONENUM"];
    [dic setObject:[((AreaModel *)[self.areaArray objectAtIndex:areaFlag]) code] forKey:@"provinceid"];
    [dic setObject:[((CityModel *)[self.selectCityArray objectAtIndex:cityFlag]) code] forKey:@"cityid"];
    [dic setObject:[((BankModel *)[self.bankArray objectAtIndex:bankFlag]) code] forKey:@"bankid"];//银行卡号
    [dic setObject:@"1" forKey:@"page_current"];
    [dic setObject:[NSString stringWithFormat:@"%d",kOnePageSize] forKey:@"page_size"];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    
    SearchBankViewController *searchBank = [[SearchBankViewController alloc] initWithNibName:nil bundle:nil bankDic:dic];
    searchBank.addAccountVC = self;
    searchBank.receiveDic = dic;
    [self.navigationController pushViewController:searchBank animated:YES];
    
    NSLog(@"###%@",respBankCode);
    NSLog(@"###%@",respBankName);
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([respBankName length] == 0) {
        respBankName = @"请选择支行";
    }
    [self.banksBranchButton setTitle:respBankName forState:UIControlStateNormal];
    if (DeviceVersion>=7){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(BOOL)checkValue
{
    if (self.reciveAccountNumTF.contentTF.text == nil||
        [self.reciveAccountNumTF.contentTF.text isEqualToString:@""])
    {
        [ApplicationDelegate showErrorPrompt:@"请输入收款账户"];
        return NO;
    }
    else if (self.receiveAcctNumConfirmTF.contentTF.text == nil||
             [self.receiveAcctNumConfirmTF.contentTF.text isEqualToString:@""])
    {
        [ApplicationDelegate showErrorPrompt:@"请再次输入收款账户"];
        return NO;
    }
    else if(![self.receiveAcctNumConfirmTF.contentTF.text isEqualToString:self.reciveAccountNumTF.contentTF.text]){
        [ApplicationDelegate showErrorPrompt:@"两次输入的收款账户不一致"];
        return NO;
    }
    else if([self.accountInfo.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入账户姓名"];
        return NO;
    }else if([respBankCode isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请选择支行"];
        return NO;
    }
    return YES;
}

//确认添加
- (void)confirmButtonAction
{
    if ([self checkValue]) {
        //检查界面输入情况
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
        [dic setObject:self.receiveAcctNumConfirmTF.contentTF.text forKey:@"bankaccount"];//银行卡号
        [dic setObject:[((BankModel *)[self.bankArray objectAtIndex:bankFlag]) name] forKey:@"banks"];
//        [dic setObject:[((BankModel *)[self.bankArray objectAtIndex:bankFlag]) code] forKey:@"bankno"];
        [dic setObject:self.respBankCode forKey:@"bankno"];

        [dic setObject:[((AreaModel *)[self.areaArray objectAtIndex:areaFlag]) code] forKey:@"area"];
        [dic setObject:[((CityModel *)[self.selectCityArray objectAtIndex:cityFlag]) code] forKey:@"city"];
        [dic setObject:self.respBankCode forKey:@"addr"];
        if (self.pageType==0)
        {
            [dic setObject:self.accountDict[@"merchant_name"] forKey:@"merchant_name"];
            [dic setObject:self.accountInfo.contentTF.text forKey:@"mastername"];
            //新增提款银行账户
            [[Transfer sharedTransfer] startTransfer:@"089008" fskCmd:nil paramDic:dic];
        }
        else
        {
            [dic setObject:self.accountDict[@"merchant_name"] forKey:@"merchant_name"];
            [dic setObject:self.accountDict[@"mastername"] forKey:@"mastername"];
            
            //修改提款银行账户
            [[Transfer sharedTransfer] startTransfer:@"089009" fskCmd:nil paramDic:dic];
        }
        
    }
}

#pragma mark -
#pragma mark * UIPickerViewDelegate
//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 10000){
		return bankArray == nil ? 0 : bankArray.count;
	}else if (pickerView.tag == 20000){
		return areaArray == nil ? 0 : areaArray.count;
	}else if (pickerView.tag == 30000){
		return selectCityArray == nil ? 0 : selectCityArray.count;
	}
	return 0;
}
// 设置当前行的内容，若果行没有显示则自动释放
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (pickerView.tag == 10000){
		if (bankArray != nil && bankArray.count > row){
			return [((BankModel *)[self.bankArray objectAtIndex:row]) name];
		}
	}else if (pickerView.tag == 20000){
		if (areaArray != nil && areaArray.count > row){
			return [((AreaModel *)[self.areaArray objectAtIndex:row]) name];
		}
	}else if (pickerView.tag == 30000){
		if (selectCityArray != nil && selectCityArray.count > row){
			return [((CityModel *)[self.selectCityArray objectAtIndex:row]) name];
		}
	}
	return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 10000) {
		if (bankArray != nil && bankArray.count > row) {
            [self.selectBankButton setTitle:[((BankModel *)[self.bankArray objectAtIndex:row]) name] forState:UIControlStateNormal];
            bankFlag = row;
		}
	}else if (pickerView.tag == 20000) {
        if (areaArray != nil && areaArray.count > row) {
            [self.selectAreaButton setTitle:[((AreaModel *)[self.areaArray objectAtIndex:row]) name] forState:UIControlStateNormal];
            areaFlag = row;
            [selectCityArray removeAllObjects];
            for (CityModel *model in cityArray)
            {
                if ([model.parentCode isEqualToString:[((AreaModel *)[self.areaArray objectAtIndex:areaFlag]) code]])
                {
                    [selectCityArray  addObject:model];
                }
            }
            //改变省份后  默认选中该省份下第一个城市
            [self.selectCityButton setTitle:[((CityModel *)[self.selectCityArray objectAtIndex:0]) name] forState:UIControlStateNormal];
            cityFlag = 0;
            
            //更改省份后 支行置为空
            [self.banksBranchButton setTitle:@"请选择支行" forState:UIControlStateNormal];
            self.respBankCode = @"";
            
		}
    }else if (pickerView.tag == 30000) {
        if (selectCityArray != nil && selectCityArray.count > row) {
            [self.selectCityButton setTitle:[((CityModel *)[self.selectCityArray objectAtIndex:row]) name] forState:UIControlStateNormal];
            cityFlag = row;
            
            //更改城市后 支行置为空
            [self.banksBranchButton setTitle:@"请选择支行" forState:UIControlStateNormal];
            self.respBankCode = @"";
		}
    }
}

@end

//
//  ModifyAccountInfoViewController.m
//  YLTiPhone
//
//  Created by xushuang on 14-1-21.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "ModifyAccountInfoViewController.h"
#import "SearchBankViewController.h"
#import "ParseXMLUtil.h"
#import "BankModel.h"
#import "UITextField+HideKeyBoard.h"
#import "AreaModel.h"
#import "CityModel.h"

@interface ModifyAccountInfoViewController ()

@end

@implementation ModifyAccountInfoViewController

@synthesize receiveAcctNumTF, confirmReceiveAcctNumTF, accountInfoTF;
@synthesize bankArray, areaArray, cityArray, selectCityArray;
@synthesize selectAreaButton, selectBankButton, selectCityButton,banksBranchButton;
@synthesize actionSheet, picker;
@synthesize respBankCode, respBankName;
@synthesize receiveDic = _receiveDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  dic:(NSDictionary *)dic
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _receiveDic = [[NSDictionary alloc] initWithDictionary:dic];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"修改账户记录";
    self.hasTopView = YES;
    bankFlag = 0;
    areaFlag = 0;
    cityFlag = 0;
    
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, VIEWHEIGHT + 41)];
    [scrollView setContentSize:CGSizeMake(320, VIEWHEIGHT+200)];
    scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:scrollView];
    
    UILabel *receiveAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    receiveAccountLabel.backgroundColor = [UIColor clearColor];
    receiveAccountLabel.text = @"收款账户信息";
    receiveAccountLabel.font = [UIFont systemFontOfSize:17.0f];
    [scrollView addSubview:receiveAccountLabel];
    
    //收款人姓名输入框背景
    UIImageView *accountInfoImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 40, 304, 45)];
    [accountInfoImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [scrollView addSubview:accountInfoImage1];
    self.accountInfoTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 40, 300, 45) isLong:true];
    [self.accountInfoTF.contentTF setPlaceholder:@"收款人姓名"];
    self.accountInfoTF.contentTF.delegate = self;
    [self.accountInfoTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    [self.accountInfoTF.contentTF setKeyboardType:UIKeyboardTypeDefault];
    [self.accountInfoTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    [scrollView addSubview:self.accountInfoTF];
    
    //收款账号输入框背景
    UIImageView *textFieldImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 95, 304, 45)];
    [textFieldImage1 setImage:[UIImage imageNamed:@"textInput.png"]];
    [scrollView addSubview:textFieldImage1];
    
    self.receiveAcctNumTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 95, 300, 45) isLong:true];
    [self.receiveAcctNumTF.contentTF setPlaceholder:@"收款账号"];
    self.receiveAcctNumTF.contentTF.delegate = self;
    [self.receiveAcctNumTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    [self.receiveAcctNumTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self.receiveAcctNumTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    [scrollView addSubview:self.receiveAcctNumTF];
    
    //确认收款账号输入框背景
    UIImageView *textFieldImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 150, 304, 45)];
    [textFieldImage2 setImage:[UIImage imageNamed:@"textInput.png"]];
    [scrollView addSubview:textFieldImage2];
    
    self.confirmReceiveAcctNumTF = [[LeftTextField alloc] initWithFrame:CGRectMake(10, 150, 300, 45) isLong:true];
    [self.confirmReceiveAcctNumTF.contentTF setPlaceholder:@"确认收款账号"];
    self.confirmReceiveAcctNumTF.contentTF.delegate = self;
    [self.confirmReceiveAcctNumTF.contentTF setFont:[UIFont systemFontOfSize:15]];
    [self.confirmReceiveAcctNumTF.contentTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self.confirmReceiveAcctNumTF.contentTF hideKeyBoard:self.view:3 hasNavBar:YES];
    [scrollView addSubview:self.confirmReceiveAcctNumTF];
    
    //银行信息
    UILabel *bankInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, 300, 35)];
    bankInfoLabel.backgroundColor = [UIColor clearColor];
    bankInfoLabel.text = @"银行信息";
    bankInfoLabel.font = [UIFont systemFontOfSize:17.0f];
    [scrollView addSubview:bankInfoLabel];
    
    //选择银行下拉框
    selectBankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBankButton setFrame:CGRectMake(10, 240, 300, 45)];
    [selectBankButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    [selectBankButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectBankButton.tag = 90001;
    [selectBankButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [selectBankButton setTitle:[((BankModel *)[self.bankArray objectAtIndex:0]) name] forState:UIControlStateNormal];
    [scrollView addSubview:selectBankButton];
    
    //省份下拉框
    selectAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectAreaButton setFrame:CGRectMake(10, 295, 300, 45)];
    [selectAreaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAreaButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    selectAreaButton.tag = 90002;
    [selectAreaButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [selectAreaButton setTitle:[((AreaModel *)[self.areaArray objectAtIndex:0]) name] forState:UIControlStateNormal];
    [scrollView addSubview:selectAreaButton];
    
    //城市下拉框
    selectCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectCityButton setFrame:CGRectMake(10, 350, 300, 45)];
    [selectCityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectCityButton setBackgroundImage:[UIImage imageNamed:@"selectField_normal.png"] forState:UIControlStateNormal];
    selectCityButton.tag = 90003;
    [selectCityButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [selectCityButton setTitle:[((CityModel *)[self.selectCityArray objectAtIndex:0]) name] forState:UIControlStateNormal];
    [scrollView addSubview:selectCityButton];
    
    
    banksBranchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [banksBranchButton setFrame:CGRectMake(10, 405, 297, 42)];
    [banksBranchButton setTitle:@"请选择支行" forState:UIControlStateNormal];
    [banksBranchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    banksBranchButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [banksBranchButton addTarget:self action:@selector(selectBankButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [banksBranchButton setBackgroundImage:[UIImage imageNamed:@"selectBank_normal.png"] forState:UIControlStateNormal];
    [banksBranchButton setBackgroundImage:[UIImage imageNamed:@"selectBank_highlight.png"] forState:UIControlStateSelected];
    [banksBranchButton setBackgroundImage:[UIImage imageNamed:@"selectBank_highlight.png"] forState:UIControlStateHighlighted];
    [scrollView addSubview:banksBranchButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(10, 470, 297, 42)];
    [confirmButton setTitle:@"确认添加" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonNomal.png"] forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirmButtonPress.png"] forState:UIControlStateHighlighted];
    [scrollView addSubview:confirmButton];
    
    self.accountInfoTF.contentTF.text = [self.receiveDic objectForKey:@"mastername"];
    self.receiveAcctNumTF.contentTF.text = [self.receiveDic objectForKey:@"bankaccount"];
    self.confirmReceiveAcctNumTF.contentTF.text = [self.receiveDic objectForKey:@"bankaccount"];
    
    //下方的银行信息要不要也赋值进去? 有时间再改吧
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
    [dic setObject:@"20" forKey:@"page_size"];
    
    SearchBankViewController *searchBank = [[SearchBankViewController alloc] initWithNibName:nil bundle:nil bankDic:dic];
    searchBank.modifyAccountVC = self;
    [self.navigationController pushViewController:searchBank animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([respBankName length] == 0) {
        respBankName = @"请选择支行";
    }
    [self.banksBranchButton setTitle:respBankName forState:UIControlStateNormal];
}

-(BOOL)checkValue
{
    if([self.accountInfoTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入账户姓名"];
        return NO;
    }else if([self.receiveAcctNumTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位原支付密码"];
        return NO;
    }else if([self.confirmReceiveAcctNumTF.contentTF.text isEqualToString:@""]){
        [ApplicationDelegate showErrorPrompt:@"请输入6位新支付密码"];
        return NO;
    }else if(![self.receiveAcctNumTF.contentTF.text isEqualToString:self.confirmReceiveAcctNumTF.contentTF.text]){
        [ApplicationDelegate showErrorPrompt:@"两次新密码输入不一致"];
        return NO;
    }else if([respBankName isEqualToString:@"请选择支行"]){
        [ApplicationDelegate showErrorPrompt:@"请选择支行"];
        return NO;
    }
    return YES;
}

//修改提款银行账号
- (void)confirmButtonAction
{
    if ([self checkValue]) {
        //检查界面输入情况
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"PHONENUM"];
        [dic setObject:[UserDefaults objectForKey:MERCHANT_NAME] forKey:@"merchant_name"];
        [dic setObject:self.accountInfoTF.contentTF.text forKey:@"mastername"];
        [dic setObject:self.receiveAcctNumTF.contentTF.text forKey:@"bankaccount"];//银行卡号
        [dic setObject:[((BankModel *)[self.bankArray objectAtIndex:bankFlag]) name] forKey:@"banks"];
//        [dic setObject:[((BankModel *)[self.bankArray objectAtIndex:bankFlag]) code] forKey:@"bankno"];
        [dic setObject:self.respBankCode forKey:@"bankno"];

        [dic setObject:[((AreaModel *)[self.areaArray objectAtIndex:areaFlag]) code] forKey:@"area"];
        [dic setObject:[((CityModel *)[self.selectCityArray objectAtIndex:cityFlag]) code] forKey:@"city"];
        [dic setObject:self.respBankCode forKey:@"addr"];
        //修改提款银行账号
        [[Transfer sharedTransfer] startTransfer:@"089009" fskCmd:nil paramDic:dic];
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
            for (CityModel *model in cityArray) {
                if ([model.parentCode isEqualToString:[((AreaModel *)[self.areaArray objectAtIndex:areaFlag]) code]])
                {
                    [selectCityArray  addObject:model];
                }
            }
		}
    }else if (pickerView.tag == 30000) {
        if (selectCityArray != nil && selectCityArray.count > row) {
            [self.selectCityButton setTitle:[((CityModel *)[self.selectCityArray objectAtIndex:row]) name] forState:UIControlStateNormal];
            cityFlag = row;
		}
    }
}

@end

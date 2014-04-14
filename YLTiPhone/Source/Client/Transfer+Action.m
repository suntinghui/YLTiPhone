//
//  TransferLogicCore.m
//  POS2iPhone
//
//  Created by  STH on 1/11/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#define GENERALTRANSFER							@"GENERALTRANSFER"
#define UPLOADSIGNIMAGETRANSFER					@"UPLOADSIGNIMAGETRANSFER"

#import "Transfer+Action.h"
#import "EncryptionUtil.h"
#import "FileOperatorUtil.h"
#import "ParseXMLUtil.h"
#import "SystemConfig.h"
#import "CatalogViewController.h"
#import "BeginGuideViewController.h"
#import "TransferSuccessDBHelper.h"
#import "StringUtil.h"
#import "EncryptionUtil.h"
#import "ForgetPasswordViewController.h"
#import "SettingPasswordViewController.h"
#import "ConfirmCancelResultViewController.h"
#import "TradeDetailTableViewController.h"
#import "SettleAccountResultViewController.h"
#import "RegesterSuccessViewController.h"
#import "ReversalDBHelper.h"
#import "SuccessTransferModel.h"
#import "AnnouncementModel.h"
#import "ResultViewController.h"
#import "UploadSignImageDBHelper.h"
#import "PayResultViewController.h"
#import "DateUtil.h"
#import "PayeeAccountDBHelper.h"
#import "PayeeAccountModel.h"
#import "AnnouncementListViewController.h"
#import "TimedoutUtil.h"

#import "JSONKit.h"
#import "LoginViewController.h"

#import "UserModel.h"
#import "BankModel.h"
#import "TransferDetailModel.h"
#import "TransListViewController.h"
#import "AccountCollectCashViewController.h"
#import "SearchBankViewController.h"
#import "ComplementRegisterInfoViewController.h"
#import "RealnameLegalizeViewController.h"
#import "MerchantQueryBalanceResultViewController.h"
#import "CardBalanceResultViewController.h"
#import "CatalogViewController.h"
@implementation Transfer (Action)


- (void) transferAction:(NSString *) transferCode paramDic:(NSDictionary *) paramDic
{
    // TODO
    
    /**
    if ([transferCode isEqualToString:@"500000001"]) { // 签购单上传
        [self.transferDic setObject:nil forKey:UPLOADSIGNIMAGETRANSFER];
    } else {
        [self.transferDic setObject:nil forKey:GENERALTRANSFER];
    }
     
     **/
    
    [[Transfer sharedTransfer] startTransfer:transferCode fskCmd:nil paramDic:paramDic];
}

- (void) actionDone
{
    if ([self.transferCode isEqualToString:@"089016"]){
        //登录
        [self loginDone];
        
    } else if ([self.transferCode isEqualToString:@"089000"]) {
        //交易明细查询
        [self queryTransListDone];
        
    } else if ([self.transferCode isEqualToString:@"089001"]){ //注册
        
        if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"5"])
        {
            [ApplicationDelegate showErrorPrompt:@"该设备已被注册"];
        }
        else if([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"2"])
        {
            [ApplicationDelegate showErrorPrompt:@"用户已被注册"];
        }
        else if([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"3"])
        {
            [ApplicationDelegate showErrorPrompt:@"未检测到设备"];
        }
        else if([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"4"])
        {
            [ApplicationDelegate showErrorPrompt:@"设备未录入"];
        }
        else
        {
            
            [self registrDone];
        }
        
    } else if ([self.transferCode isEqualToString:@"089002"]) {
        //找回密码
        [self findPwdDone];
        
    } else if ([self.transferCode isEqualToString:@"089003"]){  //修改登录，支付密码
       
        if([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"2"])
        {
            [ApplicationDelegate showErrorPrompt:@"原始密码错误"];
        }
        else
        {
            [self modifyDone];
        }
        
    } else if ([self.transferCode isEqualToString:@"089004"]) {
        //公告查询
        [self getAnnounceListDone];
        
    } else if([self.transferCode isEqualToString:@"089007"]){
        //获取提款银行账号
        [self getBankAccountDone];
        
    } else if ([self.transferCode isEqualToString:@"089010"]) {
        //完善注册信息
        [self registImproveDone];
        
    } else if([self.transferCode isEqualToString:@"089013"]) {
        //获取商户注册信息
        [self getMerchantInfoDone];
        
    } else if([self.transferCode isEqualToString:@"089015"]){
        //找回密码后的设置密码界面
        [self getSetNewPwdDone];
    } else if ([self.transferCode isEqualToString:@"089020"]) {
        //实名认证
        [self authenticationDone];
        
    } else if ([self.transferCode isEqualToString:@"089011"]) {
        //获取所有支行信息
        [self getBranchBankDone];
        
    } else if ([self.transferCode isEqualToString:@"089012"]) {
        //关键字检索支行信息
        [self getBranchBankDone];
        
    } else if ([self.transferCode isEqualToString:@"089008"]) {
        //新增提款账户
        [self addBankAccountDone];
        
    } else if ([self.transferCode isEqualToString:@"089009"]) {
        //修改提款账户
        [self modifyBankAccountDone];
        
    } else if ([self.transferCode isEqualToString:@"020001"]) {
        //银行卡余额查询
        [self queryBalanceDone];
        
    } else if ([self.transferCode isEqualToString:@"020022"]) {
        //收款
        [self inputMoneyDone];
       
    } else if ([self.transferCode isEqualToString:@"080003"]) {
        //商户余额查询
        [self MerchantQueryBalaceDone];
        
    }
    else if([self.transferCode isEqualToString:@"086000"]) //add wenbin 20140322
    {
        //签到
        [self signWith8583Done];
    }else if([self.transferCode isEqualToString:@"089006"]) //add wenbin 20140322
    {
        //短信
        [self smsDone];
    }else if([self.transferCode isEqualToString:@"089018"]) //add wenbin 20140322
    {
        //版本号
        [self versionDone];
    }
    else if([self.transferCode isEqualToString:@"080002"]) //商户提款
    {
        [ApplicationDelegate gotoSuccessViewController:@"交易成功"];
    }
    else if([self.transferCode isEqualToString:@"089014"]) //签购单上传
    {
//        [ApplicationDelegate showSuccessPrompt:@"上传成功"];
    }
    else if([self.transferCode isEqualToString:@"020023"]) //消费撤销
    {
        [self ConfirmCancelDone];
    }
    else
    {
        [self transferSuccessDone];
    }
}

// 短信验证码

-(void) smsDone{
    
}

//版本号
-(void) versionDone{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                
                if ([[ApplicationDelegate topViewController] isKindOfClass:[LoginViewController class]]) {
                    [(LoginViewController*)[ApplicationDelegate topViewController]  showAlertViewUpdate:self.receDic];
                }else if ([[ApplicationDelegate topViewController] isKindOfClass:[CatalogViewController class]]) {
                    [(CatalogViewController*)[ApplicationDelegate topViewController]  showAlertViewUpdate:self.receDic];
                }
            }else{
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);

    }
}
// 查询银行卡余额
- (void) queryBalanceDone
{
    
    if (self.receDic) {
        
        CardBalanceResultViewController *resultVC = [[CardBalanceResultViewController alloc] init];
        resultVC.dic_rece = self.receDic;
        [[ApplicationDelegate topViewController].navigationController pushViewController:resultVC animated:YES];
    }else{
        [ApplicationDelegate gotoFailureViewController:@"余额查询服务器返回数据错误"];
    }
}


//修改提款账户
- (void)modifyBankAccountDone
{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                [ApplicationDelegate gotoSuccessViewController:@"修改成功"];
            }else{
                [ApplicationDelegate gotoFailureViewController:@"修改失败"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"修改失败"];
    }

}

//新增提款银行账户
- (void)addBankAccountDone
{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                [ApplicationDelegate gotoSuccessViewController:@"新增提款人账户成功"];
            }else{
                [ApplicationDelegate gotoFailureViewController:@"新增提款账户失败"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"新增提款账户失败"];
    }
}

//支行
- (void)getBranchBankDone
{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                NSString *jsonStr = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
                [self.receDic setObject:jsonStr forKey:@"apires"];
                
                NSMutableArray *arrayModel = [[NSMutableArray alloc] init];
                NSArray *jsonArray = [[self.receDic objectForKey:@"apires"] objectForKey:@"object"];
                
                if ([jsonArray count] > 0) {
                    for (int i = 0; i < [jsonArray count]; i++) {
                        NSDictionary *picsObj = [NSDictionary dictionaryWithDictionary:[jsonArray objectAtIndex:i]];
                        BankModel *model = [[BankModel alloc] init];
                        model.name = [picsObj objectForKey:@"bankbranchname"];
                        model.code = [picsObj objectForKey:@"bankbranchid"];
                        [arrayModel addObject:model];
                    }
                }
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:arrayModel forKey:@"object"];
                [dic setObject:[[self.receDic objectForKey:@"apires"] objectForKey:@"page_count"] forKey:@"page_Count"];
                //传回界面 展示内容
                ((SearchBankViewController*)[ApplicationDelegate topViewController]).bankDic = dic;
                [(SearchBankViewController*)[ApplicationDelegate topViewController] refreshTabelView];
            }else{
                [ApplicationDelegate gotoFailureViewController:@"获取支行信息失败"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"获取支行信息失败"];
    }
}

//实名认证
- (void)authenticationDone
{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                [UserDefaults setObject:@"1" forKey:IS_IDENTIFY];
                [UserDefaults synchronize];
                [ApplicationDelegate gotoSuccessViewController:@"实名认证成功"];
            }else{
                [ApplicationDelegate gotoFailureViewController:@"实名认证失败"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"实名认证功能，服务器返回异常。"];
    }
}

//公告查询
- (void)getAnnounceListDone
{
    if (self.receDic) {
        if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
            @try {
                NSString *jsonStr = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
                [self.receDic setObject:jsonStr forKey:@"apires"];
                
                NSMutableArray *arrayModel = [[NSMutableArray alloc] init];
                NSArray *jsonArray = [self.receDic objectForKey:@"apires"];
                
                if ([jsonArray count] > 0) {
                    for (int i = 0; i < [jsonArray count]; i++) {
                        NSDictionary *picsObj = [NSDictionary dictionaryWithDictionary:[jsonArray objectAtIndex:i]];
                        AnnouncementModel *model = [[AnnouncementModel alloc] init];
//                        model.branch_id = [picsObj objectForKey:@"branch_id"];不知什么用，界面没展示
                        model.notice_content = [picsObj objectForKey:@"notice_content"];
                        model.notice_title = [picsObj objectForKey:@"notice_title"];
                        model.notice_date = [picsObj objectForKey:@"notice_date"];
                        model.notice_time = [picsObj objectForKey:@"notice_time"];
                        
                        [arrayModel addObject:model];
                    }
                }
                //传回界面 展示内容
                ((AnnouncementListViewController*)[ApplicationDelegate topViewController]).announcementList = arrayModel;
                [(AnnouncementListViewController*)[ApplicationDelegate topViewController] refreshTabelView];
            }
            @catch (NSException *exception) {
            
            }
        }else if([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"0"]){

        }
    }
}

//获取提款银行账号
- (void)getBankAccountDone
{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                NSString *jsonStr = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
                [self.receDic setObject:jsonStr forKey:@"apires"];
                NSDictionary *accountDic = [self.receDic objectForKey:@"apires"];
                
                //传回界面 展示内容
                ((AccountCollectCashViewController*)[ApplicationDelegate topViewController]).accountDic = accountDic;
                [(AccountCollectCashViewController*)[ApplicationDelegate topViewController] refreshTabelView];
                
            }else{

            }
        }
    }
    @catch (NSException *exception) {
        
    }

}

//交易明细查询
- (void)queryTransListDone
{
    if (self.receDic) {
        if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
            NSString *jsonStr = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
            NSString *jsonStr1 = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
            //            NSDictionary *dic0 = [jsonStr1 objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            //            NSString *tmp0 = [dic0 objectForKey:@"page_count"];
            NSDictionary *jsonStr0 = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
            //            NSDictionary *dic = [];
            //            NSDictionary *dic_apires = [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]  options:NSJSONReadingMutableContainers error:nil]];
            
            NSString *page_count = [jsonStr0 objectForKey:@"page_count"];
            NSArray *jsonArray = [jsonStr0 objectForKey:@"object"];
            
            NSMutableArray *transModelArray = [[NSMutableArray alloc] init];
            
            if ([jsonArray count] > 0) {
                for (int i = 0; i < [jsonArray count]; i++) {
                    NSDictionary *picsObj = [NSDictionary dictionaryWithDictionary:[jsonArray objectAtIndex:i]];
                    TransferDetailModel *model = [[TransferDetailModel alloc] init];
                    model.account1 = [picsObj objectForKey:@"account1"];
                    model.amount = [NSString stringWithFormat:@"%@",[picsObj objectForKey:@"amount"]];
                    model.card_branch_id = [picsObj objectForKey:@"card_branch_id"];
                    
                    model.local_log = [picsObj objectForKey:@"local_log"];
                    model.localdate = [picsObj objectForKey:@"localdate"];
                    model.localtime = [picsObj objectForKey:@"localtime"];
                    model.snd_cycle = [picsObj objectForKey:@"snd_cycle"];
                    model.snd_log = [picsObj objectForKey:@"snd_log"];
                    
                    model.systransid = [picsObj objectForKey:@"systransid"];
                    model.rspmsg = [picsObj objectForKey:@"rspmsg"];
                    model.flag = [picsObj objectForKey:@"flag"];
                    model.account1 = [picsObj objectForKey:@"account1"];
                    
                    model.merchant_id = picsObj[@"merchant_id"];
                    model.merchant_name = picsObj[@"merchant_name"];
                    model.terminal_id = picsObj[@"terminal_id"];
                    model.note = picsObj[@"note"];
                    
                    [transModelArray addObject:model];
                }
            }
            
            //传回界面上的数据
            NSMutableDictionary *mapDic = [[NSMutableDictionary alloc] init];
            [mapDic setObject:page_count forKey:@"page_count"];
            [mapDic setObject:transModelArray forKey:@"list"];
            
            ((TransListViewController*)[ApplicationDelegate topViewController]).totalCount = page_count;
            ((TransListViewController*)[ApplicationDelegate topViewController]).array = transModelArray;
            
            //            if (((TransListViewController*)[ApplicationDelegate topViewController]).array ==nil)
            //            {
            //                ((TransListViewController*)[ApplicationDelegate topViewController]).array = [NSMutableArray arrayWithArray:transModelArray];
            //            }
            //            else
            //            {
            //                [((TransListViewController*)[ApplicationDelegate topViewController]).array addObjectsFromArray:transModelArray];
            //            }
            [(TransListViewController*)[ApplicationDelegate topViewController] refreshTabelView];
        }else{
            [(TransListViewController*)[ApplicationDelegate topViewController] refreshTabelView];
        }
    }
    
}

//获取商户注册信息
- (void)getMerchantInfoDone
{
    if (self.receDic) {
        if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
            //存到UserModel
            UserModel *tmpUserModel = [[UserModel alloc] init];
            @try {
                NSString *jsonStr = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
                [self.receDic setObject:jsonStr forKey:@"apires"];
                tmpUserModel.merchant_name = [[self.receDic objectForKey:@"apires"] objectForKey:@"merchant_name"];
                
                tmpUserModel.pid = [[self.receDic objectForKey:@"apires"] objectForKey:@"pid"];
                tmpUserModel.is_identify = [[self.receDic objectForKey:@"apires"] objectForKey:@"is_identify"];
                tmpUserModel.is_complete = [[self.receDic objectForKey:@"apires"] objectForKey:@"is_complete"];
                tmpUserModel.merchant_id = [[self.receDic objectForKey:@"apires"] objectForKey:@"is_complete"];
                
                if ([[ApplicationDelegate topViewController] isKindOfClass:[ComplementRegisterInfoViewController class]])
                {
                    [((ComplementRegisterInfoViewController*)[ApplicationDelegate topViewController]) fromLogic:tmpUserModel];
                }
                else if([[ApplicationDelegate topViewController] isKindOfClass:[RealnameLegalizeViewController class]])
                {
                    RealnameLegalizeViewController *realnameLegalController = (RealnameLegalizeViewController*)[ApplicationDelegate topViewController];
                    realnameLegalController.userModel = tmpUserModel;
                    
                }
                
                
//                [UserDefaults setObject:[[self.receDic objectForKey:@"apires"] objectForKey:@"merchant_id"] forKey:MERCHANT_ID];
//                [UserDefaults setObject:[[self.receDic objectForKey:@"apires"] objectForKey:@"merchant_name"] forKey:MERCHANT_NAME];
//                [UserDefaults setObject:[[self.receDic objectForKey:@"apires"] objectForKey:@"pid"] forKey:PID];
//                [UserDefaults setObject:[[self.receDic objectForKey:@"apires"] objectForKey:@"is_identify"] forKey:IS_IDENTIFY];
//                [UserDefaults setObject:[[self.receDic objectForKey:@"apires"] objectForKey:@"is_complete"] forKey:IS_COMPLETE];
//                [UserDefaults synchronize];
            }
            @catch (NSException *exception) {
                NSLog(@"--%@", [exception callStackSymbols]);

            }
        }else if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"0"]){

        }
    }
}

//完善注册信息
- (void)registImproveDone
{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                //已经完善了  把本地存储的修改
                [UserDefaults setObject:@"1" forKey:IS_COMPLETE];
                [UserDefaults synchronize];
                [ApplicationDelegate gotoSuccessViewController:@"注册信息已完善"];
            }else if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"0"]){
                [ApplicationDelegate gotoFailureViewController:@"操作失败"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"完善注册信息功能，服务器返回异常。"];
    }
}

//找回密码
- (void)findPwdDone
{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                NSString *jsonStr = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
                [self.receDic setObject:jsonStr forKey:@"apires"];
                //记录里面的smscode 传入下一界面设置密码
                NSString *smscode = [[self.receDic objectForKey:@"apires"] objectForKey:@"smscode"];
                SettingPasswordViewController *vc = [[SettingPasswordViewController alloc] initWithNibName:nil bundle:nil smscode:smscode];
                [[ApplicationDelegate topViewController].navigationController pushViewController:vc animated:YES];
            }else{
                [ApplicationDelegate gotoFailureViewController:@"找回密码失败,请重新尝试"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"找回密码失败,请重新尝试"];
    }
}

//设置新密码
- (void)getSetNewPwdDone
{
    @try {
        if (self.receDic) {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                [ApplicationDelegate gotoSuccessViewController:@"设置新密码成功"];
            }else{
                [ApplicationDelegate gotoFailureViewController:@"设置新密码失败"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"设置新密码失败"];
    }
}


-(void)signOutDone
{
    if (self.receDic) {
        NSLog(@"%@", self.receDic);
        [ApplicationDelegate gotoSuccessViewController:[self.receDic objectForKey:@"fieldMessage"]];
    }
}

//修改密码  修改登录密码 修改支付密码
-(void)modifyDone
{
    @try {
        if (self.receDic) {
            NSString *respmsg = [self.receDic objectForKey:@"respmsg"];
            if ([respmsg isEqualToString:@"1"]) {
                //校验mac
                [ApplicationDelegate gotoSuccessViewController:@"密码修改成功！"];
            }else if([respmsg isEqualToString:@"2"]){
                [ApplicationDelegate gotoFailureViewController:@"原始密码错误"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"修改密码功能服务器返回异常。"];
    }
}

-(void)settleDone
{
    /**
     —— 内卡结算总额，内容为：
     ● 借记总金额 N12
     ● 借记总笔数 N3
     ● 贷记总金额 N12
     ● 贷记总笔数 N3
     ● 对账应答代码 N1
     
     对账应答码 对账应答码说明
     0 ISO 保留
     1 对账平
     **/
    if (self.receDic) {
        NSString *field48 = [self.receDic objectForKey:@"field48"];
        NSString *debitAmount = [field48 substringWithRange:NSMakeRange(0, 12)];
        NSString *debitCount = [field48 substringWithRange:NSMakeRange(12, 3)];
        NSString *creditAmount = [field48 substringWithRange:NSMakeRange(15, 12)];
        NSString *creditCount = [field48 substringWithRange:NSMakeRange(27, 3)];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[self.receDic objectForKey:@"fieldMessage"] forKey:@"fieldMessage"];
        [dic setObject:[StringUtil string2SymbolAmount:debitAmount] forKey:@"debitAmount"];
        [dic setObject:debitCount forKey:@"debitCount"];
        [dic setObject:[StringUtil string2SymbolAmount:creditAmount] forKey:@"creditAmount"];
        [dic setObject:creditCount forKey:@"creditCount"];
        
//        SettleAccountResultViewController *vc = [[SettleAccountResultViewController alloc] initWithParam:dic];
//        [[ApplicationDelegate topViewController].navigationController pushViewController:vc animated:YES];
    }
}

-(void)payMoneyDone
{
    if (self.receDic) {
        NSLog(@"%@", self.receDic);
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        [array addObject:[[AppDataCenter sharedAppDataCenter].transferNameDic objectForKey:[self.receDic objectForKey:@"fieldTrancode"]]];
        [array addObject:[self.receDic objectForKey:@"field11"]];
        NSString *date =  [DateUtil formatDateString:[self.receDic objectForKey:@"field13"]];
        NSString *time =  [DateUtil formatTimeString:[self.receDic objectForKey:@"field12"]];
        NSString *dateStr = [NSString stringWithFormat:@"%@ %@",date, time];
        [array addObject:dateStr];
        [array addObject:[StringUtil formatAccountNo:[self.receDic objectForKey:@"field102"]]];
        [array addObject:[StringUtil formatAccountNo:[self.receDic objectForKey:@"field103"]]];
        [array addObject:[StringUtil string2SymbolAmount:[self.receDic objectForKey:@"field4"]]];
        [array addObject:[NSString stringWithFormat:@"%@ 元", [self.receDic objectForKey:@"fieldFee"]]];
        [array addObject:[self.receDic objectForKey:@"fieldMessage"]];
        
        PayeeAccountDBHelper *helper = [[PayeeAccountDBHelper alloc] init];
        PayeeAccountModel *model = [helper queryAccountWithAccountNo:[self.receDic objectForKey:@"field103"]];
//        NSString *phoneStr = model.phoneNo;
        
        PayResultViewController *vc = [[PayResultViewController alloc] initWithNibName:@"PayResultViewController" bundle:nil];
//        vc.dataArray = array;
//        vc.phoneStr = phoneStr ? phoneStr : @"";
        [[ApplicationDelegate topViewController].navigationController pushViewController:vc animated:YES];
    }
}

//明细查询
-(void)tradeDetailDone
{
    if (self.receDic) {
//        NSString *detail = [self.receDic objectForKey:@"detail"];
//        NSArray *array = (NSArray*)[detail componentsSeparatedByString:@"|"];
//        ((TradeDetailTableViewController*)[ApplicationDelegate topViewController]).array = array;
//        [(TradeDetailTableViewController*)[ApplicationDelegate topViewController] refreshTabelView];
    }
}

/*
-(void)tradeGatherDone
{
    if (self.receDic) {
        TradeDetailGatherTableViewController *vc = [[TradeDetailGatherTableViewController alloc] initWithNibName:@"TradeDetailGatherTableViewController" bundle:nil];
        NSString *tmpBeginDate = [self.sendDic objectForKey:@"BeginDate"];
        NSString *tmpEndDate = [self.sendDic objectForKey:@"EndDate"];
        NSString *tmpStr = [self.receDic objectForKey:@"detail"];
        NSArray *array = [tmpStr componentsSeparatedByString:@"|"];
        vc.dataArray = array;
        vc.beginString = tmpBeginDate;
        vc.endString = tmpEndDate;
        [[ApplicationDelegate topViewController].navigationController pushViewController:vc animated:YES];
    }
}
*/
- (void) transferSuccessDone
{
    if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
        [ApplicationDelegate gotoSuccessViewController:@"交易成功"];
    }else{
        [ApplicationDelegate gotoFailureViewController:@"交易失败"];
    }
}

- (void) loginDone
{
    @try {
        if (self.receDic)
        {
            
            NSString *jsonStr = [[self.receDic objectForKey:@"apires"] objectFromJSONString];
            [self.receDic setObject:jsonStr forKey:@"apires"];
            
            // 启动超时退出服务
            [[TimedoutUtil sharedInstance] start];
            
            //记录返回数据中的 md5key
            [UserDefaults setObject:[[self.receDic objectForKey:@"apires"] objectForKey:@"md5key"] forKey:MD5KEY];
            [UserDefaults synchronize];
            [AppDataCenter sharedAppDataCenter].status = [self.receDic objectForKey:@"status"];
//            [AppDataCenter sharedAppDataCenter].status = @"9";//TODO 暂时先放开限制

            
            // 登陆成功，跳转到菜单界面
            ApplicationDelegate.hasLogin = YES;
//            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
//                BeginGuideViewController *beginGuideViewController = [[BeginGuideViewController alloc] initWithNibName:nil bundle:nil];
//                [ApplicationDelegate.rootNavigationController pushViewController:beginGuideViewController animated:YES];
//            }else{
                CatalogViewController *controller = [[CatalogViewController alloc] initWithNibName:nil bundle:nil];
                [ApplicationDelegate.rootNavigationController pushViewController:controller animated:YES];
//            }
            
        
            
        } else {
            [ApplicationDelegate gotoFailureViewController:@"服务器返回异常！"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"服务器返回异常。"];
    }
    @finally {
        [UserDefaults synchronize];
    }
}

/**
 * 签到
 *
 * 当点击签到按纽后并从服务器返回JSON后执行此方法。
 *
 * 执行此方法说明服务器端签到正常，没有其他的异常情况发生。
 * 签到成功后
 * 1、首先要更新工作密钥。按长度分别切割
 * 2、然后将收款撤销表清空。
 */
/* 签到成功 服务器返回数据
 RESP DIC:{
 field11 = 000020;
 field12 = 221242;
 field13 = 0123;
 field37 = 000002985926;
 field39 = 00;
 field41 = 01200018;
 field42 = 012346866660018;
 field60 = 00000001;
 field62 = FDB6459020DBA498424CB7F3B74DB788110F33B139E7A8AFD5B278CA39E7A8AFD5B278CAE1B12F85;
 */
/*
- (void)signDone
{
     //保存field41  终端代码
     if ([self.receDic objectForKey:@"field41"]) {
         [AppDataCenter sharedAppDataCenter].__TERID = [self.receDic objectForKey:@"field41"];
     }
     //保存field42  商户代码
     if ([self.receDic objectForKey:@"field42"]) {
         [AppDataCenter sharedAppDataCenter].__VENDOR = [self.receDic objectForKey:@"field42"];
     }
     // 保存商户名称 field43 有就存
     if ([self.receDic objectForKey:@"field43"]) {
         [UserDefaults setObject:[self.receDic objectForKey:@"field43"] forKey:MERCHERNAME];
         [UserDefaults synchronize];
     }
    
    // 更新批次号
    NSString *batchNum = [[self.receDic objectForKey:@"field60"] substringWithRange:NSMakeRange(2, 6)];
    [[AppDataCenter sharedAppDataCenter] setBatchNum:batchNum];
    
    // 清空上一个批次的交易成功的信息，即用于消费撤销和查询签购单的数据库表
    TransferSuccessDBHelper *helper = [[TransferSuccessDBHelper alloc] init];
    if ([helper deleteAllTransfer]) {
        NSLog(@"更换批次后 成功 清空需清除的成功交易！");
    } else {
        NSLog(@"更换批次后清空需清除的成功交易 失败 ！");
    }
    @try {
        // 根据62域字符串切割得到工作密钥
        NSString *newKey = [[self.receDic objectForKey:@"field62"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *pinKey = nil; //(0, 40)
        NSString *macKey = nil;//newKey.substring(40, 56) + newKey.substring(72);
        NSString *stackKey = nil;//pinKey
        
        pinKey = [newKey substringWithRange:NSMakeRange(0, 40)];
        macKey = [[NSString alloc] initWithFormat:@"%@%@",[newKey substringWithRange:NSMakeRange(40, 16)],[newKey substringFromIndex:72]];
        stackKey = pinKey;
        
        // 更新工作密钥
        [[Transfer sharedTransfer] startTransfer:nil fskCmd:[NSString stringWithFormat:@"Request_ReNewKey|string:%@,string:%@,string:%@", pinKey, macKey, stackKey] paramDic:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"签到失败，请重试"];
    }
}
*/


/**
 * 签到
 *
 * 当点击签到按纽后并从服务器返回JSON后执行此方法。
 *
 * 执行此方法说明服务器端签到正常，没有其他的异常情况发生。
 * 签到成功后
 * 1、首先要更新工作密钥。按长度分别切割
 * 2、然后将收款撤销表清空。
 */
- (void)signWith8583Done
{
    /* 签到成功 服务器返回数据
     RESP DIC:{
     RESP DIC:{
     field11 = 980020;
     field12 = 134722;
     field13 = 0322;
     field37 = 000002988036;
     field39 = 00;
     field41 = 50000002;
     field42 = 500000050990002;
     field60 = 00000001;
     field62 = 588225C61B3AD0DCF9CAD0CC45D41A59236BB3D4058B0FEB124CC2DE058B0FEB124CC2DEAC977D3F;
     };
     */
    
    
    //保存field41  终端代码
    if ([self.receDic objectForKey:@"field41"]) {
        [AppDataCenter sharedAppDataCenter].__TERID = [self.receDic objectForKey:@"field41"];
    }
    //保存field42  商户代码
    if ([self.receDic objectForKey:@"field42"]) {
        [AppDataCenter sharedAppDataCenter].__VENDOR = [self.receDic objectForKey:@"field42"];
    }
    // 保存商户名称 field43 有就存
    if ([self.receDic objectForKey:@"field43"]) {
        [UserDefaults setObject:[self.receDic objectForKey:@"field43"] forKey:MERCHERNAME];
        [UserDefaults synchronize];
    }
    
    // 更新批次号
    NSString *batchNum = [[self.receDic objectForKey:@"field60"] substringWithRange:NSMakeRange(2, 6)];
    [[AppDataCenter sharedAppDataCenter] setBatchNum:batchNum];
    
    // 清空上一个批次的交易成功的信息，即用于消费撤销和查询签购单的数据库表
    TransferSuccessDBHelper *helper = [[TransferSuccessDBHelper alloc] init];
    if ([helper deleteAllTransfer]) {
        NSLog(@"更换批次后 成功 清空需清除的成功交易！");
    } else {
        NSLog(@"更换批次后清空需清除的成功交易 失败 ！");
    }
    @try {
        // 根据62域字符串切割得到工作密钥
        NSString *newKey = [[self.receDic objectForKey:@"field62"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *pinKey = nil; //(0, 40)
        NSString *macKey = nil;//newKey.substring(40, 56) + newKey.substring(72);
        NSString *stackKey = nil;//pinKey
        
        if (ApplicationDelegate.isAishua)
        {
            pinKey = [newKey substringWithRange:NSMakeRange(0, 32)];
            macKey = [[NSString alloc] initWithFormat:@"%@",[newKey substringWithRange:NSMakeRange(40, 16)]];
        }
        else
        {
            pinKey = [newKey substringWithRange:NSMakeRange(0, 40)];
            macKey = [[NSString alloc] initWithFormat:@"%@%@",[newKey substringWithRange:NSMakeRange(40, 16)],[newKey substringFromIndex:72]];
        }
        
        
        stackKey = pinKey;
        
        [AppDataCenter sharedAppDataCenter].pinKey = pinKey;
        [AppDataCenter sharedAppDataCenter].macKey = macKey;
        
        if (ApplicationDelegate.isAishua)
        {
            [AppDataCenter sharedAppDataCenter].hasSign = true;
            [ApplicationDelegate gotoSuccessViewController:@"签到成功"];
        }
        else
        {
            // 更新工作密钥
            [[Transfer sharedTransfer] startTransfer:nil fskCmd:[NSString stringWithFormat:@"Request_ReNewKey|string:%@,string:%@,string:%@", pinKey, macKey, stackKey] paramDic:nil];
 
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"签到失败，请重试"];
    }
}

// 更新工作密钥成功
- (void) updateWorkingKeyDone
{
    [ApplicationDelegate gotoSuccessViewController:@"签到成功\n\n[设备已成功更新工作密钥]"];
}

// 签退
- (void)signOffDone
{
    [ApplicationDelegate gotoSuccessViewController:[self.receDic objectForKey:@"fieldMessage"]];
}

// 注册
- (void) registrDone
{
    @try {
        //返回信息 0 注册失败 1 注册成功 2 用户已被注册
        if (self.receDic)
        {
            if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"1"]) {
                //提醒用户注册成功
                [ApplicationDelegate showText:@"注册成功，请用新账号登录"];
                
                //注册成功跳转到登录界面 让用户重新登录
                ApplicationDelegate.hasLogin = YES;
                LoginViewController *controller = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
                [ApplicationDelegate.rootNavigationController pushViewController:controller animated:YES];
            }else if([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"2"]){
                [ApplicationDelegate gotoFailureViewController:@"用户已被注册"];
            }else if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"0"]){
                [ApplicationDelegate gotoFailureViewController:@"注册失败"];
            }else if([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"3"]){
                [ApplicationDelegate gotoFailureViewController:@"未检测到设备"];
            }else if ([[self.receDic objectForKey:@"respmsg"] isEqualToString:@"4"]){
                [ApplicationDelegate gotoFailureViewController:@"设备未录入（无机构号）"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:@"服务器返回数据异常，请重试！"];
    }
}

- (void) regesterSuccessDone
{
    //跳转到注册成功页面 显示商户名称，商户号等信息
//    RegesterSuccessViewController *regesterSuccessVC = [[RegesterSuccessViewController alloc] initWithData:self.receDic];
//    [ApplicationDelegate.rootNavigationController pushViewController:regesterSuccessVC animated:YES];
}


/**
 * 收款或收款撤销成功，记录数据以备查询签购单
 */
- (void) recordSuccessTransfer
{
    SuccessTransferModel *model = [[SuccessTransferModel alloc] init];
    [model setAmount:[self.receDic objectForKey:@"field4"]];
    [model setTraceNum:[self.receDic objectForKey:@"field11"]];
    model.transCode = [self.receDic objectForKey:@"fieldTrancode"];
    [model setDate:[self.receDic objectForKey:@"field13"]];
    [model setContent:self.receDic];
    
    TransferSuccessDBHelper *helper = [[TransferSuccessDBHelper alloc] init];
    BOOL flag = [helper insertASuccessTrans:model];
    if (flag) {
        NSLog(@"交易成功并写入数据库。。。");
    } else {
        NSLog(@"交易成功但写入数据库时操作失败。。。");
    }
}


/**
 商户余额查询成功
 **/
-(void)MerchantQueryBalaceDone
{
    if (self.receDic) {
        
        MerchantQueryBalanceResultViewController *resultVC = [[MerchantQueryBalanceResultViewController alloc] init];
        resultVC.dic_rece = self.receDic;
        [[ApplicationDelegate topViewController].navigationController pushViewController:resultVC animated:YES];
    }else{
        [ApplicationDelegate gotoFailureViewController:@"余额查询服务器返回数据错误"];
    }
    
}

/**
 收款成功
 **/
-(void)inputMoneyDone
{
    if (self.receDic) {
        [self recordSuccessTransfer];
        
        ConfirmCancelResultViewController *resultVC = [[ConfirmCancelResultViewController alloc] initWithResultMessage:@"收款成功"];
        [[ApplicationDelegate topViewController].navigationController pushViewController:resultVC animated:YES];
    }else{
        [ApplicationDelegate gotoFailureViewController:@"收款交易服务器返回数据错误"];
    }
    
}

/**
 收款撤销成功
 **/
- (void) ConfirmCancelDone
{
    [self recordSuccessTransfer];
    
    TransferSuccessDBHelper *helper = [[TransferSuccessDBHelper alloc] init];
    [helper updateRevokeFalg:[[self.sendDic objectForKey:@"field61"] substringWithRange:NSMakeRange(6, 6)]];
    
    ConfirmCancelResultViewController *resultVC = [[ConfirmCancelResultViewController alloc] initWithResultMessage:@"收款撤销成功"];
    [[ApplicationDelegate topViewController].navigationController pushViewController:resultVC animated:YES];
}

/**
 冲正
 ***/
- (BOOL) reversalAction
{
#ifdef DEMO
    return NO;
#endif
    
    
    ReversalDBHelper *helper = [[ReversalDBHelper alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[helper queryTheNeedReversalTrans]];
    if (dic == nil || [dic count] == 0) {
        return false;
        
    } else {
        [ApplicationDelegate showProcess:@"正在发起冲正交易..."];
        // 更新冲正表，则冲正次数加1。
        // 注意这可能有问题，因为如果网络不通，直接没有从手机中发出交易，也已经使冲正次数发生变更
        ReversalDBHelper *DBHelper = [[ReversalDBHelper alloc] init];
        [DBHelper updateReversalCount:[dic objectForKey:@"field11"]];
        
        // 将原交易的transferCode改为对应的冲正的transferCode
        [dic setObject:[[AppDataCenter sharedAppDataCenter].reversalDic objectForKey:[dic objectForKey:@"fieldTrancode"] ] forKey:@"fieldTrancode"];
        
        [self transferAction:[dic objectForKey:@"fieldTrancode"] paramDic:dic];
        
        return true;
    }
}


/**
 * 发送短信验证码
 */
- (void) sendSMSCaptcha
{
    UIViewController *vc = [ApplicationDelegate topViewController];
    if ([vc isKindOfClass:[LoginViewController class]])
    {
        //注册界面获取验证码
//        [((LoginViewController *)vc) refreshSecurityImage:[self.receDic objectForKey:@"captcha"]];
    }
    else if ([vc isKindOfClass:[ForgetPasswordViewController class]])
    {
        //忘记密码界面获取验证码
//        [((ForgetPasswordViewController *)vc) refreshSecurityImage:[self.receDic objectForKey:@"captcha"]];
    }
}

- (void) uploadSignImageDone
{
    // TODO 服务器返回的数据竟然又将图片反传回来了。。。。
    NSString *field11 = [self.sendDic objectForKey:@"field11"];
    UploadSignImageDBHelper *helper = [[UploadSignImageDBHelper alloc] init];
    // TODO 发送短信
    NSString *receMobile = [helper queryReceMobile:field11];
    // 签购单上传成功后更新数据库
    [helper updateUploadFlagSuccess:field11];
}

- (void) uploadSignImageAction
{
    // 将相关数据写入数据库
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
//    [tempDic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__TERID"] forKey:@"field41"];
//    [tempDic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__VENDOR"] forKey:@"field42"];
    
//    [tempDic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"termMobile"];
//    [tempDic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__TERSERIALNO"] forKey:@"ReaderID"];
//    [tempDic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PSAMNO"] forKey:@"PSAMID"];
    
//    [tempDic setObject:[self.sendDic objectForKey:@"field7"] forKey:@"field7"];
//    [tempDic setObject:[[self.receDic objectForKey:@"field60"] substringWithRange:NSMakeRange(2, 6)] forKey:@"batchNum"];
    
    [tempDic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    [tempDic setObject:[self.receDic objectForKey:@"receivePhoneNo"] forKey:@"send_tel"];
    [tempDic setObject:[self.receDic objectForKey:@"field11"] forKey:@"field11"];
    
    [tempDic setObject:[self.receDic objectForKey:@"field37"] forKey:@"local_log"];
    [tempDic setObject:[self.receDic objectForKey:@"field42"] forKey:@"merchant_id"];

    [tempDic setObject:[self.receDic objectForKey:@"imei"] forKey:@"filedIMEI"];
    [tempDic setObject:[self.receDic objectForKey:@"receivePhoneNo"] forKey:@"fieldMobile"];
    [tempDic setObject:[self.receDic objectForKey:@"fieldImage"] forKey:@"img"];
    
    UploadSignImageDBHelper *helper = [[UploadSignImageDBHelper alloc] init];
    BOOL flag = [helper insertATransfer:[tempDic objectForKey:@"field11"] receMobile:[tempDic objectForKey:@"receivePhoneNo"] content:tempDic];
    NSLog(flag?@"已将签购单写入数据库，等待上传...":@"签购单写入数据库 失败！");
    
    
    // 启动线程上传签购单图片
    if (self.uploadSignImageTimer && [self.uploadSignImageTimer isValid]) {
        NSLog(@"试图开启上传签购单服务，服务已开启，运行中...");
        return;
    }
    
    self.uploadSignImageTimer = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(doUploadSignImage) userInfo:nil repeats:YES];
    // 立即触发事件
    [self.uploadSignImageTimer fire];
}

- (void) doUploadSignImage
{
    NSLog(@"正在检查签购单...");
    UploadSignImageDBHelper *helper = [[UploadSignImageDBHelper alloc] init];
    NSDictionary *dic = [helper queryAUploadSignImageTransfer];
    if (dic) {
        NSLog(@"检测到需要上传的签购单，正在发起上传...");
        [[Transfer sharedTransfer] startTransfer:@"089014" fskCmd:nil paramDic:dic];
    } else {
        NSLog(@"没有检测到需要上传的签购单，停止后台服务...");
        [self.uploadSignImageTimer invalidate];
        self.uploadSignImageTimer = nil;
    }
}

@end

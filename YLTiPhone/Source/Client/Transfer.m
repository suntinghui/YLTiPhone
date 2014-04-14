//
//  Transfer.m
//  POS2iPhone
//
//  Created by  STH on 1/16/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "Transfer.h"
#import "ParseXMLUtil.h"
#import "FieldModel.h"
#import "ReversalTransferModel.h"
#import "ReversalDBHelper.h"
#import "HttpManager.h"
#import "ReversalDBHelper.h"
#import "JSONKit.h"
#import "SystemConfig.h"
#import "Transfer+FSK.h"
#import "Transfer+Action.h"

#import "FileOperatorUtil.h"
#import "EFETConstant.h"

#import "TBXML.h"
#import "TransferModel.h"
#import "EncryptionUtil.h"
#import "SecurityUtil.h"
#import "ConvertUtil.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDDispatchQueueLogFormatter.h"

@implementation Transfer

@synthesize transferCode = _transferCode;
@synthesize fskCommand = _fskCommand;
@synthesize paramDic = _paramDic;

@synthesize sendDic = _sendDic;
@synthesize receDic = _receDic;
@synthesize jsonDic = _jsonDic;
@synthesize receData = _receData;

@synthesize m_vcom = _m_vcom;
@synthesize fskCmdArray = _fskCmdArray;
@synthesize currentFSKMethod = _currentFSKMethod;

@synthesize MKOperation = _MKOperation;
@synthesize timer = _timer;
@synthesize tempTransferCode = _tempTransferCode;
@synthesize uploadSignImageTimer = _uploadSignImageTimer;
@synthesize nextViewController = _nextViewController;

@synthesize asyncSocket = _asyncSocket;
@synthesize reqData = _reqData;
@synthesize action = _action;

@synthesize transferModel = _transferModel;

static Transfer *instance = nil;

+ (Transfer *) sharedTransfer
{
    @synchronized(self)
    {
        if (nil == instance) {
            instance = [[Transfer alloc] init];
        }

    }
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    
    return nil;
}

- (id)init
{
    if (self = [super init]) {
        _transferCode = nil;
        _fskCommand = nil;
        _paramDic = nil;
        
        _sendDic = [[NSMutableDictionary alloc] init];
        _receDic = [[NSMutableDictionary alloc] init];
        _jsonDic = [[NSMutableDictionary alloc] init];
        _receData = [[NSData alloc] init];
        
//        _asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
//        [_asyncSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
    return self;
}

- (void) startTransfer:(NSString *)transCode fskCmd:(NSString *) fskCmd paramDic:(NSDictionary *) dic
{
    // print打印指令是特例，没有网络的时候也要打印
    if (![ApplicationDelegate checkNetAvailable] && ![@"Print" isEqualToString:fskCmd]) {
        return ;
    }
    
    if ([[transCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        transCode = nil;
    }
    
    if ([[fskCmd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        fskCmd = nil;
    }
    
    self.nextViewController = nil;
    
    _paramDic = dic;
    
    self.tempTransferCode = transCode;
    
    if (self.tempTransferCode) {
        _transferCode = transCode;
    }
    
    if (fskCmd) {
        _fskCommand = fskCmd;
        
        [self fskAction];
        
        return;
    }
    
    if (transCode) {
        [self packet];
    }
}
- (NSString *)actionString:(NSString *)transCode
{
    if ([self.transferCode isEqualToString:@"089000"]){
        //交易流水
        return @"queryTransList";
    }else if ([self.transferCode isEqualToString:@"089001"]) {
        //注册
        return @"registMerchant";
    }else if ([self.transferCode isEqualToString:@"089002"]) {
        //找回密码
        return @"checkInfo";
    }else if ([self.transferCode isEqualToString:@"089003"]) {
        //修改密码
        return @"modifyPassword";
    }else if ([self.transferCode isEqualToString:@"089004"]) {
        //公告查询
        return @"getNotice";
    }else if ([self.transferCode isEqualToString:@"089005"]) {
        //签购单上传
        return @"uploadSalesSlip";
    }else if ([self.transferCode isEqualToString:@"089006"]) {
        //短信验证码
        return @"sms";
    }else if ([self.transferCode isEqualToString:@"089007"]) {
        //获取提款银行账号
        return @"getBanks";
    }else if ([self.transferCode isEqualToString:@"089008"]) {
        //新增提款银行账号
        return @"addBanks";
    }else if ([self.transferCode isEqualToString:@"089009"]) {
        //修改提款银行账号
        return @"modifyBanks";
    }else if ([self.transferCode isEqualToString:@"089010"]) {
        //完善注册信息
        return @"completeMerchant";
    }else if ([self.transferCode isEqualToString:@"089011"]) {
        //得到所有支行
        return @"getBanksBranch";
    }else if ([self.transferCode isEqualToString:@"089012"]) {
        //关键字检索支行
        return @"getBanksBranchByName";
    }else if ([self.transferCode isEqualToString:@"089013"]) {
        //完善注册信息
        return @"getMerchantInfo";
    }else if ([self.transferCode isEqualToString:@"089014"]) {
        //上传签购单
        return @"uploadSalesSlip";
    }else if ([self.transferCode isEqualToString:@"089015"]) {
        //找回密码操作完成后的 设置密码界面
        return @"getPassword";
    }else if ([self.transferCode isEqualToString:@"089016"]) {
        //登录
        return @"login";
    }else if ([self.transferCode isEqualToString:@"089017"]) {
        //找回密码操作完成后的 设置密码界面
        return @"getPassword";
    }else if ([self.transferCode isEqualToString:@"089018"]) {
        //版本号
        return @"getVersion";
    }else if ([self.transferCode isEqualToString:@"089020"]) {
        //实名认证
        return @"identifyMerchant";
    }
    
    return nil;
}

- (void) startTransfer:(NSString *)transCode fskCmd:(NSString *) fskCmd paramDic:(NSDictionary *) paramDic nextVC:(UIViewController*)nextVC
{
    [self startTransfer:transCode fskCmd:fskCmd paramDic:paramDic];
    
    if (nextVC) {
        self.nextViewController = nextVC;
    }
}

- (void) packet
{
    // 弹出等待信息
    //[self performSelectorOnMainThread:@selector(showTransferProcess) withObject:nil waitUntilDone:NO];
//    [self showTransferProcess];
    
    [self.jsonDic removeAllObjects];
    [self.sendDic removeAllObjects];
    
    NSLog(@"正在拼装报文...");
    
    @try {
        self.transferModel = [ParseXMLUtil parseConfigXML:self.transferCode];
        NSArray *fieldArray = self.transferModel.fieldModelArray;
        
        if (fieldArray == nil || [fieldArray count] == 0) {
            [ApplicationDelegate gotoFailureViewController:[NSString stringWithFormat:@"应用程序加载文件出错，重新登陆(%@)", self.transferCode]];
            return;
        }
        
        // 在报文的配置中，有可能值来自于本报文中某一个域的值，为了检索的效率，在tempMap中将已解析的值存储，在后面用到时直接在tmepMap中查找
        // 取本报文的值用$做前缀，此时一定要注意，取此值时，前面一定要已经有这个域的值
        
//        NSMutableString *mabStr = [[NSMutableString alloc] init];
//        NSMutableString *macStr = [[NSMutableString alloc] init];
        NSMutableString *tmp_mac = [[NSMutableString alloc] init];
        
        //是否应该先判断isjson
        
        for (FieldModel *field in fieldArray)
        {
            NSLog(@"field %@",field.key);
            NSMutableString *tempStr = [[NSMutableString alloc] init];
            
            NSArray *values = [[field value] componentsSeparatedByString:@"#"];
            for (NSString *value in values)
            {
                if ([value hasPrefix:@"$"])
                {
                    // 如果报文中某一域的值取自此报文的其他域的值，其值规定为将key的首末用'$'做前后缀
                    // for example：field60  - 012#__PASMNO#$field11$
                    if ([self.sendDic objectForKey:[value substringWithRange:NSMakeRange(1, [value length]-2)]])
                    {
                        [tempStr appendString:[self.sendDic objectForKey:[value substringWithRange:NSMakeRange(1, [value length]-2)]]];
                    }
                    else
                    {
                        NSLog(@"conf_req_%@.xml WRONG , Set the value of '%@' before setting the value of '%@' !!!",self.transferCode, field.value, [value substringWithRange:NSMakeRange(1, [value length]-2)]);
                    }
                    
                }else if ([value hasPrefix:@"__"]){
                    // 首先检查此值是否来自界面输入，冲正则来自数据库
                    if (nil != self.paramDic && [self.paramDic objectForKey:[value substringFromIndex:2]]){
                        [tempStr appendString:[self.paramDic objectForKey:[value substringFromIndex:2]]];
                    }else{
                        // 如果不是来自界面，那么就在AppDataCenter中寻找这个值。
                        [tempStr appendString:[[AppDataCenter sharedAppDataCenter] getValueWithKey:value]];
                    }
                }else{
                    // 如果不带下划线则直接将值拼装。
                    [tempStr appendString:value];
                }
            }
            
            [field setValue:tempStr];
            
            // 进行一步特殊处理，fieldImage为上传签购单的图片内容，一般为20-30K。我认为在其他地方不会使用该值，所以不在map中保存。
            //TODO img被注释 by wenbin 20140411
            if ( /*![field.key isEqualToString:@"img"] && */![field.key isEqualToString:@"macstr"]) {
                [self.sendDic setObject:field.value forKey:field.key];
            }
  
            //通过fieldTrancode 可以判断发送到服务器的action
            if (![field.key isEqualToString:@"fieldTrancode"] &&/* ![field.key isEqualToString:@"img"] &&*/ ![field.key isEqualToString:@"macstr"])
            {
                [self.jsonDic setObject:field.value forKey:field.key];
            }
            
            //json 计算mac的字段
            if ([field.key isEqualToString:@"macstr"])
            {
                //macstr 中value为类似 tel,smscode 按照“,”截取这个字符串 取出value = key的value
                tmp_mac = (NSMutableString *)field.value;
            }
            
            // 判断是否有参与mac计算的域
//            if (field.macField)
//            {
//                [mabStr appendFormat:@"%@;", field.key];
//                [macStr appendString:(field.value ? field.value : @"")];
//            }
        }
        
        if (![ApplicationDelegate checkNetAvailable])
        {
            return ;
        }
        
        
        if ([[[AppDataCenter sharedAppDataCenter] reversalDic] objectForKey:self.transferCode]) {
            // 如果该交易需要进行冲正，则将其记入数据库冲正表中。注意，这里可能会有问题，因为有可能网络不通，直接打回，也就是说没有从手机发出交易就需要进行充正。
            ReversalTransferModel *model = [[ReversalTransferModel alloc] init];
            [model setTraceNum:[self.sendDic objectForKey:@"field11"]];
            [model setDate:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__YYYY-MM-DD"]];
            [model setContent:self.sendDic];
            
            ReversalDBHelper *helper = [[ReversalDBHelper alloc] init];
            [helper insertATransfer:model];
        }
        
        //走 json
        if ([self.transferModel.isJson isEqualToString:@"true"]){
            [self.sendDic removeAllObjects];
            NSMutableString *macString = [[NSMutableString alloc] init];
            if ([self.transferModel.shouldMac isEqualToString:@"true"]) {
                //计算mac
                NSArray *jsonArray =[tmp_mac componentsSeparatedByString:NSLocalizedString(@",", nil)];//拆分成数组
                NSLog(@"#####%@",jsonArray);
                for (int i=0; i<[jsonArray count]; i++) {
                    [macString appendString:[self.jsonDic objectForKey:[jsonArray objectAtIndex:i]]];
                }
                //去掉空格，逗号，中文
                [macString appendString:[UserDefaults objectForKey:MD5KEY]];
            }
            //把 jsonDic中的数据转换格式 变为json格式
//            NSLog(@"%@", [self.jsonDic JSONString]);
            NSLog(@"------%@", [self DataTOjsonString:self.jsonDic]);
            [self.sendDic setObject:[self.jsonDic JSONString] forKey:@"arg"];
            if (![tmp_mac isEqualToString:@""]) {
                [self.sendDic setObject:[EncryptionUtil MD5Encrypt:macString] forKey:@"mac"];
            }
            [self sendPacket];
        }
        //走8583
        else
        {
            NSLog(@"EFET...");
            NSLog(@"sendDic:%@",self.sendDic);
            self.action = [[TxActionImp alloc] init];
            _reqData = [self.action first:self.sendDic withXMLData:[FileOperatorUtil getDataFromXML:ApplicationDelegate.isAishua?@"msg_config_aishua.xml":@"msg_config.xml"]];
           
            
            if ([self.transferModel.shouldMac isEqualToString:@"true"]) {// 需要进行MAC计算
                if (ApplicationDelegate.isAishua) {
                    NSData *randomData = [ConvertUtil parseHexToByteArray:[AppDataCenter sharedAppDataCenter].__RANDOM];
                    NSLog(@"random--- %@", [AppDataCenter sharedAppDataCenter].__RANDOM);
                    NSData *macData = [ConvertUtil parseHexToByteArray:[AppDataCenter sharedAppDataCenter].macKey];
                    NSString *macKeyStr = [SecurityUtil encryptUseDES:randomData key:macData];
                    
                    NSData *tmpData = [_reqData subdataWithRange:NSMakeRange(13, _reqData.length-13-8)];
                    NSString *tmpString = [ConvertUtil data2HexString:tmpData];
                    
                    NSData *macValueData = [SecurityUtil encryptXORAndMac:tmpString withKey:macKeyStr];
                    
                    NSMutableData *sendData = [[NSMutableData alloc] init];
                    [sendData appendData:[_reqData subdataWithRange:NSMakeRange(0, _reqData.length-8)]];
                    [sendData appendData:macValueData];
                    self.reqData = [NSData dataWithData:sendData];
                    
                    [self sendRequestEFET];
                    
                } else {
                    NSMutableData *data = [[NSMutableData alloc] init];
                    NSData *tempByte = [_reqData subdataWithRange:NSMakeRange(1,19)];
                    [data appendData:[_reqData subdataWithRange:NSMakeRange(11,tempByte.length)]];
                    [data appendData:tempByte];
                    
                    NSString *bitmapHexStr = [[data description] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSLog(@"进行MAC计算bitmapHexStr:%@",bitmapHexStr);
                    // 进行MAC计算
                    [self startTransfer:nil fskCmd:[NSString stringWithFormat:@"Request_GetMac|string:%@", bitmapHexStr] paramDic:nil];
                }
            }
            else {
                [self sendPacket];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", exception);
        NSLog(@"--%@", [exception callStackSymbols]);
        [ApplicationDelegate gotoFailureViewController:[NSString stringWithFormat:@"%@", exception]];
    }
}


-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
//json 连服务器 发送数据 接收数据
- (void) sendPacket
{
    if ([self.transferModel.isJson isEqualToString:@"true"]){
        self.MKOperation = [[HttpManager sharedHttpManager] transfer:self.sendDic
                                                      successHandler:^(NSDictionary *respDic)
                            {
                                [self.timer invalidate];
                                [ApplicationDelegate hideProcess];
                                
                                self.receDic = [NSMutableDictionary dictionaryWithDictionary:respDic];
                                
                                 //TODO add by wenbin 20140311
                                [self.receDic setObject:self.transferCode forKey:@"fieldTrancode"];
                                
                                [self parseJson];
                            }
                                                        errorHandler:^(NSError *error)
                            {
                                [self.timer invalidate];
                                [ApplicationDelegate hideProcess];
                                
                                NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                      [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                            }
                                                        actionString:[self actionString:self.transferCode]
                            ];
    
    }else{
        //8583
        
        _reqData = [self.action first:self.sendDic withXMLData:[FileOperatorUtil getDataFromXML:ApplicationDelegate.isAishua?@"msg_config_aishua.xml":@"msg_config.xml"]];
     
        
        [self setReqData:_reqData];
        [self sendRequestEFET];
    }
}

//Json 返回数据解析
- (void) parseJson
{
    //在这处理json字符串是不是好些?
    @try {
        //如果resmsg 是1 则交易成功 返回0则失败
        if ( ![[self.receDic objectForKey:@"respmsg"] isEqualToString:@"0"])
        {
            
            if ([self.transferModel.shouldMac isEqualToString:@"true"])
            {
                //此处校验MAC好一些吧
                //取出返回报文中的 macstr 加上md5key 进行MD5加密 结果与返回值中得mac比较 相同则成功
                NSMutableString *macstrPlasMd5key = [[NSMutableString alloc] init];
                [macstrPlasMd5key appendString:[self.receDic objectForKey:@"macstr"]];
                [macstrPlasMd5key appendString:[UserDefaults objectForKey:MD5KEY]];
                NSString *md5str = [EncryptionUtil MD5Encrypt:macstrPlasMd5key];
                if ([md5str isEqualToString:[self.receDic objectForKey:@"mac"]])
                {
                    [self actionDone];
                }
            }
            else{
                [self actionDone];
            }
            
        }
        else{

            if ([self.transferCode isEqualToString:@"089014"]) //签购单上传特殊处理 不弹出到错误页面
            {
            }
            else
            {
                [ApplicationDelegate showErrorPrompt:@"获取数据出错，请重新尝试!"];
            }
            


        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", exception);
        NSLog(@"--%@", [exception callStackSymbols]);
        
        [ApplicationDelegate gotoFailureViewController:@"服务器返回数据有误，请重试。"];
    }
}

//8583部分
- (void) parse
{
    NSLog(@"正在解析服务器响应报文...");
    @try {
        
#ifdef DEMO
        [self checkField39];
        return ;
#endif
        
        // 如果是上传签购单交易,则特殊处理
        if ([self.transferCode isEqualToString:@"089014"]) {
            if ([[self.receDic objectForKey:@"field39"] isEqualToString:@"00"]) {
                // TODO
                [self uploadSignImageDone];
            }
        }
        else
        {
            if ([self.transferModel.shouldMac isEqualToString:@"true"])
            {
                if(ApplicationDelegate.isAishua){
                    NSData *randomData = [ConvertUtil parseHexToByteArray:[AppDataCenter sharedAppDataCenter].__RANDOM];
                    NSLog(@"randon: %@", [AppDataCenter sharedAppDataCenter].__RANDOM);
                    NSData *macData = [ConvertUtil parseHexToByteArray:[AppDataCenter sharedAppDataCenter].macKey];
                    NSString *macKeyStr = [SecurityUtil encryptUseDES:randomData key:macData];
                    
                    NSData *tmpData = [_receData subdataWithRange:NSMakeRange(11, _receData.length-11-8)];
                    NSString *tmpString = [ConvertUtil data2HexString:tmpData];
                    
                    NSData *macValueData = [SecurityUtil encryptXORAndMac:tmpString withKey:macKeyStr];
                    
                    NSString *macStr = [ConvertUtil data2HexString:macValueData];

                    NSString *tmp_str = [ConvertUtil stringFromHexString:macStr];
//                    [[NSString alloc] initWithData:macData encoding:NSUTF8StringEncoding];
                    if ([tmp_str isEqualToString:[_receDic objectForKey:@"field64"]]) {
                        [self checkField39];
                    }else{
                        [ApplicationDelegate gotoFailureViewController:@"MAC校验失败"];
                    }
                    
                    
                    
                }else{
                    NSMutableData *data = [[NSMutableData alloc] init];
                    NSData *tempByte = [self.receData subdataWithRange:NSMakeRange(1,19)];
                    [data appendData:[self.receData subdataWithRange:NSMakeRange(11,tempByte.length)]];
                    [data appendData:tempByte];
                    
                    NSString *bitmapHexStr = [[data description] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [self startTransfer:nil fskCmd:[NSString stringWithFormat:@"Request_CheckMac|string:%@,string:%@", bitmapHexStr, [self.receDic objectForKey:@"field64"]] paramDic:nil];
    
                }
                
//                byte[] tempByte = new byte[respByte.length - 8 - 11];
//                System.arraycopy(respByte, 11, tempByte, 0, tempByte.length);
//                CheckMacHandler checkHandler = new CheckMacHandler();
//                FSKOperator.execute("Get_CheckMAC|int:0,int:0,string:null,string:" + StringUtil.bytes2HexString(tempByte) + ",string:" + receiveFieldMap.get("field64"), checkHandler);// 计算MAC的数据+MAC（8字节）
            }
            else
            {
                [self checkField39];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"--%@", exception);
        NSLog(@"--%@", [exception callStackSymbols]);
        
        [ApplicationDelegate gotoFailureViewController:@"服务器返回数据有误，请重试。"];
    }
    
}

- (void) checkField39
{
    if ([self.receDic objectForKey:@"field39"])
    {
        NSString *field39 = [self.receDic objectForKey:@"field39"];
        
        // 收到应答后，如果此交易是一笔可能发冲正的交易且响应码不是98，则删除冲正表中的此条交易记录
        if (![field39 isEqualToString:@"98"] && [[AppDataCenter sharedAppDataCenter].reversalDic objectForKey:self.transferCode]) {
            ReversalDBHelper *helper = [[ReversalDBHelper alloc] init];
            [helper deleteAReversalTrans:[self.receDic objectForKey:@"field11"]];
        }
        
        if ([field39 isEqualToString:@"00"]) {
            // 只有在交易成功的时候取服务器日期
            if ([self.receDic objectForKey:@"field13"]) {
                [[AppDataCenter sharedAppDataCenter] setServerDate:[self.receDic objectForKey:@"field13"]];
            }
            
            if ([[AppDataCenter sharedAppDataCenter].reversalDic.allValues containsObject:self.transferCode]) {
                // 交易成功。如果这笔交易是冲正交易，则要更新冲正表，将这笔交易的状态置为冲正成功。
                ReversalDBHelper *helper = [[ReversalDBHelper alloc] init];
                [helper updateReversalState:[self.receDic objectForKey:@"field11"]];
            }
            
            [self actionDone];
            
        } else if ([field39 isEqualToString:@"98"]){
            // 当39域为98时要冲正。98 - 银联收不到发卡行应答
            [ApplicationDelegate gotoFailureViewController:@"没有收到发卡行应答"];
            [self reversalAction];
            
        } else {
            // 39域不为00，交易失败，跳转到交易失败界面。其它失败情况比如MAC计算失败直接弹窗提示用户重新交易。
            // 如果是点付宝出现异常，将在点付宝逻辑内直接处理掉
            [ApplicationDelegate gotoFailureViewController:[self failMessageOfField39:field39]];
        }
        
    } else {
        [ApplicationDelegate gotoFailureViewController:@"服务器返回数据异常(39)"];
    }
}

- (void) showTransferProcess
{
    NSString *message = [self getProcessMessage];
    
    if (message)
    {
        counter = 0;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProcess) userInfo:message repeats:YES];
    }
}

- (void) updateProcess
{
    if (counter++ < [SystemConfig sharedSystemConfig].maxTransferTimeout)
    {
        [ApplicationDelegate showProcess:[NSString stringWithFormat:@"%@ %02ld s", self.timer.userInfo, (long)counter]];
        
    } else {
        [self.timer invalidate];
        
        if (self.MKOperation) {
            [self.MKOperation cancel];
            self.MKOperation = nil;
        }
        
        if ([[[AppDataCenter sharedAppDataCenter] reversalDic] objectForKey:self.transferCode]){
            [ApplicationDelegate gotoFailureViewController:@"交易超时"];
            [self reversalAction];
        } else if ([[[AppDataCenter sharedAppDataCenter] reversalDic].allValues containsObject:self.transferCode]) {
            [ApplicationDelegate gotoFailureViewController:@"冲正超时"];
        } else {
            [ApplicationDelegate gotoFailureViewController:@"交易超时，请重试"];
        }
    }
}

- (NSString *) getProcessMessage
{
    NSString *waittingMsg = @"正在处理交易...";
    
    if ([[[AppDataCenter sharedAppDataCenter].reversalDic allValues] indexOfObject:self.transferCode] != NSNotFound) {
        waittingMsg = @"正在进行冲正...";
    } else if([self.transferCode isEqualToString:@"086000"]){
        waittingMsg = @"正在登录...";
    } else if ([self.transferCode isEqualToString:@"500000001"]){
        waittingMsg = nil;
    } else if ([self.transferCode isEqualToString:@"999000003"]){
        waittingMsg = @"正在获取验证码...";
    }
    return waittingMsg;
}

- (void) sendRequestEFET
{
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *err = nil;
    
    if (![self.asyncSocket connectToHost:IP onPort:PORT error:&err])
	{
		NSLog(@"Unable to connect to due to invalid configuration: %@", err);
	}
	else
	{
		NSLog(@"Connecting to \"%@\" on port %d...", IP, PORT);
	}
    
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"socket:didConnectToHost:%@ port:%d", IP, PORT);
    
    NSLog(@"REQ_Data:%@", self.reqData);
    
    [self.asyncSocket writeData:self.reqData withTimeout:-1 tag:0];
    
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:didWriteDataWithTag:");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [ApplicationDelegate hideProcess];
    
    NSLog(@"EFET收到响应...");
    NSLog(@"RESP:%@", data);
    
    NSData *contentData = [data subdataWithRange:NSMakeRange(2, data.length-2)];
    
    self.receData = contentData;
    self.receDic = [NSMutableDictionary dictionaryWithDictionary:[self.action afterProcess:contentData]];
    
    //TODO add by wenbin 20140311
    [self.receDic setObject:self.transferCode forKey:@"fieldTrancode"];
    
    [self parse];
    [ApplicationDelegate hideProcess];
    
    [self.asyncSocket readDataWithTimeout:-1 tag:0];

}

/*
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	// Since we requested HTTP/1.0, we expect the server to close the connection as soon as it has sent the response.
	
	NSLog(@"socketDidDisconnect:withError: \"%@\"", err);
}
 */

#pragma mark - end AsyncSocketDelegate

- (NSString *) failMessageOfField39:(NSString *)field39
{
    NSString *str_error = @"交易失败，请重试!";
    if ([field39 isEqualToString:@"A0"]) {
        str_error = @"校验错，请重新签到！";
    }else if ([field39 isEqualToString:@"A1"]) {
        str_error = @"A1";
    }else if([field39 caseInsensitiveCompare:@"xx"] == NSOrderedSame){
        str_error = [_receDic objectForKey:@"field63"];
    }else {
        int field = [[NSString stringWithFormat:@"%@",field39] intValue];
        switch (field) {
            case 03:
                str_error = @"商户未登记";
                break;
            case 04:
            case 07:
            case 34:
            case 37:
            case 41:
            case 43:
                str_error = @"没收卡,请联系收单行";
                break;
            case 13:
                str_error = @"交易金额超限,请重试";
                break;
            case 14:
                str_error = @"无效卡号,请联系发卡行";
                break;
            case 31:
            case 15:
                str_error = @"此卡不能受理";
                break;
            case 22:
                str_error = @"操作有误,请重试";
                break;
            case 33:
            case 54:
                str_error = @"过期卡,请联系发卡行";
                break;
            case 35:
                str_error = @"非会员卡或会员信息错";
                break;
            case 36:
                str_error = @"非会员卡,不能做此交易";
                break;
            case 38:
                str_error = @"密码错误次数超限";
                break;
            case 55:
                str_error = @"密码错,请重试";
                break;
            case 58:
                str_error = @"终端无效,请联系收单行或银联";
                break;
            case 61:
                str_error = @"金额太大";
                break;
            case 65:
                str_error = @"超出取款次数限制";
                break;
            case 67:
                str_error = @"没收卡";
                break;
            case 68:
                str_error = @"交易超时,请重试";
                break;
            case 75:
                str_error = @"密码错误次数超限";
                break;
            case 77:
                str_error = @"请向网络中心签到";
                break;
            case 79:
                str_error = @"POS 终端重传脱机数据";
                break;
            case 01:
            case 02:
            case 05:
            case 06:
            case 19:
            case 20:
            case 21:
            case 23:
            case 25:
            case 39:
            case 40:
            case 42:
            case 44:
            case 52:
            case 53:
            case 56:
            case 57:
            case 59:
            case 60:
            case 62:
            case 63:
            case 64:
            case 93:
                str_error = @"交易失败，请联系发卡行！";
                break;
            case 9:
            case 12:
            case 30:
            case 90:
            case 91:
            case 92:
            case 94:
            case 95:
            case 96:
            case 98:
                str_error = @"交易失败，请重试!";
                break;
            case 51:
                str_error = @"余额不足,请查询";
                break;
            case 99:
                str_error = @"校验错，请重新签到！";
                break;
            case 97:
                str_error = @"终端未登记,请联系收单行或银联";
                break;
            default:
                return @"未知错误，请重试";
                break;
        }
    }
    return [NSString stringWithFormat:@"%@(%@)", str_error, field39];
}
@end

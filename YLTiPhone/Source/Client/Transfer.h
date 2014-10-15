//
//  Transfer.h
//  POS2iPhone
//
//  Created by  STH on 1/16/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

//XS 20140110修改 增加了8583内容
#import <Foundation/Foundation.h>
#import <voclib/vcom.h>
#import "MKNetworkKit.h"
#import "TxActionImp.h"
#import "GCDAsyncSocket.h"
#import "ICSwiper.h"

@class TransferModel;

@interface Transfer : NSObject <GCDAsyncSocketDelegate>
{
    NSString                *_transferCode;
    NSString                *_fskCommand;
    NSDictionary            *_paramDic;
    
    NSMutableDictionary     *_sendDic;
    NSMutableDictionary     *_receDic;
    NSData                  *_receData;
    
    //add by xs 20140116 为了拼发送到服务器中 arg下的json串
    NSMutableDictionary     *_jsonDic;
    
    MKNetworkOperation      *_MKOperation;
    NSTimer                 *_timer;
    NSInteger               counter;
    
    // Transfer+FSK
    vcom                    *_m_vcom;
    NSMutableArray          *_fskCmdArray; // NSInvocation
    NSString                *_currentFSKMethod;
    
    NSString                *_tempTransferCode; // 这个代码不及格，以后要改成block实现
    
    NSTimer                 *_uploadSignImageTimer;
    
    //20140110添加8583部分
    TxActionImp             *_action;
    GCDAsyncSocket             *_asyncSocket;
    NSData                  *_reqData;
    
    TransferModel           *_transferModel;
     BOOL                   isSpecialTrade;
}
@property (nonatomic, strong)TransferModel                  *transferModel;

@property (nonatomic, strong, readonly) NSString            *transferCode;
@property (nonatomic, strong, readonly) NSString            *fskCommand;
@property (nonatomic, strong, readonly) NSDictionary        *paramDic;

@property (nonatomic, strong) NSMutableDictionary           *sendDic;
@property (nonatomic, strong) NSMutableDictionary           *receDic;
@property (nonatomic, strong) NSMutableDictionary           *jsonDic;
@property (nonatomic, strong) NSData                        *receData;

@property (nonatomic, strong) vcom                          *m_vcom;
@property (nonatomic, strong) NSMutableArray                *fskCmdArray;
@property (nonatomic, strong) NSString                      *currentFSKMethod;

@property (nonatomic, strong) MKNetworkOperation            *MKOperation;

@property (nonatomic, strong) NSTimer                       *timer;

@property (nonatomic, strong) NSString                      *tempTransferCode;

@property (nonatomic, strong) NSTimer                       *uploadSignImageTimer;

@property (nonatomic, strong) UIViewController              *nextViewController; //跳转的ViewController  

@property (nonatomic, strong) TxActionImp                   *action;
@property (nonatomic, strong) GCDAsyncSocket                *asyncSocket;
@property (nonatomic, strong) NSData                        *reqData;

+ (Transfer *) sharedTransfer;

- (void) startTransfer:(NSString *)transCode fskCmd:(NSString *) fskCmd paramDic:(NSDictionary *) paramDic;
- (void) startTransfer:(NSString *)transCode fskCmd:(NSString *) fskCmd paramDic:(NSDictionary *) paramDic nextVC:(UIViewController*)nextVC;
- (void) packet;
- (void) parse;
- (void) parseJson;
- (void) sendPacket;
- (void) checkField39;
//取得action
- (NSString *)actionString:(NSString *)transCode;
@end

//
//  ZftZXBS.h
//  ZftZXBS
//
//  Created by rjb on 13-8-1.
//  Copyright (c) 2013年 rjb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


static const int SUCCESS=0;//执行成功
static const int SYSTEM_BUSY=10100;//硬件正在工作中
static const int GET_DEVICE_INFO_FAIL = 10101;// 获取设备信息失败
static const int CRC_SEND_ERROR = 10102;// CRC错误（SDK发送的数据硬件解析不匹配）
static const int CRC_RCV_ERROR =  10119;// CRC接收错误（SDK检查硬件发的消息CRC错误）
static const int COMMAND_NOT_IMPLEMENTED = 10103;// 命令未执行
static const int SECRET_KEY_IS = 10104;// 密钥已经存在
static const int PARAMETER_IS_ERROR = 10105;// 参数错误
static const int SECRET_KEY_NO = 10106;// 密钥不存在
static const int ENCRYPT_FAIL = 10107;// 加密失败
static const int NOT_SWIPE_CARD = 10108;// 未刷卡
static const int SWIPE_CARD_FAIL = 10109;// 刷卡失败
static const int NOT_OPEN_DEVICE = 10110;// 没有调用打开刷卡接口
static const int UNKNOW_ERROR = 10111;// 未知错误
static const int DEVICE_IS_OPEN = 10112;// 刷卡器已打开(已经调用03命令不可以再次调用，终端不会执行这条指令)
static const int NOT_SWIPER_LISTENER=10113;//未启动刷卡监听
static const int PARAM_ERROR_NOT_ENOUGH_LENGTH = 10114;//参数长度不够
static const int RECV_DATA_NOT_ENOUGH = 10115;  //接受数据长度不够
static const int RECV_DATA_ERROR = 10116;//将接受数据错误
static const int ERR_DEVICE_UNKOWN   = 10117; //设备没初始化
static const int ERROR_TERMINAL_TYPE_NOT_SUPPORT = 10118; //中断不支持此接口
static const int ENCRYPT_BUSY = 10122;//正在加密
static const int CARD_FAULT = 10120;//IC卡没有插好
static const int SWIPING_TIME_OUT = 10121 ;//刷卡超时
static const int SEND_MSG_ERR    =  10130; //发送失败



@protocol SwiperDelegate <NSObject>

@required
/**
 *  刷卡器插入后的回调
 */
- (void)onPlugin;

/**
 *  刷卡器拔出后的回调
 */
- (void)onPlugout;

/**
 *  发生错误的回调
 *
 *  @param errCode 错误码
 */
- (void)onError:(NSString *)errCode;

/**
 *  获得IC卡插入后的回调
 *
 *  @param status YES表示IC卡已插入设备
 */
- (void)onGetSCardStatus:(BOOL)status;

/**
 *  获得磁条卡卡号的回调
 *
 *  @param accNo 磁条卡卡号
 */
- (void)onCardNum:(NSString *)accNo;

/**
 *  获得磁条卡卡磁信息和分散因子的回调
 *
 *  @param encTrack 卡磁信息
 *  @param factor 分散因子
 */
- (void)onCardDataTrack2:(NSString *)encTrack2 andTrack3:(NSString *)encTrack3 andFactor:(NSString *)factor;

/**
 *  获得设备信息的回调
 *
 *  @param Adc     设备电量
 *  @param devType 设备类型
 *  @param devId   设备ID
 *  @param devTag  设备标示
 */
- (void)onDeviceInfo:(NSInteger)Adc andDevType:(NSString*)devType anddevId:(NSString*)devId anddevtag:(NSString*)devTag;

/**
 *  更新秘钥的回调
 *
 *  @param code    0表示更新成功 -2表示更新失败
 */
- (void)onCheckKey:(NSInteger)code;

// 获得PIN的回调
- (void)onGetPINBlock:(NSString*)PIN_Block;

/**
 *  获得IC卡卡号的回调
 *
 *  @param cardNum IC卡卡号
 */
- (void)onICCard:(NSString *)cardNum;

/**
 *  获得55域数据的回调
 *
 *  @param Message_55 55域数据信息
 */
- (void)onGET55Message:(NSString *)Message_55;

/**
 *  获得非55域数据的回调
 *  @param cardNum 卡号
 *  @param sqn 序列号
 *  @param encTrack 卡磁
 */
- (void)onGETNO55Message:(NSString *)cardNum andCRDSQN:(NSString *)sqn andencTrack:(NSString *)encTrack;
@end



@interface ZftZXBS : NSObject
/**
 *  sdk单例
 *
 *  @return 单例
 */
+(ZftZXBS *)getInstance;

/**
 *  检测是否插入刷卡器
 *
 *  @return 插入返回YES,否则返回NO
 */
+(BOOL)ispluged;

/**
 *  设置代理
 *
 *  @param lister 遵循代理的对象
 */
-(void) setListener:(id<SwiperDelegate>)lister;

/**
 *  发送获得设备信息指令
 *
 *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
 */
- (NSInteger)getDeviceInfo;

/**
 *  发送请求刷卡指令
 *
 *  @param factor 分散因子
 *
 *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
 */
- (NSInteger)requestSwipeCard:(NSString*)factor;

/**
 *  取消刷卡
 *
 *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
 */
- (NSInteger)SwiperCardCancel;

/**
 *  发送更新秘钥的指令
 *
 *  @param TDK TDK
 *  @param PinKey Pin
 *  @param MacKey Mac
 *
 *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
 */
- (NSInteger)Change_KeyWithKey1:(NSString*)TDK andKey2:(NSString *)PinKey andKey3:(NSString *)MacKey;

/**
 *  发送获取PIN的指令
 *
 *  @param pin pin
 *
 *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
 */
- (NSInteger)GetPinBlock:(NSString*)pin;

/**
 *  发送获得非55域的指令
 *
 *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
 */
-(NSInteger)getIcCardNo55Data;

/**
 *  发送获得IC卡55域数据的指令
 *
 *  @param amount    交易金额
 *  @param transdate 交易日期
 *  @param type      交易类型
 *  @param time      交易时间时分秒
 *
 *  @return 指令是否发送给设备，发送成功返回0，否则返回错误码;
 */
-(NSInteger)getIcCard55DataWithAmount:(NSString *)amount Transdate :(NSString *)transdate Type:(NSString *)type TransTime:(NSString *)time;

/**
 *  获得SDK版本号
 *
 *  @return SDK版本号
 */
+ (NSString *)getSDKVersion;
@end

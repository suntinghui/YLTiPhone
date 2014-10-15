#import <Foundation/Foundation.h>

#define I_ERROR                   -1      //提供errorMsg，描述错误原因
#define I_ERROR_FAIL_TO_START     -2      //CSwiperController创建失败
#define I_ERROR_FAIL_TO_GET_KSN   -3      //取ksn失败
#define I_CRC_CHECK_FAIL          -4      //CRC校验和错误
#define I_ACK_FAIL                -5      //ACK应答错误

typedef enum {
    I_DECODE_SWIPE_FAIL = 0,              //刷卡失败.接受到这个错误提示用户再刷卡即可,不需要做其他处理.
    I_DECODE_CRC_ERROR,                   //CRC 错误
    I_DECODE_COMM_ERROR,                  //通信错误
    I_DECODE_UNKNOWN_ERROR,               //未知错误
} IDecodeResult;

@protocol ICSwiperStateChangedListener

//通知监听器刷卡器插入手机
- (void)onReturnDevicePlugged;

//通知监听器刷卡器已从手机拔出
- (void)onReturnDeciceUnplugged;

//通知监听器控制器CSwiperController正在搜索刷卡器
- (void)onReturnWaitingForDevice;

//通知监听器没有刷卡器硬件设备
- (void)onReturnNoDeviceDetected;

//通知监听器可以进行刷卡动作
- (void)onReturnWaitingForCardSwipe;

//通知监听器检测到刷卡动作
- (void)onReturnCardSwipeDetected;

//通知监听器开始解析或读取卡号、磁道等相关信息
- (void)onReturnDecodingStart;

//提供errorMsg，描述错误原因
- (void)onReturnError:(int)errorCode ErrorMsg:(NSString *)errorMsg;

//通知监听器控制器CSwiperController的操作被中断
- (void)onReturnInterrupted;

//通知监听器控制器CSwiperController的操作超时(超出预定的操作时间，30秒)
- (void)onReturnTimeout;

//解析卡号、磁道信息等数据出错时，回调此接口
- (void)onReturnDecodeError:(IDecodeResult)decodeResult;

//通知监听器解码刷卡器输出数据完毕
- (void)onReturnDecodeCompleted:(NSString *)formatID          //此参数保留
                      Ksn:(NSString *)ksn               //刷卡器设备编码
                EncTracks:(NSData *)encTracks           //加密的磁道资料
             Track1Length:(int)track1Length             //磁道1的长度
             Track2Length:(int)track2Length             //磁道2的长度
             Track3Length:(int)track3Length             //磁道3的长度
             RandomNumber:(NSData *)randomNumber        //加密时产生的随机数
                MaskedPAN:(NSString *)maskedPAN         //基本账号号码。
               ExpiryDate:(NSString *)expiryDate        //到期日，格式YYMM
           CardHolderName:(NSString *)cardHolderName    //持卡人姓名
                      Mac:(NSString *)mac;              //mac值

@end

typedef enum {
    //控制器CSwiperController刚被创建，等待连接刷卡器设备
    I_STATE_IDLE = 0,
    
    //控制器CSwiperController开始检测设备，如果检测不到就提示信息，重置状态至空闲（Idle）状态
    I_STATE_WAITING_FOR_DEVICE,
    
    //当控制器CSwiperController侦测到刷卡设备，监测到刷卡动作后，刷卡器开始读取卡信息。
    //如果超过等待时间（30秒），控制器CSwiperController将报出超时错误 ,然后将刷卡器状态返回 到空闲（Idle）状态。
    I_STATE_RECORDING,
    
    //当刷卡动作被侦听到后，进入到解码状态，控制器CSwiperController将开始解码刷卡设备的输出数据，
    //返回解读到的数据给刷卡状态监视器CSwiperStateChangedListener，然后将状态重置为空闲（Idle）状态。
    I_STATE_DECODING,
} ICSwiperControllerState;

@interface ICSwiperController : NSObject

@property (nonatomic, assign) id<ICSwiperStateChangedListener> delegate;

+ (ICSwiperController *)shareInstance;

//删除控制器CSwiperController，释放资源
+ (void)deleteCSwiper;

//启动刷卡器，仅当空闲Idle状态调用，否则
//抛出IIIegalStateException异常。(阻塞模式)
- (void)startCSwiper;

//启动刷卡
- (void)startCSwiper:(int)ctrlmode Random:(Byte[])random AppendData:(Byte[])appenddata Time:(int)time;

//这个命令可以向刷卡器发送指令,使刷卡器进入刷卡状态以后接受到该指令退出刷卡状态,进入IDLE状态.
- (void)stopCSwiper;

//获取刷卡器的ksn号, 放回KSN,(阻塞模式)
- (NSString *)getKsn;

//返回当前控制器CSwiperController的状态。
- (ICSwiperControllerState)getCSwiperState;

//返回true ，能检测到设备
//返回false，检测不到设备
- (BOOL)isDevicePresent;

@end

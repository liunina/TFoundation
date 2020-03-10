//
//  TPreferences.h
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//
// 该类仅提供APP内部偏好设置的模板

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPreferences : NSObject

+ (instancetype)sharedInstance;

/// 程序冷启动调用该函数
/// @param launchOptions 启动选项参数
- (BOOL)applicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

//每个版本软件安装时间
- (NSTimeInterval)getInstallDate;
- (void)setInstallDate;

- (BOOL)hasShouldGuidd;
- (void)setHasGuide;

//版本提示每天时间
- (BOOL)hasShowAppVersionUpdate;
- (void)setShowAppUpdateDate;

//软件版本号
- (void)setAppVersion:(NSString *)version;
- (NSString *)getAppVersion;

//推送权限判断提示
- (BOOL)hasShowAppPushAlert;
- (void)setShowPushAlertDate;
//设备推送令牌devicetoken
- (void)setAppPushDeviceToken:(NSString *)deviceToken;
- (NSString *)getAppPushDeviceToken;

// 是否有新消息
- (void)setAppDidReceiveMessage:(BOOL)state;
- (BOOL)getAppDidReceiveMessage;

// 设置app 进入后台的时间
- (void)setAppEffectiveTime:(NSDate *)time;
- (NSDate *)getAppEffectiveTime;
@end

NS_ASSUME_NONNULL_END

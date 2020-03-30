//
//  TLogger.h
//  TFoundation
//
//  Created by liu nian on 2020/3/30.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

///	ddLogLevel可依照需要设置为:DDLogLevelError / DDLogLevelWarning / DDLogLevelInfo / DDLogLevelDebug / DDLogLevelOff

//static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

extern int const ddLogLevel;

#define TLogError(...) DDLogError(@"%@",[NSString stringWithFormat:__VA_ARGS__]);
#define TLogWarn(...) DDLogWarn(@"%@",[NSString stringWithFormat:__VA_ARGS__]);
#define TLogInfo(...) DDLogInfo(@"%@",[NSString stringWithFormat:__VA_ARGS__]);
#define TLogDebug(...) DDLogDebug(@"%@",[NSString stringWithFormat:__VA_ARGS__]);
#define TLogVerbose(...) DDLogVerbose(@"%@",[NSString stringWithFormat:__VA_ARGS__]);

typedef void(^TLogUploadFileBlock)(NSString *logFilePath);

typedef enum : NSUInteger {
    TLogLevelError = 0,
    TLogLevelWarn,
    TLogLevelInfo,
    TLogLevelDebug,
    TLogLevelOff
} TLogLevel;

typedef enum : NSUInteger {
    TLogFrequencyYear = 0,
    TLogFrequencyMonth,
    TLogFrequencyWeek,
    TLogFrequencyDay,
} TLogFrequency;

@interface TLogger : NSObject
/// 自定义格式
@property (nonatomic, strong, nullable) id<DDLogFormatter> logFormatter;
/// 自定义文件日志格式
@property (nonatomic, strong, nullable) id<DDLogFormatter> fileLogFormatter;

/// instance
+ (instancetype)sharedInstance;

/// 开启日志文件系统, 默认日志文件保存1个月
- (void)setLogFileEnabled:(BOOL)LogFileEnabled;

/// 开启自定义日志文件系统
/// @param direct 日志文件文件夹地址
/// @param freshFrequency 日志刷新频率
- (void)enableFileLogSystemWithDirectory:(NSString *)direct
					   freshTimeInterval:(TLogFrequency)freshFrequency;

/// 获取当前的日志文地址 *注意日志文件名称含有空格
- (NSString *)logFilePath;

/// 删除日志文件, 注意调用删除日志文件的方法后, 要在下次启动才会产生新的日志文件
- (BOOL)clearFileLog;

/// 停止所有Log系统, 并清除日志文件
- (void)stopLog;

/// 上传Log文件, 注意日志文件名称含有空格
/// @param uploadBlock 上传的Block
- (void)uploadLogFileWithBlock:(TLogUploadFileBlock)uploadBlock;

/// 设置定期上传文件, 不会立即发送 注意日志文件名称含有空格
/// @param uploadBlock 上传文件的block
/// @param uploadFrequency 上传频率
- (void)uploadLogFileWithBlock:(TLogUploadFileBlock)uploadBlock
                 withFrequency:(TLogFrequency)uploadFrequency;

/// log 错误信息
/// @param message message description
- (void)logEror:(NSString *)message;

/// log 警告信息
/// @param message message description
- (void)logWarn:(NSString *)message;

/// log 普通信息
/// @param message message description
- (void)logInfo:(NSString *)message;

/// log 调试信息
/// @param message message description
- (void)logDebug:(NSString *)message;

/// log 调试信息
/// @param message message description
- (void)logVerbose:(NSString *)message;
@end

NS_ASSUME_NONNULL_END

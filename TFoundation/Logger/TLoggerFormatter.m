//
//  TLoggerFormatter.m
//  TFoundation
//
//  Created by liu nian on 2020/3/30.
//

#import "TLoggerFormatter.h"

@implementation TLoggerFormatter

#pragma mark - DDLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
  	NSString *logLevel; // 日志等级
	switch (logMessage->_flag) {
		case DDLogFlagError : logLevel = @"❗️❗️❗️"; break;
		case DDLogFlagWarning : logLevel = @"⚠️"; break;
		case DDLogFlagInfo : logLevel = @"ℹ️"; break;
		case DDLogFlagDebug : logLevel = @"🔧"; break;
		default : logLevel = @"🚩"; break;
	}
    
    NSString *logFileName = logMessage -> _fileName; // 文件名
    NSString *logFunction = logMessage -> _function; // 方法名
    NSUInteger logLine = logMessage -> _line;        // 行号
    NSString *logMsg = logMessage->_message;         // 日志消息
    
    // 日志格式：日志等级 文件名 方法名 (line:行数) 日志消息
    return [NSString stringWithFormat:@"%@ %@ %@(line:%lu)\n%@\n",logLevel, logFileName, logFunction, logLine, logMsg];
}
@end

@interface TLoggerFileFormatter () {
	int loggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end

@implementation TLoggerFileFormatter

- (instancetype)init {
    if((self = [super init])) {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [threadUnsafeDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
    }
    return self;
}

#pragma mark - DDLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"Error   "; break;
        case DDLogFlagWarning  : logLevel = @"Warning "; break;
        case DDLogFlagInfo     : logLevel = @"Info    "; break;
        case DDLogFlagDebug    : logLevel = @"Debug   "; break;
        default                : logLevel = @"Default "; break;
    }
    
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->_timestamp)];
    NSString *logMsg = logMessage->_message;
    
    return [NSString stringWithFormat:@"[ %@ %@ ] \n%@", logLevel, dateAndTime, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    loggerCount++;
    NSAssert(loggerCount <= 1, @"This logger isn't thread-safe");
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    loggerCount--;
}

@end


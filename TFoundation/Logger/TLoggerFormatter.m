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

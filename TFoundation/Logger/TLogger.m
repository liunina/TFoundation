//
//  TLogger.m
//  TFoundation
//
//  Created by liu nian on 2020/3/30.
//

#import "TLogger.h"
#import "TLoggerFormatter.h"
#import "TLoggerFileFormatter.h"
#import "TLoggerFields.h"

#ifdef DEBUG
       int const ddLogLevel = DDLogLevelVerbose;
#else
       int const ddLogLevel = DDLogLevelOff;
#endif

static NSString *keyTLogLastUploadTimeInterval = @"TLogLastUploadTimeInterval";
@interface TLogger ()
@property (nonatomic, copy) TLogUploadFileBlock uploadBlock;
@property (nonatomic, strong) DDFileLogger *fileLogger;
@property (nonatomic, assign) TLogFrequency uploadFrequency;
@property (nonatomic, assign) NSTimeInterval lastUploadTimeInterval;
@property (nonatomic, assign) BOOL LogFileEnabled;
@property (nonatomic, assign) double logFreshTimer;
@end

@implementation TLogger
@synthesize logFormatter = _logFormatter;
@synthesize fileLogFormatter = _fileLogFormatter;

- (instancetype)init {
	self = [super init];
	if (self) {
		[DDLog addLogger:[DDASLLogger sharedInstance]]; //add log to Apple System Logs
		[DDLog addLogger:[DDTTYLogger sharedInstance]]; //add log to Xcode console
		[DDTTYLogger sharedInstance].logFormatter = self.logFormatter;
		self.lastUploadTimeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:keyTLogLastUploadTimeInterval] ? [[NSUserDefaults standardUserDefaults] doubleForKey:keyTLogLastUploadTimeInterval] : 0;
	}
	return self;
}

+ (instancetype)sharedInstance {
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (void)setLogFileEnabled:(BOOL)LogFileEnabled {
	_LogFileEnabled = LogFileEnabled;
	if (LogFileEnabled) {
		[self enableFileLogSystem];
	}else {
		[self clearFileLog];
		[DDLog removeLogger:_fileLogger];
	}
}

- (void)enableFileLogSystem {
    _LogFileEnabled = YES;
    _fileLogger = [[DDFileLogger alloc] init];
    _fileLogger.rollingFrequency = 60 * 60 * 24 * 30;
    //_fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
	_fileLogger.logFormatter = self.fileLogFormatter;
    [DDLog addLogger:_fileLogger];
}

/**
 开启自定义文件系统
 
 @param direct 日志文件夹
 @param freshFrequency 日志刷新时间
 */
- (void)enableFileLogSystemWithDirectory:(NSString *)direct
					   freshTimeInterval:(TLogFrequency)freshFrequency {
    
    _LogFileEnabled = YES;
	DDLogFileManagerDefault *logFileManager;
    logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:direct];
    _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    
    switch (freshFrequency) {
        case TLogFrequencyYear:
            _logFreshTimer = 60 * 60 * 24 * 365;
            break;
        case TLogFrequencyMonth:
            _logFreshTimer = 60 * 60 * 24 * 30;
            break;
        case TLogFrequencyWeek:
            _logFreshTimer = 60 * 60 * 24 * 7;
            break;
        case TLogFrequencyDay:
            _logFreshTimer = 60 * 60 * 24;
            break;
        default:
            _logFreshTimer = 60 * 60 * 24 * 30;
            break;
    }

    _fileLogger.rollingFrequency = _logFreshTimer;
    //_fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:_fileLogger];
}

- (NSString *)logFilePath {
    if (_LogFileEnabled && _fileLogger) {
        return _fileLogger.currentLogFileInfo.filePath;
    } else {
        return nil;
    }
}

- (BOOL)clearFileLog {
    if ([self logFilePath].length > 1) {
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        [fileManager removeItemAtPath:[self logFilePath] error:&error];
        if (!error) {
            return true;
        } else {
            return false;
        }
    }
    return true;
}

- (void)stopLog {
    [self clearFileLog];
    _LogFileEnabled = NO;
    [DDLog removeAllLoggers];
}

- (void)uploadLogFileWithBlock:(TLogUploadFileBlock)uploadBlock {
    if ([self logFilePath].length > 1 && _LogFileEnabled) {
        uploadBlock([self logFilePath]);
    }
}

- (void)uploadLogFileWithBlock:(TLogUploadFileBlock)uploadBlock
                 withFrequency:(TLogFrequency)uploadFrequency {
    self.uploadBlock     = uploadBlock;
    self.uploadFrequency = uploadFrequency;
	
    if (_LogFileEnabled) {
        if (!self.lastUploadTimeInterval) {
            //获取当前的时间戳
            self.lastUploadTimeInterval = [[NSDate date] timeIntervalSince1970];
            //存储时间戳
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setDouble:self.lastUploadTimeInterval forKey:keyTLogLastUploadTimeInterval];
        }
        
        NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
        
        NSInteger days;
        switch (uploadFrequency) {
            case TLogFrequencyYear:
                days = 365;
                break;
            case TLogFrequencyMonth:
                days = 30;
                break;
            case TLogFrequencyWeek:
                days = 7;
                break;
            case TLogFrequencyDay:
                days = 1;
                break;
            default:
                break;
        }
        
        if (currentTimeInterval - self.lastUploadTimeInterval > 60 * 60 * 24 * days) {
            [self uploadLogFileWithBlock:uploadBlock];
        }
    }
}

- (void)logEror:(NSString *)message {
    DDLogError(@"%@", message);
}

- (void)logWarn:(NSString *)message {
    DDLogWarn(@"%@", message);
}

- (void)logInfo:(NSString *)message {
    DDLogInfo(@"%@", message);
}

- (void)logDebug:(NSString *)message {
    DDLogDebug(@"%@", message);
}

- (void)logVerbose:(NSString *)message {
    DDLogVerbose(@"%@", message);
}

#pragma mark - getter & setter
- (void)setLogFormatter:(id<DDLogFormatter>)logFormatter {
	_logFormatter = logFormatter;
	[DDTTYLogger sharedInstance].logFormatter = self.logFormatter;
}

- (void)setFileLogFormatter:(id<DDLogFormatter>)fileLogFormatter {
	_fileLogFormatter = fileLogFormatter;
	[self enableFileLogSystem];
}

- (id<DDLogFormatter>)logFormatter {
	if (!_logFormatter) {
		_logFormatter = [[TLoggerFormatter alloc] init];
	}
	return _logFormatter;
}

- (id<DDLogFormatter>)fileLogFormatter {
	if (!_fileLogFormatter) {
		TLoggerFields *loggerFields = [[TLoggerFields alloc] init];
		_fileLogFormatter = [[TLoggerFileFormatter alloc] initWithLoggerFieldsDelegate:loggerFields];
	}
	return _fileLogFormatter;
}
@end


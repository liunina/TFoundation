//
//  TLoggerFileFormatter.h
//  TFoundation
//
//  Created by liu nian on 2020/3/30.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TLoggerFieldsDelegate
- (NSDictionary *)loggerFieldsToIncludeInEveryLogStatement;
@end

///	文件系统格式
@interface TLoggerFileFormatter : NSObject <DDLogFormatter>
@property (nonatomic, assign) BOOL alwaysIncludeRawMessage;
- (instancetype)initWithLoggerFieldsDelegate:(id<TLoggerFieldsDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END

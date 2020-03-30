//
//  TLoggerFormatter.h
//  TFoundation
//
//  Created by liu nian on 2020/3/30.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

/// 开发模式格式
@interface TLoggerFormatter : NSObject <DDLogFormatter>
@end

///	文件系统格式
@interface TLoggerFileFormatter : NSObject <DDLogFormatter>
@end
NS_ASSUME_NONNULL_END

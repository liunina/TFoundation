//
//  TFoundationLogging.h
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//

#import <TFoundation/TFoundation+Options.h>

#if TF_LOGGING_DISABLED

#define TFLogError(frmt, ...) ((void)0)
#define TFLogWarn(frmt, ...) ((void)0)
#define TFLogInfo(frmt, ...) ((void)0)
#define TFLogDebug(frmt, ...) ((void)0)
#define TFLogVerbose(frmt, ...) ((void)0)

#else

#ifndef TF_LOGGING_CONTEXT
#define TF_LOGGING_CONTEXT 0
#endif

#if __has_include("CocoaLumberjack.h") || __has_include("CocoaLumberjack/CocoaLumberjack.h")
    #define TF_LOG_LEVEL_DEF (DDLogLevel)[TFoundation loggingLevel]
    #define CAST (DDLogFlag)
    #import <CocoaLumberjack/CocoaLumberjack.h>
#else
    #define TF_LOG_LEVEL_DEF [TFoundation loggingLevel]
    #define LOG_ASYNC_ENABLED YES
    #define CAST
    #define LOG_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, ...) \
        do                                                        \
        {                                                         \
            if ((lvl & flg) == flg)                               \
            {                                                     \
                NSLog(frmt, ##__VA_ARGS__);                       \
            }                                                     \
        } while (0)
#endif

#define TFLogError(frmt, ...) LOG_MAYBE(NO, TF_LOG_LEVEL_DEF, CAST TFoundationLoggingMaskError, TF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define TFLogWarn(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, TF_LOG_LEVEL_DEF, CAST TFoundationLoggingMaskWarn, TF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define TFLogInfo(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, TF_LOG_LEVEL_DEF, CAST TFoundationLoggingMaskInfo, TF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define TFLogDebug(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, TF_LOG_LEVEL_DEF, CAST TFoundationLoggingMaskDebug, TF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define TFLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, TF_LOG_LEVEL_DEF, CAST TFoundationLoggingMaskVerbose, TF_LOGGING_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#endif

//
//  TFoundation+Options.h
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//

#import <TFoundation/TFoundationInternal.h>

NS_ASSUME_NONNULL_BEGIN

///	 Defines "levels" of logging that will be used as values in a bitmask that filters log messages.
typedef NS_ENUM (NSUInteger, TFoundationLoggingMask) {
    /** Log all errors */
    TFoundationLoggingMaskError = 1 << 0,

    /** Log warnings, and all errors */
    TFoundationLoggingMaskWarn = 1 << 1,

    /** Log informative messagess, warnings and all errors */
    TFoundationLoggingMaskInfo = 1 << 2,

    /** Log debugging messages, informative messages, warnings and all errors */
    TFoundationLoggingMaskDebug = 1 << 3,

    /** Log verbose diagnostic information, debugging messages, informative messages, messages, warnings and all errors */
    TFoundationLoggingMaskVerbose = 1 << 4,
};

///	Defines a mask for logging that will be used by to filter log messages.
typedef NS_ENUM (NSUInteger, TFoundationLoggingLevel) {
    /** Don't log anything */
    TFoundationLoggingLevelOff = 0,

    /** Log all errors and fatal messages */
    TFoundationLoggingLevelError = (TFoundationLoggingMaskError),

    /** Log warnings, errors and fatal messages */
    TFoundationLoggingLevelWarn = (TFoundationLoggingLevelError | TFoundationLoggingMaskWarn),

    /** Log informative, warning and error messages */
    TFoundationLoggingLevelInfo = (TFoundationLoggingLevelWarn | TFoundationLoggingMaskInfo),

    /** Log all debugging, informative, warning and error messages */
    TFoundationLoggingLevelDebug = (TFoundationLoggingLevelInfo | TFoundationLoggingMaskDebug),

    /** Log verbose diagnostic, debugging, informative, warning and error messages */
    TFoundationLoggingLevelVerbose = (TFoundationLoggingLevelDebug | TFoundationLoggingMaskVerbose),

    /** Log everything */
    TFoundationLoggingLevelAll = NSUIntegerMax
};


@interface TFoundation (Options)

+ (NSString *)keyChainIdentity;
+ (void) setKeyChainIdentity:(NSString *)keyChainIdentity;

+ (nullable NSString *)keychainGroup;
+ (void) setKeychainGroup:(nullable NSString *)keychainGroup;

/// Logging Levels
+ (TFoundationLoggingLevel) loggingLevel;

/// Sets the logging mask set for TFoundation in the current application.
/// @param level Any value from TFoundationLogLevel
+ (void) setLoggingLevel:(TFoundationLoggingLevel)level;

@end

NS_ASSUME_NONNULL_END

//
//  TFoundation+Options.m
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//

#import "TFoundation+Options.h"

#ifdef DEBUG
static TFoundationLoggingLevel kTFoundationLoggingLevel = TFoundationLoggingLevelDebug;
#else
static TFoundationLoggingLevel kTFoundationLoggingLevel = TFoundationLoggingLevelError;
#endif
static NSString *kTFoundationKeyChainIdentity = nil;
static NSString *kTFoundationKeychainGroup = nil;

@implementation TFoundation (Options)

#pragma mark - Configuration Options

+ (NSString *)keyChainIdentity {
    return kTFoundationKeyChainIdentity;
}

+ (void) setKeyChainIdentity:(NSString *)keyChainIdentity; {
    kTFoundationKeyChainIdentity = keyChainIdentity;
}

+ (NSString *) keychainGroup {
    return kTFoundationKeychainGroup;
}

+ (void) setKeychainGroup:(NSString *)keychainGroup {
	if (keychainGroup) {
		kTFoundationKeychainGroup = keychainGroup;
	}
}

+ (TFoundationLoggingLevel)loggingLevel {
    return kTFoundationLoggingLevel;
}

+ (void) setLoggingLevel:(TFoundationLoggingLevel)level {
    kTFoundationLoggingLevel = level;
}

@end

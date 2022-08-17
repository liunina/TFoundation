//
//  TFoundation+Options.m
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//

#import "TFoundation+Options.h"

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
@end

//
//  TFoundation+Options.h
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//

#import <TFoundation/TFoundationInternal.h>

NS_ASSUME_NONNULL_BEGIN
@interface TFoundation (Options)

+ (NSString *)keyChainIdentity;
+ (void) setKeyChainIdentity:(NSString *)keyChainIdentity;

+ (nullable NSString *)keychainGroup;
+ (void) setKeychainGroup:(nullable NSString *)keychainGroup;

@end

NS_ASSUME_NONNULL_END

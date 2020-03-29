//
//  TKeychain.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * _Nonnull const T_KEYCHAIN_GUUID;
//trader里头的DeviceCodeNotEncrypt
UIKIT_EXTERN NSString * _Nonnull const T_KEYCHAIN_DEVICECODE;
UIKIT_EXTERN NSString * _Nonnull const T_KeyChainUserToken;
UIKIT_EXTERN NSString * _Nonnull const T_KeyChainSignatureKey;
UIKIT_EXTERN NSString * _Nonnull const T_KEYCHAIN_DEVICETOKEN;//设备推送token

#define T_KEYCHAIN_DICT_ENCODE_KEY_VALUE @"T_KEYCHAIN_DICT_ENCODE_KEY_VALUE"

NS_ASSUME_NONNULL_BEGIN

@interface TKeychain : NSObject
+ (instancetype)sharedInstance;

+ (void)setKeychainValue:(id<NSCopying, NSObject>)value forType:(NSString *)type;
+ (id)getKeychainValueForType:(NSString *)type;
+ (void)reset;
@end

NS_ASSUME_NONNULL_END

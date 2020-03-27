//
//  TDeviceAbility.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TDeviceAbility : NSObject

+ (instancetype)sharedInstance;

/// 功能:获取IP地址
- (NSString *)getIPAddress;

/// 功能:获取mac地址
- (NSString *)getHWAddress;

@end

NS_ASSUME_NONNULL_END

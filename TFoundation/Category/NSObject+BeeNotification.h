//
//  NSObject+BeeNotification.h
//  TFoundation
//
//  Created by liu nian on 2020/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BeeNotification)

/// 处理处理通知
/// @param notification notification
- (void)handleNotification:(NSNotification *)notification;

/// 注册通知
/// @param name 通知名称
- (void)observeNotification:(NSString *)name;

/// 取消注册通知
/// @param name 通知名称
- (void)unobserveNotification:(NSString *)name;

/// 取消注册的所有通知
- (void)unobserveAllNotifications;

- (void)postNotification:(NSString *)name;

- (void)postNotification:(NSString *)name withObject:(NSObject * _Nullable)object;

- (void)postNotification:(NSString *)name withObject:(NSObject * _Nullable)object userInfo:(NSDictionary * _Nullable)info;
@end

NS_ASSUME_NONNULL_END

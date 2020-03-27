//
//  TUserDefault.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUserDefault : NSObject

/// 存储数据到userdefault
/// @param anObject 数据
/// @param aKey 标识
+ (void)setValue:(id)anObject forKey:(NSString *)aKey;

/// 从userdefault获取数据
/// @param aKey 标识
+ (id)getValueForKey:(NSString *)aKey;

/// 存储 bool 值
/// @param value 数据
/// @param aKey key
+ (void)setBool:(BOOL)value forKey:(NSString *)aKey;

/// 从userdefault获取数据
/// @param aKey key
+ (BOOL)getBoolValueForKey:(NSString *)aKey;
@end

NS_ASSUME_NONNULL_END

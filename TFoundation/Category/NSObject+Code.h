//
//  NSObject+Code.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Runtime
@interface NSObject (Runtime)

/// 获取对象的所有属性
- (NSArray *)getProperties;
@end

#pragma mark - Coder
@interface NSObject (Coder)

/// 快捷从归档恢复方法
/// @param aDecoder aDecoder
- (id)otsDecodeWithCoder:(NSCoder *)aDecoder;

/// 快捷归档方法
/// @param aCoder aDecoder
- (void)otsEncodeWithCoder:(NSCoder *)aCoder;
@end

#pragma mark - JsonToVO
@interface NSObject (JsonToVO)

/// 通过dicdtionary获取其中的VO对象的名称
/// @param dic 字典
+ (NSString *)classNameWithDictionary:(NSDictionary *)dic;

/// 通过一个NSDictionary类型的数据构造一个VO类对象
/// @param dictionaryValue 字典
- (id)initWithMyDictionary:(NSDictionary *)dictionaryValue;

/// 解析数组里面的对象
/// @param array 数组
+ (NSMutableArray *)setListWithArray:(NSMutableArray *)array;

///	将一个VO类对象转为NSMutabileDictionary类型
- (NSMutableDictionary *)convertDictionary;

/// 将vo对象转为json格式的字符串对象中的属性类型只能是：NSString NSNumber NSArray NSDictionary NSNull 或者是本地VO实体对象
- (NSString *)toJsonStr;

/// 功能:将字符串转成dictionary
/// @param aString aString description
+ (NSDictionary *)dictFromString:(NSString *)aString;

/// 功能:将字符串转成array
/// @param aString aString description
+ (NSArray *)arrayFromString:(NSString *)aString;

@end

#pragma mark - Category
@interface NSObject (Category)
@property (nonatomic, strong, readonly) NSMutableArray *associatedObjectNames;

/// 为当前object动态增加分类
/// @param propertyName 分类名称
/// @param value 分类值
/// @param policy 分类内存管理类型
- (void)objc_setAssociatedObject:(NSString *)propertyName value:(id)value policy:(objc_AssociationPolicy)policy;

/// 获取当前object某个动态增加的分类
/// @param propertyName 分类名称
- (id)objc_getAssociatedObject:(NSString *)propertyName;

/// 删除动态增加的所有分类
- (void)objc_removeAssociatedObjects;

@end

#pragma mark - PerformBlock
@interface NSObject (PerformBlock)

// try catch
- (NSException *)tryCatch:(void(^)(void))block;
- (NSException *)tryCatch:(void(^)(void))block finally:(void(^)(void))aFinisheBlock;

/// 在主线程运行block
/// @param aInMainBlock 被运行的block
- (void)performInMainThreadBlock:(void(^)(void))aInMainBlock;

/// 延时在主线程运行block
/// @param aInMainBlock 被运行的block
/// @param delay 延时时间
- (void)performInMainThreadBlock:(void(^)(void))aInMainBlock afterSecond:(NSTimeInterval)delay;

/// 在非主线程运行block
/// @param aInThreadBlock 被运行的block
- (void)performInThreadBlock:(void(^)(void))aInThreadBlock;

/// 延时在非主线程运行block
/// @param aInThreadBlock 被运行的block
/// @param delay 延时时间
- (void)performInThreadBlock:(void(^)(void))aInThreadBlock afterSecond:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END

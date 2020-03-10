//
//  TCache.h
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCache : NSObject

/// 返回的Cache目录缓存实例
/// @param name 缓存目录名称
- (instancetype)initWithName:(NSString *)name ;

/// 返回自定义文件夹路径 dirpath/name
/// @param name 缓存文件夹名称
/// @param dirPath 缓存文件存放的文件夹
- (instancetype)initWithName:(NSString *)name dirPath:(NSString *)dirPath;

/// 返回自定义文件夹路径 dirpath/name 仅在内存中使用
/// @param name 缓存文件夹名称
/// @param dirPath 缓存文件存放的文件夹
/// @param memoryCache 是否仅在内存中缓存
- (instancetype)initWithName:(NSString *)name dirPath:(NSString *)dirPath memoryCache:(BOOL)memoryCache;

- (void)storeObject:(id)object forKey:(NSString *)key ;
- (void)removeObjectForKey:(NSString *)key;

- (void)addMetadata:(NSDictionary *)metadata forKey:(NSString *)key;
- (void)removeMetadataForKey:(NSString *)key;
- (void)removeAllObjects;

- (id)cachedObjectForKey:(NSString *)key;
- (void)fetchCachedObjectForKey:(NSString *)key  completion:(void (^)(id))completion;
- (NSDictionary *)metadataForKey:(NSString *)key;

- (unsigned long long)contentsSize;

- (NSTimeInterval)timeIntervalForKey:(NSString*)key;
- (void)setTimeInterval:(NSTimeInterval)value forKey:(NSString*)key;

- (BOOL)boolForKey:(NSString*)key;
- (void)setBool:(BOOL)value forKey:(NSString*)key;

- (NSInteger)integerForKey:(NSString*)key;
- (void)setInteger:(NSInteger)value forKey:(NSString*)key;

- (float)floatForKey:(NSString*)key;
- (void)setFloat:(float)value forKey:(NSString*)key;

- (NSString*)stringForKey:(NSString*)key;
- (void)setString:(NSString * _Nullable)value forKey:(NSString*)key;

- (NSArray*)arrayForKey:(NSString *)key;
- (void)setArray:(NSArray * _Nullable)value forKey:(NSString *)key;

- (NSDictionary*)dictionaryForKey:(NSString*)key;
- (void)setDictionary:(NSDictionary * _Nullable)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END

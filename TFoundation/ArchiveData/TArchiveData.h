//
//  TArchiveData.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TArchiveData : NSObject

/// 功能:存档
/// @param aData 数据
/// @param aFileName 文件名
+ (void)archiveDataInDoc:(id<NSCoding>)aData withFileName:(NSString *)aFileName;

/// 功能:取档
/// @param aFileName 从document中取文件
+ (id<NSCoding>)unarchiveDataInDocWithFileName:(NSString *)aFileName;

/// 功能:存档到cache
/// @param aData 数据
/// @param aFileName 文件名
+ (void)archiveDataInCache:(id<NSCoding>)aData withFileName:(NSString *)aFileName;

/// 功能:取档，从cache中取文件
/// @param aFileName 文件名
+ (id<NSCoding>)unarchiveDataInCacheWithFileName:(NSString *)aFileName;

/// 功能:取档,从[[NSBundle mainBundle] resourcePath]取文件
/// @param aFileName 文件名
+ (id<NSCoding>)unarchiveDataInMainBundleWithFileName:(NSString *)aFileName;

/// 功能:取档,从[[NSBundle mainBundle] resourcePath]取文件
/// @param aFileName 文件名
/// @param aBundleName aBundleName description
+ (id<NSCoding>)unarchiveDataWithFileName:(NSString *)aFileName andBundleName:(NSString * _Nullable)aBundleName;

@end

NS_ASSUME_NONNULL_END

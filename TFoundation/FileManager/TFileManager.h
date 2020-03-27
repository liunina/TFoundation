//
//  TFileManager.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#define T_DOC_PATH    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]

@interface TFileManager : NSObject

/// 获得app文档目录
+ (NSString *)appDocPath;

/// 获得app缓存目录
+ (NSString *)appCachePath;

/// 获得app的lib目录
+ (NSString *)appLibPath;

/// 判断文件是否存在
/// @param aPath 文件路径
+ (BOOL)isFileExsit:(NSString *)aPath;

/// 判断Doc目录中是否存在某文件
/// @param aPath 文件路径
+ (BOOL)isFileExsitInDoc:(NSString *)aPath;

/// 判断bundle是否存在
/// @param aBundleName bundle名称
+ (BOOL)isBundleExsit:(NSString *)aBundleName;
@end

NS_ASSUME_NONNULL_END

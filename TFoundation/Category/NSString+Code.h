//
//  NSString+Code.h
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(MD5)

- (NSString *)stringFromMD5;

@end

@interface NSString (Aes128)
/*
 @param: content 加密文本
 @param: key  加密需要的key
*/

/// AES加密
/// @param content 加密文本
/// @param key 加密需要的key
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key ;


@end
NS_ASSUME_NONNULL_END

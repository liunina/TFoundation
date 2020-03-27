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

@interface NSString (ConvertType)

+ (NSString *) unicodeToUtf8:(NSString *)string;
+ (NSString *) utf8ToUnicode:(NSString *)string;
///	"#fff303"色值转16进制
- (unsigned long)sixteenBinarySystem;

@end

#pragma mark - CSSHtml
@interface NSString (CSSHtml)

/// 给html添加一个居中显示的css样式,返回此html
- (NSString *)getAlignCenterCssHtml;

- (NSString *)getWirelessAlignCenterCssHtml;

- (NSString *)getPCAlignCenterCssHtml;

- (NSString *)getTheOtherOneAlignCenterCssHtml;

@end

#pragma mark - plus
@interface NSString (plus)

- (NSUInteger)byteCount;

/// NSString转为NSNumber
- (NSNumber*)toNumber;

/// urlencoding
- (NSString *)urlEncoding;

/// urldecoding
- (NSString *)urlDecoding;

/// url encoding所有字符
- (NSString *)urlEncodingAllCharacter;

/// 功能:html语句居中处理
- (NSString *)makeHtmlAlignCenter;

/**
 *  功能:拼装2个组合字串(知道首字串长度)
 */

/// 功能:拼装2个组合字串(知道首字串长度)
/// @param aAttributes aAttributes
/// @param bAttributes bAttributes description
/// @param aLength aLength description
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                headLength:(NSUInteger)aLength;

/// 功能:拼装2个组合字串(知道尾字串长度)
/// @param aAttributes aAttributes description
/// @param bAttributes bAttributes description
/// @param aLength aLength description
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                tailLength:(NSUInteger)aLength;

/// 功能:拼装3个组合字串(知道首尾长度)
/// @param aAttributes aAttributes description
/// @param bAttributes bAttributes description
/// @param cAttributes cAttributes description
/// @param aLength aLength description
/// @param cLength cLength description
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                             midAttributes:(NSDictionary *)bAttributes
                                            tailAttributes:(NSDictionary *)cAttributes
                                                headLength:(NSUInteger)aLength
                                                tailLength:(NSUInteger)cLength;

/// 替换字符串中指定的内容
/// @param fromAry 扫描字符串
/// @param replaceAry 用于替换的字符串
- (NSString *)replaceFromArray:(NSArray *)fromAry withArray:(NSArray *)replaceAry;

/// 版本号比较
/// @param aString aString description
- (NSComparisonResult)versionCompare:(NSString *)aString;

///	计算一段字符串的长度，两个英文字符占一个长度。
+ (int)countTheStrLength:(NSString *)strtemp;

///	是否是纯int
- (BOOL)isPureInt;

/// 功能:让一段字符串文本和数字的颜色
/// @param numColor numColor description
/// @param color color description
/// @param font font description
-(NSMutableAttributedString *)stringWithNumColor:(UIColor *)numColor
                                  andOtherColor:(UIColor *)color
                                    contentFont:(UIFont *)font;

/// 功能:价格字符串小数点前后字体和颜色
/// @param aColor aColor description
/// @param aSymbolFont aSymbolFont description
/// @param aIntrgerFont aIntrgerFont description
/// @param aDecimalFont aDecimalFont description
- (NSMutableAttributedString *)stringWithColor:(UIColor *)aColor
                                   symbolFont:(UIFont *)aSymbolFont
                                   integerFont:(UIFont *)aIntrgerFont
                                  decimalFont:(UIFont *)aDecimalFont;

/// 功能:是否浮点型
- (BOOL)isPureFloat;

/// 功能:获取倒计时字符串
/// @param dateComponents dateComponents description
/// @param numFont numFont description
/// @param numColor numColor description
/// @param charaterFont charaterFont description
/// @param characterColor characterColor description
+ (NSMutableAttributedString *)getTimeStringWithDateComponent:(NSDateComponents *)dateComponents
                                                      numFont:(UIFont *)numFont
                                                     numColor:(UIColor *)numColor
                                                characterFont:(UIFont *)charaterFont
                                               characterColor:(UIColor *)characterColor;
@end

NS_ASSUME_NONNULL_END

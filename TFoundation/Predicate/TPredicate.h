//
//  TPredicate.h
//  TFoundation
//
//  Created by liu nian on 2020/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPredicate : NSObject
// 检查用户名
+(BOOL)checkUserName:(NSString *)aCandidate;

+(BOOL)checkBindPhoneNumber:(NSString *)aCandidate;

// 检查电话号码
+(BOOL)checkPhoneNumber:(NSString *)aCandidate;

//// 检查座机号
+(BOOL)checkZuoJiHaoNumber:(NSString *)aCandidate;

// 检查数字
+(BOOL)checkNumeric:(NSString *)aCandidate;

// 检查字符
+(BOOL)checkCharacter:(NSString *)aCandidate;

// 检查密码
+(BOOL)checkPassword:(NSString *)aCandidate;

// 检查特殊字符
+(BOOL)checkSpecialChar:(NSString *)aCandidate;

// 检查邮箱
+(BOOL)checkEmail:(NSString *)aCandidate;

// 检查宝宝名
+(BOOL)checkBabyName:(NSString *)aCandidate;

//是否包含表情
+(BOOL)isContainsEmoji:(NSString *)string;

// 地址里检查特殊字符
+(BOOL)checkAddressSpecialChar:(NSString *)aCandidate;

// 地址里检查含汉字字符
+(BOOL)checkChineseChar:(NSString *)aCandidate;

// 检查手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum;

// 加强版 检查座机号
+ (BOOL)checkLandlineNumber:(NSString *)aCandidate;

// 查询手机号 所属地
+ (NSString *)checkPhoneNumberAddress:(NSString *)phoneStr;
@end

NS_ASSUME_NONNULL_END

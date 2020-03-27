//
//  NSDate+Code.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Format
@interface NSDate (Format)

/// 把日期转化为yyyy/MM/dd
- (NSString *)dateToString_yyyyMMdd;

/// 把日期转化为yyyy-MM-dd
- (NSString *)dateToString_yyyyMMdd1;

/// 把日期转化为yyyy-MM-dd HH:mm
- (NSString *)dateToString_yyyyMMddHHmm;

@end

#pragma mark - Style
@interface NSDate(Style)

/// 功能:获取距离现在的天数，小于一天为0
- (NSInteger )distanceNowDays;

/// 功能:日期距离当前时间的描述，改描述为:_天_时_分_秒
- (NSString *)distanceNowDescribe;

/// 功能:日期距离当前时间的描述，改描述为:_天_时_分_秒
- (NSDictionary *)distanceNowDic;

/// 功能:年月日从现在
- (NSDictionary *)distanceYearMonthDayFromNowDic;

/// 功能:转换成日期字符串，精确到天
- (NSString *)dateString;

/// 功能:转换成时间字符串，精确到秒
- (NSString *)timeString;

- (NSString *)anotherTimeString;

/// 功能:转换成时间字符串，精确到分
- (NSString *)timeStringToSecond;

- (NSString *)anotherTimeStringToSecond;

/// 功能:转换成时间字符串，获取时分秒部分
- (NSString *)hourMinuteSecondString;

/// 功能:转换成时间字符串，获取时分部分
- (NSString *)hourMinuteString;

/// 功能:转换成时间字符串，获取时部分
- (NSString *)hourString;

/// 功能:转换成时间字符串，获取月天时分秒部分
- (NSDictionary *)monthDayHourMinuteString;

/// 功能:转换成周
- (NSString *)zhouString;

/// 是否是今天的日期
- (BOOL)isTodayDate;

/// 是否昨天
- (BOOL)isYesterday;

/// 是否是今年的日期
- (BOOL)isCurrentYearDate;

/// 判断与当前时间差值
- (NSDateComponents *)deltaWithNow;

/// 用逗号分隔的日期字符串
- (NSString *)dateStringWithDot;
@end

NS_ASSUME_NONNULL_END

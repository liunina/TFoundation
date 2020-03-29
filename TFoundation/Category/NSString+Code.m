//
//  NSString+Code.m
//  TFoundation
//
//  Created by liu nian on 2020/3/10.
//

#import "NSString+Code.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import <GTMBase64/GTMBase64.h>
#import "NSArray+safe.h"
#import "TFoundationLogging.h"

@implementation NSString(MD5)

- (NSString *)stringFromMD5 {
    if (self==nil || [self length]==0) {
        return nil;
    }
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count=0; count<CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    return outputString;
}

@end

@implementation NSString (Aes128)

#pragma mark aes加密，
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    //把string转NSData
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    //length
    size_t plainTextBufferSize = [data length];
    const void*vplainText = (const void*)[data bytes];
    uint8_t*bufferPtr =NULL;
    size_t bufferPtrSize =0;
    size_t movedBytes =0;
    bufferPtrSize = (plainTextBufferSize +kCCBlockSizeAES128) & ~(kCCBlockSizeAES128-1);
    bufferPtr =malloc( bufferPtrSize *sizeof(uint8_t));
    memset((void*)bufferPtr,0x0, bufferPtrSize);
    const void*vkey = (const void*) [key UTF8String];
    
    //配置CCCrypt
    CCCryptorStatus ccStatus =CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES128,//3DES
                                     kCCOptionECBMode|kCCOptionPKCS7Padding,//设置模式
                                     vkey,//key
                                     kCCKeySizeAES192,
                                     nil,//偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                                     vplainText,
                                     plainTextBufferSize,
                                     (void*)bufferPtr,
                                     bufferPtrSize,
                                     &movedBytes);
    
    if(ccStatus ==kCCSuccess) {
        NSData*myData = [NSData dataWithBytes:(const char*)bufferPtr length:(NSUInteger)movedBytes];
        free(bufferPtr);
        return [GTMBase64 stringByEncodingData:myData];
    }
	free(bufferPtr);
    return nil;
}
@end

@implementation NSString (ConvertType)

+ (NSString *)unicodeToUtf8:(NSString *)string {
    NSString *tempStr1 = [string stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = (tempStr2 ? [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""] : tempStr2);
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:&error];
	
    if ([returnStr isKindOfClass:[NSString class]]) {
        return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    } else {
        return nil;
    }
}

+ (NSString *)utf8ToUnicode:(NSString *)string {
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++) {
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0') {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else if(_char >= 'a' && _char <= 'z') {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else if(_char >= 'A' && _char <= 'Z') {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }else {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
    }
    return s;
}

///	"#fff303"色值转16进制
- (unsigned long)sixteenBinarySystem {
    if (self.length <= 1) {
        return 0;
    }
    NSMutableString *colorStr = [[NSMutableString alloc] initWithString:@"0x"];
    NSString *valueStr = self.mutableCopy;
    valueStr = [valueStr substringFromIndex:1];
    [colorStr appendString:valueStr];
    return strtoul([colorStr UTF8String],0,16);
}


+ (NSString *)stringFromDict:(NSDictionary *)aDict {
    return [self stringFromDict:aDict options:0];
}

+ (NSString *)prettyStringFromDict:(NSDictionary *)aDict {
    return [self stringFromDict:aDict options:NSJSONWritingPrettyPrinted];
}

+ (NSString *)stringFromDict:(NSDictionary *)aDict options:(NSJSONWritingOptions)option {
    return [self stringFromJSONObject:aDict options:option];
}

+ (NSString *)stringFromJSONObject:(id)aObj options:(NSJSONWritingOptions)option {
    NSString *json = nil;
    if ([NSJSONSerialization isValidJSONObject:aObj]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aObj options:option error:&error];
        if (!error) {
            json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } else {
            TFLogError(@"error convert to json,%@,%@",error,aObj);
        }
    }
    
    return json;
}

@end

@implementation NSString (CSSHtml)

- (NSString *)getAlignCenterCssHtml {
    return  [NSString stringWithFormat:@"<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><meta name=\"viewport\" content=\"width=750, maximum-scale=1.5\"><style type=\"text/css\">.webview_ios{text-align:left;word-wrap:break-word}.webview_ios img{text-align:center;max-width:100%%}.webview_ios ul{padding:0}table{font-size:25px}table .ull{width:auto !important;height:auto !important;}</style></head><body><div class=\"webview_ios\">%@</div></body>",self];
}
- (NSString *)getWirelessAlignCenterCssHtml{
    return [NSString stringWithFormat:@"<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><meta name=\"viewport\" content=\"width=device-width, maximum-scale=1.5\"><style type=\"text/css\">.webview_ios{text-align:left;word-wrap:break-word}.webview_ios img{max-width:100%%}.webview_ios ul{padding:0}table .ull{width:auto !important;height:auto !important;}</style></head><body><div class=\"webview_ios\">%@</div></body>",self];
}

- (NSString *)getPCAlignCenterCssHtml{
    return [NSString stringWithFormat:@"<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><meta name=\"viewport\" content=\"width=750, maximum-scale=1.5\"><style type=\"text/css\">.webview_ios{text-align:left;word-wrap:break-word}.webview_ios img{max-width:100%%}.webview_ios ul{padding:0}table{font-size:25px}table .ull{width:auto !important;height:auto !important;}</style></head><body><div class=\"webview_ios\">%@</div></body>",self];
}

- (NSString *)getTheOtherOneAlignCenterCssHtml {
    //不缩放方法
    NSString *result = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=750, user-scalable=0\" charset=\"UTF-8\"><style type=\"text/css\">.webview_ios{text-align:left;word-wrap:break-word}.webview_ios img{max-width:100%%}.webview_ios ul{padding:0}table{font-size:25px}</style></head><body><div class=\"webview_ios\">%@</div></body></html>",self];
    
    //缩放方法
//     NSString *result = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=750, maximum-scale=1.5\" charset=\"UTF-8\"><style type=\"text/css\">.webview_ios{text-align:left;word-wrap:break-word}.webview_ios img{max-width:100%%}.webview_ios ul{padding:0}table{font-size:25px}</style></head><body><div class=\"webview_ios\">%@</div></body></html>",self];
    
    return  result;
}
@end

@implementation NSString (plus)

- (NSUInteger)byteCount {
    NSUInteger length = 0;
    char *pStr = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0 ; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*pStr) {
            pStr++;
            length++;
        }
        else {
            pStr++;
        }
    }
    return length;
}

- (NSNumber*)toNumber {
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number=[formatter numberFromString:self];
    return number;
}

- (NSString *)urlEncoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)urlDecoding {
    return self.stringByRemovingPercentEncoding;
}

- (NSString *)urlEncodingAllCharacter {
	return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

/**
 *  功能:html语句居中处理
 */
- (NSString *)makeHtmlAlignCenter {
    return  [NSString stringWithFormat:@"<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><meta name=viewport content=width=device-width, user-scalable=yes ><style type=\"text/css\">body{text-align:center;}div{width:750px;margin:10 auto;text-align:left;}</style></head><body><div>%@</div></body>",self];
}

/**
 *  功能:拼装2个组合字串(知道首字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                headLength:(NSUInteger)aLength {
    NSRange headRange = NSMakeRange(0, aLength);
    NSRange tailRange = NSMakeRange(aLength, self.length-aLength);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:tailRange];
    
    return attributedString;
}

/**
 *  功能:拼装2个组合字串(知道尾字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                tailLength:(NSUInteger)aLength {
    NSRange headRange = NSMakeRange(0, self.length-aLength);
    NSRange tailRange = NSMakeRange(self.length-aLength, aLength);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:tailRange];
    
    return attributedString;
}

/**
 *  功能:拼装3个组合字串(知道首尾长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                             midAttributes:(NSDictionary *)bAttributes
                                            tailAttributes:(NSDictionary *)cAttributes
                                                headLength:(NSUInteger)aLength
                                                tailLength:(NSUInteger)cLength {
    NSRange headRange = NSMakeRange(0, aLength);
    NSRange midRange = NSMakeRange(aLength, self.length-aLength-cLength);
    NSRange tailRange = NSMakeRange(self.length-cLength, cLength);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:midRange];
    [attributedString setAttributes:cAttributes range:tailRange];
    
    return attributedString;
}

/**
 *  替换字符串中指定的内容
 *
 *  @param fromAry    扫描字符串
 *  @param replaceAry 用于替换的字符串
 *
 *  @return 返回的结果
 */
- (NSString *)replaceFromArray:(NSArray *)fromAry withArray:(NSArray *)replaceAry {
    NSString *result = [NSString stringWithString:self];
    if (result.length>0 && [fromAry count]>0 &&([fromAry count] == [replaceAry count])) {
        for (int i =0;i< [fromAry count];i ++) {
            id fromStr = [fromAry objectAtIndex:i];
            id replaceStr = [replaceAry objectAtIndex:i];
            if ([fromStr isKindOfClass:[NSString class]] && [replaceStr isKindOfClass:[NSString class]]) {
                result = [result stringByReplacingOccurrencesOfString:fromStr withString:replaceStr];
            }else {
                return self;
            }
        }
    }
    return result;
}

/**
 *  功能:版本号比较
 */
- (NSComparisonResult)versionCompare:(NSString *)aString {
    NSArray *selfComponents = [self componentsSeparatedByString:@"."];
    NSArray *aComponents = [aString componentsSeparatedByString:@"."];
    NSUInteger maxCount = MAX(selfComponents.count, aComponents.count);
    for (NSUInteger i=0; i<maxCount; i++) {
        NSString *selfComponent = [selfComponents safeObjectAtIndex:i];
        if (selfComponent == nil) {
            selfComponent = @"0";
        }
        NSString *aComponent = [aComponents safeObjectAtIndex:i];
        if (aComponent == nil) {
            aComponent = @"0";
        }
        NSComparisonResult result = [selfComponent compare:aComponent];
        if (result == NSOrderedSame) {
            continue;
        }else {
            return result;
        }
    }
    
    return NSOrderedSame;
}

//计算一段字符串的长度，两个英文字符占一个长度。
+ (int)countTheStrLength:(NSString *)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

//是否是纯int
- (BOOL)isPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
/**
 *  功能:让一段字符串文本和数字的颜色
 */
- (NSMutableAttributedString *)stringWithNumColor:(UIColor *)numColor andOtherColor:(UIColor *)color contentFont:(UIFont *)font {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:nil];
    NSArray *numArr = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSForegroundColorAttributeName:numColor}];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[self length])];
    for (NSTextCheckingResult *attirbute in numArr) {
        [attributedString setAttributes:@{NSForegroundColorAttributeName:color} range:attirbute.range];
    }
    return attributedString;
}

/**
 *  功能:价格字符串小数点前后字体和颜色
 */
- (NSMutableAttributedString *)stringWithColor:(UIColor *)aColor symbolFont:(UIFont *)aSymbolFont integerFont:(UIFont *)aIntrgerFont decimalFont:(UIFont *)aDecimalFont {
    if (self.length <= 0) {
        return nil;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    [string addAttribute:NSForegroundColorAttributeName value:aColor range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:aSymbolFont range:NSMakeRange(0, 1)];
    NSRange range = [self rangeOfString:@"."];
    if (range.location != NSNotFound) {
        [string addAttribute:NSFontAttributeName value:aIntrgerFont range:NSMakeRange(1, range.location)];
        [string addAttribute:NSFontAttributeName value:aDecimalFont range:NSMakeRange(range.location,  string.length - range.location)];
    } else {
        [string addAttribute:NSFontAttributeName value:aIntrgerFont range:NSMakeRange(1, string.length - 1)];
    }
    return string;
}

/**
 *  功能:是否浮点型
 */
- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  功能:获取倒计时字符串
 */
+ (NSMutableAttributedString *)getTimeStringWithDateComponent:(NSDateComponents *)dateComponents numFont:(UIFont *)numFont numColor:(UIColor *)numColor characterFont:(UIFont *)charaterFont characterColor:(UIColor *)characterColor {
    int totalHour = abs((int)dateComponents.hour);
    int day = totalHour/24;
    int hour = totalHour%24;
    int minute = abs((int)dateComponents.minute);
    int second = abs((int)dateComponents.second);
    NSDictionary *dateDict = @{NSForegroundColorAttributeName:numColor,NSFontAttributeName:numFont};
    NSDictionary *characterDict = @{NSForegroundColorAttributeName:characterColor,NSFontAttributeName:charaterFont};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSString *dayString  = [NSString stringWithFormat:@"%02d天", day];
    NSMutableAttributedString *dayAttrString = [[NSMutableAttributedString alloc] initWithString:dayString];
    [dayAttrString addAttributes:dateDict range:NSMakeRange(0, 2)];
    [dayAttrString addAttributes:characterDict range:NSMakeRange(2, 1)];
    
    NSString *hourString = [NSString stringWithFormat:@"%02d小时", hour];
    NSMutableAttributedString *hourAttrString = [[NSMutableAttributedString alloc] initWithString:hourString];
    [hourAttrString addAttributes:dateDict range:NSMakeRange(0, 2)];
    [hourAttrString addAttributes:characterDict range:NSMakeRange(2, 2)];
    
    NSString *minuteString = [NSString stringWithFormat:@"%02d分", minute];
    NSMutableAttributedString *minuteAttrString = [[NSMutableAttributedString alloc] initWithString:minuteString];
    [minuteAttrString addAttributes:dateDict range:NSMakeRange(0, 2)];
    [minuteAttrString addAttributes:characterDict range:NSMakeRange(2, 1)];
    
    NSString *secondString = [NSString stringWithFormat:@"%02d秒", second];
    NSMutableAttributedString *secondAttrString = [[NSMutableAttributedString alloc] initWithString:secondString];
    [secondAttrString addAttributes:dateDict range:NSMakeRange(0, 2)];
    [secondAttrString addAttributes:characterDict range:NSMakeRange(2, 1)];
    
    if (day > 0) {
        [attributedString appendAttributedString:dayAttrString];
        [attributedString appendAttributedString:hourAttrString];
        [attributedString appendAttributedString:minuteAttrString];
        [attributedString appendAttributedString:secondAttrString];
    } else if (hour > 0){
        [attributedString appendAttributedString:hourAttrString];
        [attributedString appendAttributedString:minuteAttrString];
        [attributedString appendAttributedString:secondAttrString];
    } else if (minute > 0){
        [attributedString appendAttributedString:minuteAttrString];
        [attributedString appendAttributedString:secondAttrString];
    } else if (second > 0){
        [attributedString appendAttributedString:secondAttrString];
    } else {
        NSString *timeString = @"0秒";
        attributedString = [[NSMutableAttributedString alloc] initWithString:timeString];
    }
    return attributedString;
}

@end

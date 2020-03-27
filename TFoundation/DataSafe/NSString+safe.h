//
//  NSString+safe.h
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (safe)

- (NSString *)safeSubstringFromIndex:(NSUInteger)from;
- (NSString *)safeSubstringToIndex:(NSUInteger)to;
- (NSString *)safeSubstringWithRange:(NSRange)range;
- (NSRange)safeRangeOfString:(NSString *)aString;
- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask;
- (NSString *)safeStringByAppendingString:(NSString *)aString;
- (id)safeInitWithString:(NSString *)aString;
+ (id)safeStringWithString:(NSString *)string;

@end

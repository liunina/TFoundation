//
//  NSMutableString+safe.h
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString(safe)

- (void)safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc;
- (void)safeAppendString:(NSString *)aString;
- (void)safeSetString:(NSString *)aString;
- (NSUInteger)safeReplaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange;

@end

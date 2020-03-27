//
//  NSMutableString+safe.m
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import "NSMutableString+safe.h"

@implementation NSMutableString(safe)

- (void)safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (aString == nil) {
        return;
    } else if (loc > self.length) {
        return;
    } else {
        [self insertString:aString atIndex:loc];
    }
}

- (void)safeAppendString:(NSString *)aString {
    if (aString == nil) {
        return;
    } else {
        [self appendString:aString];
    }
}

- (void)safeSetString:(NSString *)aString {
    if (aString == nil) {
        return;
    } else {
        [self setString:aString];
    }
}

- (NSUInteger)safeReplaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSUInteger location = searchRange.location;
    NSUInteger length = searchRange.length;
    
    if (target == nil || replacement == nil) {
        return 0;
    } else if (location + length > self.length) {
        return 0;
    } else {
        return [self replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }
}

@end

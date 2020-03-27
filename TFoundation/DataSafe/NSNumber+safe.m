//
//  NSNumber+safe.m
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import "NSNumber+safe.h"

@implementation NSNumber (safe)

- (BOOL)safeIsEqualToNumber:(NSNumber *)number {
    if (number == nil) {
        return NO;
    } else {
        return [self isEqualToNumber:number];
    }
}

- (NSComparisonResult)safeCompare:(NSNumber *)otherNumber {    
    if (otherNumber == nil) {
        return NSOrderedDescending;
    } else {
        return [self compare:otherNumber];
    }
}

@end

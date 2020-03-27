//
//  NSArray+safe.h
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index;
+ (instancetype)safeArrayWithObject:(id)object;
- (NSArray *)safeSubarrayWithRange:(NSRange)range;
- (NSUInteger)safeIndexOfObject:(id)anObject;

@end

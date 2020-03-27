//
//  NSMutableArray+safe.h
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (safe)

- (void)safeAddObject:(id)object;
- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index;
- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs;
- (void)safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)safeRemoveObjectsInRange:(NSRange)range;

@end

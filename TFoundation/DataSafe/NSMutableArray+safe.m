//
//  NSMutableArray+safe.m
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import "NSMutableArray+safe.h"
#import "NSObject+TSwizzle.h"

@implementation NSMutableArray (safe)

+ (void)load {
    [self overrideMethod:@selector(setObject:atIndexedSubscript:) withMethod:@selector(safeSetObject:atIndexedSubscript:)];
}

- (void)safeSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (obj == nil) {
        return ;
    }

    if (self.count < idx) {
        return ;
    }

    if (idx == self.count) {
        [self addObject:obj];
    } else {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
}

- (void)safeAddObject:(id)object {
	if (object == nil) {
		return;
	} else {
        [self addObject:object];
    }
}

- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index {
	if (object == nil) {
		return;
	} else if (index > self.count) {
		return;
	} else {
        [self insertObject:object atIndex:index];
    }
}

- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs {
    NSUInteger firstIndex = indexs.firstIndex;
    if (indexs == nil) {
        return;
    } else if (indexs.count!=objects.count || firstIndex>objects.count) {
        return;
    } else {
        [self insertObjects:objects atIndexes:indexs];
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
	if (index >= self.count) {
		return;
	} else {
        [self removeObjectAtIndex:index];
    }
}

- (void)safeRemoveObjectsInRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.count) {
        return;
    } else {
        [self removeObjectsInRange:range];
    }
}

@end

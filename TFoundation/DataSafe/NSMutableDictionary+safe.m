//
//  NSMutableDictionary+safe.m
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import "NSMutableDictionary+safe.h"
#import "NSObject+TSwizzle.h"

@implementation NSMutableDictionary(safe)

+ (void)load {
    [self overrideMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(safeSetObject:forKeyedSubscript:)];
}

- (void)safeSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        return ;
    }

    if (!obj) {
        [self removeObjectForKey:key];
    }
    else {
        [self setObject:obj forKey:key];
    }
}

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey {
    if (aObj && aKey) {
        [self setObject:aObj forKey:aKey];
    } else {
        return;
    }
}

@end

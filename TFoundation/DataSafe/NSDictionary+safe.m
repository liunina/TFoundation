//
//  NSDictionary+safe.m
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import "NSDictionary+safe.h"

@implementation NSDictionary (safe)
+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key {
    if (object==nil || key==nil) {
        return [self dictionary];
    } else {
        return [self dictionaryWithObject:object forKey:key];
    }
}

@end

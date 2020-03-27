//
//  NSMutableDictionary+safe.h
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(safe)

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey;

@end

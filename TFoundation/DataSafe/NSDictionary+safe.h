//
//  NSDictionary+safe.h
//  TFoundation
//
//  Created by never88gone on 18-01-01.
//  Copyright (c) 2018年 TFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safe)
+ (id)safeDictionaryWithObject:(id)object forKey:(id <NSCopying>)key;
@end

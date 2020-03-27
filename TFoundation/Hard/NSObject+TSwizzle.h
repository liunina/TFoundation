//
//  NSObject+TSwizzle.h
//  TFoundation
//
//  Created by liu nian on 2020/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TSwizzle)
+ (BOOL)overrideMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)overrideClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;
+ (BOOL)exchangeMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)exchangeClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;

@end

NS_ASSUME_NONNULL_END

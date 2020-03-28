//
//  TWeakObjectDeathNotifier.h
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//	当owner释放的时候通知block
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TWeakObjectDeathNotifier;
typedef void(^TWeakObjectDeathNotifierBlock)(TWeakObjectDeathNotifier *sender);

@interface TWeakObjectDeathNotifier : NSObject
@property (nonatomic, weak) id owner;
/// 设置通知回调
/// @param block 回调
- (void)setBlock:(TWeakObjectDeathNotifierBlock)block;

@end

NS_ASSUME_NONNULL_END

//
//  TDeadtimeTimer.h
//  TFoundation
//
//  Created by liu nian on 2020/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 为nil则表示已经倒计时完成了
typedef void(^OTSDeadtimeTimerBlock)(NSDateComponents * _Nullable dateComponents);

@interface TDeadtimeTimer : NSObject

- (void)runWithDeadtime:(NSDate *)deadtime andBLock:(OTSDeadtimeTimerBlock)aBlock;
- (void)stop;

@end

NS_ASSUME_NONNULL_END

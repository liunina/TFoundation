//
//  TReqManager.h
//  TFoundation_Example
//
//  Created by liu nian on 2020/3/10.
//  Copyright © 2020 i19850511@gmail.com. All rights reserved.
//

#import <TFoundation/TNetWorkUnit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TReqUnit : TNetWorkUnit
+ (instancetype)sharedClient;
@end

NS_ASSUME_NONNULL_END

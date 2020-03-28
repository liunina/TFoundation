//
//  TWeakObjectDeathNotifier.m
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//

#import "TWeakObjectDeathNotifier.h"
#import "NSObject+Code.h"

@interface TWeakObjectDeathNotifier ()
@property (nonatomic, copy) TWeakObjectDeathNotifierBlock aBlock;
@end

@implementation TWeakObjectDeathNotifier

- (void)dealloc {
    if (self.aBlock) {
        self.aBlock(self);
    }
    self.aBlock = nil;
}

- (void)setBlock:(TWeakObjectDeathNotifierBlock)block {
    self.aBlock = block;
}

- (void)setOwner:(id)owner {
    _owner = owner;
    [owner objc_setAssociatedObject:[NSString stringWithFormat:@"observerOwner_%p",self]
							  value:self
							 policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

@end

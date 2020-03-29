//
//  TDeadtimeTimer.m
//  TFoundation
//
//  Created by liu nian on 2020/3/29.
//

#import "TDeadtimeTimer.h"

@interface TDeadtimeTimer ()
@property (nonatomic, copy) OTSDeadtimeTimerBlock block;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, strong) NSDate *deadTime;
@end

@implementation TDeadtimeTimer

- (void)runCountdownView {
//    NSDate *now = [OTSGlobalValue sharedInstance].serverTime;
	NSDate *now = [NSDate date];
    if ([self.deadTime compare:now] == NSOrderedDescending) {
        NSTimeInterval timeInterval = [self.deadTime timeIntervalSinceDate:now];
        NSDate *endingDate = now;
        NSDate *startingDate = [endingDate dateByAddingTimeInterval:-timeInterval];
        
        NSCalendarUnit components = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:components fromDate:startingDate toDate:endingDate options:(NSCalendarOptions)0];
        
        if (self.block) {
            self.block(dateComponents);
        }
    } else {
        if (self.block) {
            self.block(nil);
        }
        _block = nil;
        [self stop];
    }
}

- (void)runWithDeadtime:(NSDate *)deadtime andBLock:(OTSDeadtimeTimerBlock)aBlock {
    self.block = aBlock;
    
    self.deadTime = deadtime;
    
    [self stop];
    
    __weak typeof(self) ws = self;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:ws selector:@selector(runCountdownView) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    [self.countdownTimer fire];
}

- (void)stop {
    [self.countdownTimer invalidate];
}

- (void)dealloc {
}

@end

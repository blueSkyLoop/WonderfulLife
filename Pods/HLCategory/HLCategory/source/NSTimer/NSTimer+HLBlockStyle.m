//
//  NSTimer+HLBlockStyle.m
//  HLCategory
//
//  Created by hanl on 2017/5/4.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import "NSTimer+HLBlockStyle.h"

@implementation NSTimer (HLBlockStyle)

+ (NSTimer *)hl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(NSTimerInvokeHandler)block {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self/*类对象无需回收*/
                                       selector:@selector(hl_blockInvoke:)
                                       userInfo:[block copy]/*fix MRC*/
                                        repeats:repeats];
}

+ (NSTimer *)hl_timerWithTimeInterval:(NSTimeInterval)interval
                              repeats:(BOOL)repeats
                                block:(NSTimerInvokeHandler)block {
    return [self timerWithTimeInterval:interval
                                target:self
                              selector:@selector(hl_blockInvoke:)
                              userInfo:[block copy]
                               repeats:repeats];
}


+ (void)hl_blockInvoke:(NSTimer *)timer {
    // timer 实例会持有block invalidate后便会释放
    NSTimerInvokeHandler block = timer.userInfo;
    if (block) block();
}

@end

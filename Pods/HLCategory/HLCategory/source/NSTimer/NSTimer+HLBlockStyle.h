//
//  NSTimer+HLBlockStyle.h
//  HLCategory
//
//  Created by hanl on 2017/5/4.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NSTimerInvokeHandler)();

@interface NSTimer (HLBlockStyle)


/**
 *  系统的block方法不能适配低版本
 *  在本方法不会带来循环引用
 *  注意: 1.需要调用invalidate方法来停止定时器
 *          (若不能正常invalidate,则需要weak-strong-dance来防止内存泄漏)
 *       2.不要使用timer的useInfo属性
 */
+ (NSTimer *_Nullable)hl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                                repeats:(BOOL)repeats
                                                  block:(NSTimerInvokeHandler _Nullable )block;


/// 需要使用 fire 手动启动 timer
+ (NSTimer *_Nullable)hl_timerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(NSTimerInvokeHandler _Nullable)block;

@end

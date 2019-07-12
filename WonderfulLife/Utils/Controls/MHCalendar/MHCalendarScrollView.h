//
//  MHCalendarScrollView.h
//  calendarDemo
//
//  Created by zz on 04/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

typedef void (^DidSelectDayHandler)(NSDate *date);
typedef void (^WillDisplayDateHandler)(NSString *date);

@interface MHCalendarScrollView : UIScrollView

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) UIColor *dateTextColor;      // 日期颜色
@property (nonatomic, strong) UIColor *calendarBasicColor; // 基本颜色
@property (nonatomic,   copy) DidSelectDayHandler didSelectDayHandler; // 日期点击回调
@property (nonatomic,   copy) WillDisplayDateHandler willDisplayDateHandler; // 更改当前月份
@property (nonatomic, strong) RACSubject *didSelectedSubject; //点击了日期
/**
 重置按钮的重置时间
 */
@property (nonatomic, strong) NSDate   *resetDate;

@property (nonatomic, strong) NSDate   *inputDate;


- (void)refreshToCurrentMonth; // 刷新 calendar 回到当前日期月份
- (void)refreshTodayToCurrentMonth; //刷新 calendar 回到今天日期月份
@end

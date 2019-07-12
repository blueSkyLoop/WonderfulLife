//
//  NSCalendar+MHCategory.h
//  WonderfulLife
//
//  Created by zz on 10/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (MHCategory)

/*
 取得日期的日
 */
+ (NSInteger)dayFromDate:(NSDate *)fromDate;

/*
 计算月有几天
 */
+ (NSInteger)daysFromDate:(NSDate *)fromDate;

/*
 计算两个日期之间的天数
 */
+ (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/*
 计算两个日期共有几个月
 */
+ (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/*
 计算日期加上 x 個月
 */
+ (NSDate *)date:(NSDate *)fromDate addMonth:(NSInteger)month;

/*
 计算日期「x月 1日」是星期几
 */
+ (NSInteger)weekFromMonthFirstDate:(NSDate *)fromDate;

@end

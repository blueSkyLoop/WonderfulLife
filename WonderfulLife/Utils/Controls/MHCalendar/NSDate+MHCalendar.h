//
//  NSDate+MHCalendar.h
//  calendarDemo
//
//  Created by zz on 04/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MHCalendar)

/**
 *  获得当前 NSDate 对象对应的日子
 */
- (NSInteger)dateDay;

/**
 *  获得当前 NSDate 对象对应的月份
 */
- (NSInteger)dateMonth;

/**
 *  获得当前 NSDate 对象对应的年份
 */
- (NSInteger)dateYear;

/**
 *  获得当前 NSDate 对象的上个月的某一天（此处定为15号）的 NSDate 对象
 */
- (NSDate *)previousMonthDate;

/**
 *  获得当前 NSDate 对象的下个月的某一天（此处定为15号）的 NSDate 对象
 */
- (NSDate *)nextMonthDate;

/**
 *  获得当前 NSDate 对象对应的月份的总天数
 */
- (NSInteger)totalDaysInMonth;

/**
 *  获得当前 NSDate 对象对应月份当月第一天的所属星期
 */
- (NSInteger)firstWeekDayInMonth;

/**
 *  获得当前 NSDate 对象对应月份当月所属星期几
 */
- (NSString*)weekdayStringFromDate;

/**
 *  获得当前 NSDate 对象对应月份当月所属年月的字符串
 */
- (NSString*)stringFromDateFormat:(NSString *)format;
/**
 *  获得当前 NSString 对象根据format返回对应NSDate
 */
+ (NSDate *)dateFromStringDate:(NSString *)date format:(NSString *)format;
/**
 *  获得当前 NSDate 对象对应月份当月所属日期和星期几，如8月20日 星期三
 */
- (NSString*)weekdayAndMonthFromDate;

/**
 *  获得当前 NSString 对象对应NSDate
 */
+ (NSDate *)dateFromString:(NSString *)date;

/**
 *  获得当前 NSString 日期对象对应星期
 */
+ (NSString *)weekFromString:(NSInteger)date;

/**
 *  获得当前 NSString 日期对象对应年月（去0）
 */
- (NSString*)yearAndMonthFromDate;
/**
 *  获得当前 NSDate 日期对象对应格式的日期
 */
- (NSDate *)dateFromDate;
/**
 *  获得当前 NSString 日期对象对应星期
 */
- (NSString *)weekFromDate;

+ (NSString *)getDateDisplayString:(NSString *)time;
- (NSString *)getTheTimeBucket:(NSDate *)date;
@end

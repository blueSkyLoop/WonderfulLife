//
//  NSCalendar+MHCategory.m
//  WonderfulLife
//
//  Created by zz on 10/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "NSCalendar+MHCategory.h"

@implementation NSCalendar (MHCategory)
+ (NSInteger)dayFromDate:(NSDate *)fromDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate];
    return dateComponents.day;
}

+ (NSInteger)daysFromDate:(NSDate *)fromDate {
    NSCalendarUnit rangeOfUnit = NSCalendarUnitDay;
    NSCalendarUnit inUnit = NSCalendarUnitMonth;
    NSRange rangeDays = [[NSCalendar currentCalendar] rangeOfUnit:rangeOfUnit inUnit:inUnit forDate:fromDate];
    return rangeDays.length;
}

+ (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return dateComponents.day;
}

+ (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendarUnit calendarUnit = NSCalendarUnitMonth;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:fromDate toDate:toDate options:0];
    return dateComponents.month + 2;
}

+ (NSDate *)date:(NSDate *)fromDate addMonth:(NSInteger)month {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:fromDate options:0];
}

+ (NSInteger)weekFromMonthFirstDate:(NSDate *)fromDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:calendarUnit fromDate:fromDate];
    dateComponents.day = 1;
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:dateComponents];
    
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate] - 1;
    
    return firstWeekday;
}


@end

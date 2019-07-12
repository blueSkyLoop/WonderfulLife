//
//  NSDate+MHCalendar.m
//  calendarDemo
//
//  Created by zz on 04/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "NSDate+MHCalendar.h"

@implementation NSDate (MHCalendar)

- (NSInteger)dateDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return components.day;
}

- (NSInteger)dateMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return components.month;
}

- (NSInteger)dateYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return components.year;
}

- (NSDate *)previousMonthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 15; // 定位到当月中间日子
    
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    
    NSDate *previousDate = [calendar dateFromComponents:components];
    
    return previousDate;
}

- (NSDate *)nextMonthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 15; // 定位到当月中间日子
    
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    } else {
        components.month += 1;
    }
    
    NSDate *nextDate = [calendar dateFromComponents:components];
    
    return nextDate;
}

- (NSInteger)totalDaysInMonth {
    NSInteger totalDays = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
    return totalDays;
}

- (NSInteger)firstWeekDayInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 1; // 定位到当月第一天
    NSDate *firstDay = [calendar dateFromComponents:components];
    
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay] - 1;
    
    return firstWeekday;
}

- (NSString*)weekdayStringFromDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六",nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (NSString*)weekdayAndMonthFromDate{
    NSString *weekday = [self weekdayStringFromDate];
    NSString *dayFormat = [self stringFromDateFormat:@"M月d日"];
    NSString *weekdayAndMonth = [NSString stringWithFormat:@"%@\n%@",dayFormat,weekday];
    return weekdayAndMonth;
}

- (NSString*)yearAndMonthFromDate{
    NSString *dayFormat = [self stringFromDateFormat:@"yyyy年M月"];
    return dayFormat;
}


- (NSString*)stringFromDateFormat:(NSString *)format{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dayFormat = [dateFormat stringFromDate:self];
    return dayFormat;
}

+ (NSDate *)dateFromStringDate:(NSString *)date format:(NSString *)format{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *dayFormat = [dateFormat dateFromString:date];
    return dayFormat;
}

+ (NSDate *)dateFromString:(NSString *)date {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式,这里可以设置成自己需要的格式
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    dateFormat.timeZone = timeZone;
    return [dateFormat dateFromString:date];
}

- (NSDate *)dateFromDate {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *newDate = [dateFormat stringFromDate:self];
    return [dateFormat dateFromString:newDate];
}


+ (NSString *)weekFromString:(NSInteger)date {
    NSArray *chinese_strs = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    NSString *chineseMonth = [chinese_strs[date - 1] stringByAppendingString:@"月"];
    return chineseMonth;
}

- (NSString *)weekFromDate{
    NSArray *chinese_strs = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    NSInteger date = [self dateMonth];
    NSString *chineseMonth = [chinese_strs[date - 1] stringByAppendingString:@"月"];
    return chineseMonth;
}

+ (NSString *)getDateDisplayString:(NSString *)time{
    
    NSDate *myDate = [NSDate dateFromString:time];
    NSString *timeBucket = [self getTheTimeBucket:time];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init];
    dateFmt.dateFormat = @"MM月dd日";
    
    NSString *date_1 = [dateFmt stringFromDate:myDate];
    
    dateFmt.dateFormat = @"mm";
    NSString *date_2 = [dateFmt stringFromDate:myDate];

    
    return [NSString stringWithFormat:@"%@ %@:%@",date_1,timeBucket,date_2];
}

//获取时间段
+ (NSString *)getTheTimeBucket:(NSString *)date{
    
    NSString *hour = [self getHourForDate:date];
    NSInteger hour_integer = [hour integerValue];
    
    NSString *moon = @"下午";
    if (hour_integer >= 0 && hour_integer <= 12){
        moon =  @"上午";
    }
    
    NSInteger moon_hour = hour_integer;
    if (hour_integer > 12) {
        moon_hour = hour_integer - 12;
    }
    
    return [NSString stringWithFormat:@"%@ %.2ld",moon,(long)moon_hour];
}

+ (NSString *)getHourForDate:(NSString *)date {
    NSArray *dataArray = [date componentsSeparatedByString:@" "];
    NSString *time = dataArray[1];
    NSString *hour = [time componentsSeparatedByString:@":"].firstObject;
    return hour;
}

//将时间点转化成日历形式
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate * destinationDateNow = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

@end

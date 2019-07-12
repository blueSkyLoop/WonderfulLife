//
//  NSDate+ChangeString.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSDate+ChangeString.h"

@implementation NSDate (ChangeString)

+ (NSString *)mh_AllDateWithString:(NSDate *)date{
    return [NSDate mh_dateChangeWithString:date format:@"yyyy-MM-dd"];
}

+ (NSString *)mh_MonthDayWithString:(NSDate *)date{
    return [NSDate mh_dateChangeWithString:date format:@"MM月dd日"];
}

+ (NSString *)mh_YearWithString:(NSDate *)date {
    return [NSDate mh_dateChangeWithString:date format:@"yyyy"];
}

+ (NSInteger)mh_MonthWithString:(NSDate *)date {
    NSString *monthStr = [NSDate mh_dateChangeWithString:date format:@"MM"];
    NSInteger month = [monthStr integerValue];
    return month;
}

+ (NSString *)mh_dateChangeWithString:(NSDate *)date format:(NSString *)format{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    date = [date dateByAddingTimeInterval:-interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

@end

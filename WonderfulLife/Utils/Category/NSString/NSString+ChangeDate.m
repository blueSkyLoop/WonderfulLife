//
//  NSString+ChangeDate.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/31.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSString+ChangeDate.h"

@implementation NSString (ChangeDate)
+ (NSString *)mh_stringChangeDateString:(NSString *)str{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"MM月dd日"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:str];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    date = [date dateByAddingTimeInterval:-interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}



+ (NSDate *)mh_dateFromString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: format];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+ (BOOL)mh_daysAwayFromString:(NSString *)dateFirst dateSecondString:(NSString *)dateSecond format:(NSString *)format
{
    NSDate *firstDate = [NSString mh_dateFromString:dateFirst format:format];
    NSDate *secondDate = [NSString mh_dateFromString:dateSecond format:format];
    
    NSDate *earlierDate = [firstDate earlierDate:secondDate] ;
    
    return [firstDate isEqualToDate:earlierDate] ;
}

// 对比两个日期相差多少天
+  (NSInteger)mh_daysAwayFrom:(NSDate *)dateFirst dateSecond:(NSDate *)dateSecond {
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    return (NSInteger)(([dateFirst timeIntervalSince1970] + timezoneFix)/(24*3600)) - (NSInteger)(([dateSecond timeIntervalSince1970] + timezoneFix)/(24*3600));
}
@end

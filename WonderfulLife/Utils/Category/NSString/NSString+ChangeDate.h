//
//  NSString+ChangeDate.h
//  WonderfulLife
//
//  Created by Lucas on 17/7/31.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ChangeDate)
+ (NSString *)mh_stringChangeDateString:(NSString *)str ;

/**
 *  字符串转日期
 *
 *  @parma    format @"yyyy-MM-dd"
 *
 *  @return  输入的日期字符串形如：@"1992-05-21 13:08:08"
 */
- (NSDate *)mh_dateFromString:(NSString *)dateString format:(NSString *)format ;

/**
 *  判断两个字符串日期，早晚
 *
 *  @parma    format @"yyyy-MM-dd"
 *
 *  @return  YES、NO
 */
+ (BOOL)mh_daysAwayFromString:(NSString *)dateFirst dateSecondString:(NSString *)dateSecond format:(NSString *)format;
@end

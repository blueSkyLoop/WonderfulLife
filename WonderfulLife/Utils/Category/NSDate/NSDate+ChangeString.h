//
//  NSDate+ChangeString.h
//  WonderfulLife
//
//  Created by Lucas on 17/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ChangeString)


/** yyyy-MM-dd hh:mm */
+ (NSString *)mh_AllDateWithString:(NSDate *)date;


+ (NSString *)mh_MonthDayWithString:(NSDate *)date;

/** yyyy */
+ (NSString *)mh_YearWithString:(NSDate *)date ;

/** month*/
+ (NSInteger)mh_MonthWithString:(NSDate *)date ;
@end

//
//  MHCalendarTimeController.h
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MHCalendarBlock)(NSString *date);
@interface MHCalendarTimeController : UIViewController
@property (copy  ,nonatomic) NSString  *calendarTitle;
@property (copy  ,nonatomic) NSString  *didSelectedWeek;
@property (strong,nonatomic) NSDate    *didSelectedDate;
@property (strong,nonatomic) NSDate    *inputTime;
/**
 重置按钮的重置时间
 */
@property (strong,nonatomic) NSDate  *resetDate;
/**
 输出日期格式,若为空，则输出时间格式： yyyy-MM-dd HH:mm
 */
@property (copy ,nonatomic) NSString *outputDateFormat;
@property (copy, nonatomic) MHCalendarBlock block;

@end

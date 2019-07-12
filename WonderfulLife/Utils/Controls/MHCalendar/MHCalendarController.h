//
//  MHCalendarController.h
//  calendarDemo
//
//  Created by zz on 05/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHCalendarType) {
    MHCalendarTypeNormal,
    MHCalendarTypeOnlyDate,
    MHCalendarTypeOnlyDateEnd,
};

typedef void(^MHCalendarBlock)(NSString *date);

@interface MHCalendarController : UIViewController
/**
 控制器标题
 */
@property (copy  ,nonatomic) NSString *calendarTitle;
/**
 是否带时间选择器，默认带时间选择器
 */
@property (assign,nonatomic) MHCalendarType type;
/**
 传入的日期,若为空，则显示当前时间,默认格式： yyyy-MM-dd HH:mm
 */
@property (copy ,nonatomic) NSString *inputDate;
/**
 重置按钮的重置时间
 */
@property (copy ,nonatomic) NSString *resetDate;
/**
 传入的日期格式
 */
@property (copy ,nonatomic) NSString *inputDateFormat;
/**
 输出日期格式,若为空，则输出时间格式： yyyy-MM-dd HH:mm
 */
@property (copy ,nonatomic) NSString *outputDateFormat;
/**
 选择日期回调
 */
@property (copy, nonatomic) MHCalendarBlock block;
@end

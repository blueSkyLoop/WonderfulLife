//
//  MHMonthCalendarController.h
//  WonderfulLife
//
//  Created by zz on 10/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MHYMCalendarBlock)(NSString *date);

@interface MHYMCalendarController : UIViewController
/**
 控制器标题
 */
@property (copy  ,nonatomic) NSString *calendarTitle;

/**传入的日期,若为空，则显示当前时间,默认格式： yyyy-MM-dd*/
@property (copy ,nonatomic) NSString *inputDate;

/**传入的日期格式*/
@property (copy ,nonatomic) NSString *inputDateFormat;

/**返回日期格式,若为空，则输出时间格式： yyyy-MM-dd*/
@property (copy ,nonatomic) NSString *outputDateFormat;

/** 选择日期回调 */
@property (copy, nonatomic) MHYMCalendarBlock block;


@end


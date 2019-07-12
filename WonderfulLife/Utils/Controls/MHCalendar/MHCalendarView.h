//
//  MHCalendarView.h
//  WonderfulLife
//
//  Created by zz on 10/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHCalendarViewDataSource <NSObject>
@required
// 日历的最小日期
- (NSDate *)minimumDateForCalendar;
// 日历的最大日期
- (NSDate *)maximumDateForCalendar;
@optional
// 预设选择日期
- (NSDate *)defaultSelectDate;
// 预设重置日期
- (NSDate *)defaultResetToDate;
@end

@protocol MHCalendarViewDelegate <NSObject>
@optional
// 回传所选择的日期为 NSDate 类型
- (void)selectNSDateFromDate:(NSDate *)date;
// 回传所选择的日期为 NSString 型別
- (void)selectNSStringFromDate:(NSString *)date;
@end

@interface MHCalendarView : UIView
@property (weak, nonatomic) id<MHCalendarViewDataSource> dataSource;
@property (weak, nonatomic) id<MHCalendarViewDelegate> delegate;

// delagate 回传的日期格式，预设格式 yyyy-MM-dd
@property (strong, nonatomic) NSString *formatString;

// 清除所有选择的日期
- (void)clear;

- (void)reloadResetData;


- (void)resetSelectDateAnimated:(BOOL)flag;
@end

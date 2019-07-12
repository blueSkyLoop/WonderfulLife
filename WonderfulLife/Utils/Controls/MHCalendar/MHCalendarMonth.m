//
//  MHCalendarMonth.m
//  calendarDemo
//
//  Created by zz on 04/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCalendarMonth.h"
#import "NSDate+MHCalendar.h"

@implementation MHCalendarMonth

- (instancetype)initWithDate:(NSDate *)date {
    
    if (self = [super init]) {
        
        _monthDate = date;
        
        _totalDays = [self setupTotalDays];
        _firstWeekday = [self setupFirstWeekday];
        _year = [self setupYear];
        _month = [self setupMonth];
        
    }
    
    return self;
    
}


- (NSInteger)setupTotalDays {
    return [_monthDate totalDaysInMonth];
}

- (NSInteger)setupFirstWeekday {
    return [_monthDate firstWeekDayInMonth];
}

- (NSInteger)setupYear {
    return [_monthDate dateYear];
}

- (NSInteger)setupMonth {
    return [_monthDate dateMonth];
}


@end

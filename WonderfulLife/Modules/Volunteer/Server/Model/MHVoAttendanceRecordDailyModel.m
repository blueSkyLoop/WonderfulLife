//
//  MHVoAttendanceRecordDailyModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRecordDailyModel.h"

@implementation MHVoAttendanceRecordDailyMonthModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"actions" : [MHVoAttendanceRecordDailyActionModel class],
             };
}

@end

@implementation MHVoAttendanceRecordDailyActionModel



@end


@implementation MHVoAttendanceRecordMonthModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"crews" : [MHVoAttendanceRecordDetailCrewModel class],
             };
}

@end

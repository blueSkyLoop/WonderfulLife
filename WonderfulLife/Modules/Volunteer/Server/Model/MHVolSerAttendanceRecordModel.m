//
//  MHVolSerAttendanceRecordModel.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerAttendanceRecordModel.h"
#import <YYModel.h>

@implementation MHVolSerAttendanceRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"records_by_day" : MHVolSerAttendanceRecordByDayModel.class,
             @"records_by_month" : MHVolSerAttendanceRecordByMonthModel.class,
           };
}
@end

@implementation MHVolSerAttendanceRecordByDayModel : NSObject
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attendance_list" : MHVolSerAttendanceRecordByDayDetailModel.class,
             };
}
@end

@implementation MHVolSerAttendanceRecordByDayDetailModel : NSObject

@end


@implementation MHVolSerAttendanceRecordByMonthModel : NSObject
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attendance_list" : MHVolSerAttendanceRecordDetailByUserModel.class
             };
}
@end

@implementation MHVolSerAttendanceRecordDetailByUserModel : NSObject
@end

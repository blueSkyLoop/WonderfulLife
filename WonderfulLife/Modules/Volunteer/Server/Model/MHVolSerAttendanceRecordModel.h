//
//  MHVolSerAttendanceRecordModel.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHVolSerAttendanceRecordByDayDetailModel,MHVolSerAttendanceRecordByDayModel;
@class MHVolSerAttendanceRecordByMonthModel,MHVolSerAttendanceRecordDetailByUserModel;

@interface MHVolSerAttendanceRecordModel : NSObject

/** y表示查询的时间范围已经在用户注册时间之前, n则相反 */
@property (nonatomic, copy) NSString *query_finished;

/** 考勤相关数据（按日） */
@property (nonatomic, strong) NSArray <MHVolSerAttendanceRecordByDayModel*>*records_by_day;

/** 考勤相关数据（按月） */
@property (nonatomic, strong) NSArray <MHVolSerAttendanceRecordByMonthModel*>*records_by_month;
@end


@interface MHVolSerAttendanceRecordByDayModel : NSObject
/** 时间 */
@property (nonatomic, copy) NSString *month;

/** 考勤明细数据 */
@property (nonatomic, strong) NSArray <MHVolSerAttendanceRecordByDayDetailModel*>*attendance_list;

@end

@interface MHVolSerAttendanceRecordByDayDetailModel : NSObject
/** 考勤记录id */
@property (nonatomic, strong) NSNumber *attendance_id;

/** 服务日期 */
@property (nonatomic, copy) NSString *service_date;

/** 考勤人数 */
@property (nonatomic, copy) NSString *number_of_people;

@end


@interface MHVolSerAttendanceRecordByMonthModel : NSObject
/** 时间 */
@property (nonatomic, copy) NSString *month;

/** 考勤明细数据 */
@property (nonatomic, strong) NSArray <MHVolSerAttendanceRecordDetailByUserModel*>*attendance_list;

@end


/** 志愿者考勤明细 */
@interface MHVolSerAttendanceRecordDetailByUserModel : NSObject
/** 姓名 */
@property (nonatomic, copy) NSString *real_name;

/** 服务时长 */
@property (nonatomic, strong) NSNumber *service_time;

/** 积分 */
@property (nonatomic, strong) NSNumber *score;

/** 用户ID */
@property (nonatomic, strong) NSNumber *user_id;

/** String	0	0表示队员，1表示队长 2表示总队长
 */
@property (nonatomic, copy) NSString *is_captain;


/** 别名*/
@property (nonatomic, copy)   NSString * role_name;

/** 头像url*/
@property (nonatomic, copy)   NSString * headphoto_s_url;

@end

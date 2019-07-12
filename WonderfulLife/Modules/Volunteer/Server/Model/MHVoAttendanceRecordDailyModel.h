//
//  MHVoAttendanceRecordDailyModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHVoAttendanceRecordDetailModel.h"
@class MHVoAttendanceRecordDailyActionModel,MHVoAttendanceRecordDailyMonthModel;


@interface MHVoAttendanceRecordDailyMonthModel : NSObject
@property (nonatomic,copy) NSString *year_month;

@property (nonatomic,strong) NSArray <MHVoAttendanceRecordDailyActionModel *>*actions;
@end

@interface MHVoAttendanceRecordDailyActionModel : NSObject

@property (nonatomic,strong) NSNumber *attendance_id;
@property (nonatomic,copy) NSString *date_begin;
@property (nonatomic,copy) NSString *date_end;
@property (nonatomic,copy) NSString *team_name;
@property (nonatomic,copy) NSString *addr;

/** 活动名额 */
@property (nonatomic,copy) NSString *qty;
/** 0:待审核
 1:审核通过
 2:审核不通过 */
@property (nonatomic,strong) NSNumber *attendance_status;

@end



@interface MHVoAttendanceRecordMonthModel : NSObject
@property (nonatomic,copy) NSString *year_month;

@property (nonatomic,strong) NSArray <MHVoAttendanceRecordDetailCrewModel *>*crews;
//@property (nonatomic,assign) <#Class#> <#property#>;

@end

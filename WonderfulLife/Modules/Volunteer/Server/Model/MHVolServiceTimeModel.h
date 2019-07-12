//
//  MHVolServiceTimeModel.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//   服务时长

#import <Foundation/Foundation.h>
@class MHVolServiceTimePerMonth , MHVolServiceTimePerMonthDetail;
@interface MHVolServiceTimeModel : NSObject

/** 总服务时长 */
@property (nonatomic, strong) NSNumber  *total_service_time;

/** 考勤相关数据 */
@property (nonatomic, strong) NSMutableArray  <MHVolServiceTimePerMonth *>*attendance_records;

/** y|n	y表示查询已经到达最后一条记录，n表示尚未到达 */
@property (nonatomic, copy)   NSString * query_finished;


@end



@interface MHVolServiceTimePerMonth : NSObject

/** 2017年6月	时间 */
@property (nonatomic, copy)   NSString * month;

/** 10	月服务时长 */
@property (nonatomic, strong) NSNumber  *current_month_service_time;

/** 考勤明细数据 */
@property (nonatomic, strong) NSArray  <MHVolServiceTimePerMonthDetail *>*attendance_list;

@end


@interface MHVolServiceTimePerMonthDetail : NSObject

/** 治安巡逻	服务工作内容名称(考勤类型) */
@property (nonatomic, copy)   NSString * activity_item_name;

/** 服务日期 */
@property (nonatomic, strong) NSDate  *service_date;

/** 服务时长 */
@property (nonatomic, strong) NSNumber  *service_time;

/** 考勤明细ID*/
@property (nonatomic, strong) NSNumber  *attendance_detail_id;

@end

//
//  MHVoAttendanceRecordDetailModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHAliyunManager.h"

@class MHVoAttendanceRecordDetailCrewModel;

@interface MHVoAttendanceRecordDetailModel : NSObject
@property (nonatomic,strong) NSNumber *attendance_id;
/** 0表示队员，1表示分队长，2表示总队长 */
@property (nonatomic,strong) NSNumber *role_in_team;
@property (nonatomic,copy) NSString *score_rule_method;
@property (nonatomic,copy) NSString *action_total_score;
@property (nonatomic,copy) NSString *action_total_duration;
@property (nonatomic,strong) NSArray <MHOOSImageModel *>*imgs;
/** 考勤备注 */
@property (nonatomic,copy) NSString *remark;
/** 审核理由 */
@property (nonatomic,copy) NSString *audit_remark;

@property (nonatomic,assign) BOOL has_virtual_account;

/** 活动介绍 */
@property (nonatomic,copy) NSString *action_intro;
@property (nonatomic,strong) NSArray <MHVoAttendanceRecordDetailCrewModel *>*applied_crews;
@property (nonatomic,strong) NSArray <MHVoAttendanceRecordDetailCrewModel *>*not_apply_crews;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *team_name;
@property (nonatomic,copy) NSString *date_begin;
@property (nonatomic,copy) NSString *date_end;
@property (nonatomic,copy) NSString *addr;
/** 活动名额 */
@property (nonatomic,copy) NSString *qty;

/** 0:待审核,1:审核通过,2:审核不通过 */
@property (nonatomic,copy) NSNumber *attendance_status;
@property (nonatomic,strong) MHVoAttendanceRecordDetailCrewModel *ordinary_crew_attendance;


/** 辅助属性 */

/** 活动介绍高 */
@property (nonatomic,assign) float acInHeight;
/** 考勤备注高 */
@property (nonatomic,assign) float AtReHeight;
/** 审核理由高 */
@property (nonatomic,assign) float auReHeight;
/** 活动地址高 */
@property (nonatomic,assign) float acAdHeight;
@end



@interface MHVoAttendanceRecordDetailCrewModel : NSObject
@property (nonatomic,strong) NSNumber *attendance_detail_id;
@property (nonatomic,strong) NSNumber *volunteer_id;
@property (nonatomic,copy) NSString *volunteer_name;
@property (nonatomic,strong) NSString *pinyin;//拼音
@property (nonatomic,copy) NSString *duration;
@property (nonatomic,copy) NSString *score;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString *headphoto_s_url;

/** 辅助属性 */
@property (nonatomic,assign) BOOL selected;

/**用于记录是否递增状态 ； 递增 ： YES   递减 : NO*/
@property (nonatomic, assign) BOOL isIncreasing;

/** 修改时间 */
@property (nonatomic,assign) CGFloat modifyTime;
@property (nonatomic,copy) NSString *orginDuration;

/** 承包制分配时间 */
@property (nonatomic,assign) CGFloat registerAllocTime;
@property (nonatomic,assign) CGFloat registerAllocScore;

@end






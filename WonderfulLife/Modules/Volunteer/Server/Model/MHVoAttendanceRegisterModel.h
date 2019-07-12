//
//  MHVoAttendanceRegisterModel.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHVoAttendanceRecordDetailModel.h"

@interface MHVoAttendanceRegisterModel : NSObject
/** 0：按考勤类型计算 1：按人员计算 2：按承包制 3：按次 4：按时长 */
@property (nonatomic,copy) NSString *score_rule_method;
/** 活动总积分 */
@property (nonatomic,copy) NSString *action_total_score;
/** 活动总时长 */
@property (nonatomic,copy) NSString *action_total_duration;
/** 已报名人员列表*/
@property (nonatomic,strong) NSArray <MHVoAttendanceRecordDetailCrewModel *> *applied;
/** 未报名人员列表*/
@property (nonatomic,strong) NSArray <MHVoAttendanceRecordDetailCrewModel *> *not_apply;
@property (nonatomic,strong) NSMutableArray <MHVoAttendanceRecordDetailCrewModel *> *selected_not_apply;
@property (nonatomic,assign) BOOL has_virtual_account;


/** 辅助属性 */

/** 未分配积分 */
@property (nonatomic,assign) CGFloat unAllocScore;

/** 备注 */
@property (nonatomic,copy) NSString *remarks;

///** 已经登记多少人 */
//@property (nonatomic,assign) NSInteger hasRegisterCount;

/** 修改详情 */

@property (nonatomic,strong) NSNumber *attendance_id;
@property (nonatomic,strong) NSArray <MHOOSImageModel *>*imgs;
@property (nonatomic,strong) NSMutableArray <MHOOSImageModel *>*tempImgs;

@property (nonatomic,strong) NSMutableArray <MHOOSImageModel *>*deleted_imgs;

@end

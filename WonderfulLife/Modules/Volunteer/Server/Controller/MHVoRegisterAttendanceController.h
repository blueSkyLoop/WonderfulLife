//
//  MHVoRegisterAttendanceController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /**  时长登记考勤 */
    MHVoRegisterAttendanceControllerTypeRegister,
    
    /** 时长的修改考勤 */
    MHVoRegisterAttendanceControllerTypeModify,
    
    /** 积分登记考勤 */
    MHVoRegisterAttendanceControllerTypeContract,
    
    /** 积分修改考勤 */
    MHVoRegisterAttendanceControllerTypeContractModify,
} MHVoRegisterAttendanceControllerType;

@class MHVoAttendanceRegisterModel;

@interface MHVoRegisterAttendanceController : UIViewController
@property (nonatomic,assign) MHVoRegisterAttendanceControllerType type;
@property (strong,nonatomic) NSNumber  *action_team_ref_id;

@property (nonatomic,strong) MHVoAttendanceRegisterModel *model;

@end

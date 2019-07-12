//
//  MHVoAttendanceRecordDetailController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVoAttendanceRecordDetailModel;



@interface MHVoAttendanceRecordDetailController : UIViewController
@property (nonatomic,strong) NSNumber *action_team_ref_id;

@property (nonatomic,strong) MHVoAttendanceRecordDetailModel *model;
@end

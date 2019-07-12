//
//  MHVoAttendenceRecordsController.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoAttendanceRecordsController : UIViewController

@property (nonatomic, strong) NSNumber *attendance_id;
@property (nonatomic, copy) NSString *id_type;


/** 此处有坑，0表示队员，1表示分队长，2表示总队长*/
@property (nonatomic,strong) NSNumber *role_in_team;
- (void)refresh;
@end

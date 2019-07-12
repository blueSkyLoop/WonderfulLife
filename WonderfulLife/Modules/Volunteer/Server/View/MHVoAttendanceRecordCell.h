//
//  MHVoAttendanceRecordCell.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MHVoAttendanceRecordDailyActionModel;


@protocol MHVoAttendanceRecordCellDelegate <NSObject>
- (void)cellButtonDidClick:(MHVoAttendanceRecordDailyActionModel *)model;
@end

@interface MHVoAttendanceRecordCell : UITableViewCell

/** 此处有坑，0表示队员，1表示分队长，2表示总队长*/
@property (nonatomic,strong) NSNumber *role_in_team;
@property (nonatomic,strong) MHVoAttendanceRecordDailyActionModel *model;
@property (nonatomic,weak) id<MHVoAttendanceRecordCellDelegate> delegate;

@end

//
//  MHVoseAttendanceRecordMonCell.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHVoAttendanceRecordDetailCrewModel;

typedef enum : NSUInteger {
    MHVoseAttendanceRecordMonCellTypeNewContract, // 显示积分制
    MHVoseAttendanceRecordMonCellTypeOne,       // 显示时长制
} MHVoseAttendanceRecordMonCellType;

@interface MHVoseAttendanceRecordMonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (nonatomic,assign) CGFloat timeCenterX;
@property (nonatomic,assign) CGFloat scoreCenterX;
@property (nonatomic,assign) MHVoseAttendanceRecordMonCellType type;

@property (nonatomic,strong) MHVoAttendanceRecordDetailCrewModel *model;
@property (nonatomic,strong) MHVoAttendanceRecordDetailCrewModel *dataModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

@interface MHVoAttendanceRecordEmptyCell : UITableViewCell

@end

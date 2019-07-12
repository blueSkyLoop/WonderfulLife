//
//  MHVoSeAttendanceRecordDayDetailCell.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHVolSerAttendanceRecordDetailByUserModel;
@interface MHVoSeAttendanceRecordDayDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong) MHVolSerAttendanceRecordDetailByUserModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

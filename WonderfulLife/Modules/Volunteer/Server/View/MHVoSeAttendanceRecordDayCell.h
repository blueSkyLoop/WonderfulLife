//
//  MHVoSeAttendanceRecordDayCell.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHVolSerAttendanceRecordByDayDetailModel;

@interface MHVoSeAttendanceRecordDayCell : UITableViewCell
@property (nonatomic, strong) MHVolSerAttendanceRecordByDayDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

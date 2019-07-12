//
//  MHVoSeAttendanceRecordDayDetailCell.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeAttendanceRecordDayDetailCell.h"

#import "MHVolSerAttendanceRecordModel.h"
#import "UIView+MHFrame.h"
#import "MHMacros.h"
#import <Masonry.h>
#import "NSObject+isNull.h"
#import "UIImageView+WebCache.h"
@interface MHVoSeAttendanceRecordDayDetailCell ()
@property (nonatomic, weak) IBOutlet UILabel *captainLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captainLabWidth;

@property (weak, nonatomic) IBOutlet UIImageView *headerView;


@end
@implementation MHVoSeAttendanceRecordDayDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"CellId";
    MHVoSeAttendanceRecordDayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVoSeAttendanceRecordDayDetailCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _captainLab.textColor = MColorBlue;
    _captainLab.textAlignment = NSTextAlignmentCenter;
    _captainLab.layer.masksToBounds = YES;
    _captainLab.layer.cornerRadius = 3;
    _captainLab.layer.borderColor = MColorBlue.CGColor;
    _captainLab.layer.borderWidth = 1;
    _captainLab.hidden = YES;
    
    self.headerView.layer.cornerRadius = 20;
    self.headerView.layer.masksToBounds = YES;
}

#pragma mark - Setter
- (void)setModel:(MHVolSerAttendanceRecordDetailByUserModel *)model {
    _model = model;
    
    self.nameLab.text = _model.real_name;
    self.timeLab.text = [NSString stringWithFormat:@"%@小时", _model.service_time];
    if (![NSObject isNull:_model.role_name]) {
        self.captainLab.text =  _model.role_name;
    }
    
    if ([_model.is_captain isEqualToString:@"0"]) {
        self.captainLab.hidden = YES;
    } else if ([_model.is_captain isEqualToString:@"1"]) {
//        self.captainLab.text = @"队长";
         self.captainLabWidth.constant = 35;
        self.captainLab.hidden = NO;
    } else if ([_model.is_captain isEqualToString:@"2"]) {
//        self.captainLab.text = @"总队长";
        self.captainLabWidth.constant = 50;
        self.captainLab.hidden = NO;
    }
     [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.headphoto_s_url]];
}



@end

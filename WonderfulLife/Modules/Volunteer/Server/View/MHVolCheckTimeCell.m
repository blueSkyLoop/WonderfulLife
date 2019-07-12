//
//  MHVolCheckTimeCell.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolCheckTimeCell.h"

#import "MHVolServiceTimeModel.h"

#import "NSDate+ChangeString.h"



@interface MHVolCheckTimeCell()
// 服务时长
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *dataLB;

// 查考勤
@property (weak, nonatomic) IBOutlet UILabel *checkDataLB;



@property (weak, nonatomic) IBOutlet UILabel *hoursLB;
@end

@implementation MHVolCheckTimeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * cellID = @"MHVolCheckTimeCell";
    MHVolCheckTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    
    return cell;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.VolCheckType == MHVolCheckTimeNormal) {
        self.nameLB.hidden = NO;
        self.dataLB.hidden = NO;
        self.checkDataLB.hidden = YES;
    }else{
        self.nameLB.hidden = YES;
        self.dataLB.hidden = YES;
        self.checkDataLB.hidden = NO;
    }
}


- (void)setModel:(MHVolServiceTimePerMonthDetail *)model{
    _model = model;
    self.nameLB.text = model.activity_item_name;
    self.dataLB.text =  [NSDate mh_AllDateWithString:model.service_date];
    self.hoursLB.text = [NSString stringWithFormat:@"%@小时",[model.service_time stringValue]];
    self.checkDataLB.text = [NSDate mh_MonthDayWithString:model.service_date];
    
    self.checkDataLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    self.hoursLB.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    
    
}


@end

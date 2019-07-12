//
//  MHVoSeAttendanceRecordDayCell.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeAttendanceRecordDayCell.h"

#import "MHVolSerAttendanceRecordModel.h"

@interface MHVoSeAttendanceRecordDayCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@end

@implementation MHVoSeAttendanceRecordDayCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"CellId";
    MHVoSeAttendanceRecordDayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVoSeAttendanceRecordDayCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(MHVolSerAttendanceRecordByDayDetailModel *)model {
    _model = model;
    
    if (_model) {
        self.numberLab.hidden = NO;
        self.rightArrow.hidden = NO;
        
        NSArray *dateArray = [model.service_date componentsSeparatedByString:@"-"];
        self.dateLab.text = [NSString stringWithFormat:@"%@月%@日", dateArray[1], dateArray[2]];
        self.numberLab.text = [NSString stringWithFormat:@"考勤%@人", _model.number_of_people];
    }else {
        self.dateLab.text = @"暂无记录";
        self.numberLab.hidden = YES;
        self.rightArrow.hidden = YES;
    }
    
}

@end

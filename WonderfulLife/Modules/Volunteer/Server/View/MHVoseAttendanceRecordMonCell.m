//
//  MHVoseAttendanceRecordMonCell.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoseAttendanceRecordMonCell.h"

#import "MHVoAttendanceRecordDetailModel.h"

#import "MHMacros.h"
#import "UIView+NIM.h"
#import "UIImageView+WebCache.h"
#import "NSObject+isNull.h"
@interface MHVoseAttendanceRecordMonCell ()
@property (weak, nonatomic) IBOutlet UILabel *captainLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation MHVoseAttendanceRecordMonCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _captainLab.hidden = YES;
    _captainLab.textColor = MColorBlue;
    _captainLab.layer.masksToBounds = YES;
    _captainLab.layer.cornerRadius = 3;
    _captainLab.layer.borderColor = MColorBlue.CGColor;
    _captainLab.layer.borderWidth = 1;
    
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
}


- (void)setModel:(MHVoAttendanceRecordDetailCrewModel *)model {
    _model = model;
    
    _nameLab.text  = _model.volunteer_name;
    if (self.type == MHVoseAttendanceRecordMonCellTypeOne) {
        _timeLab.hidden = YES;
        
        _scoreLab.text = model.duration;
        
    }else{
        _timeLab.hidden = YES;
        
        _scoreLab.text = model.score;
//        _timeLab.hidden = NO;
//        _scoreLab.text = model.score;
//        _timeLab.text = model.duration;
    }
    
    if ([model.tag isEqualToString:@"队长"]) {
        _captainLab.hidden = NO;
        _nameLab.nim_top = 14;
    }else{
        _captainLab.hidden = YES;
        _nameLab.nim_centerY = 40;
    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headphoto_s_url]];
}

-(void)setDataModel:(MHVoAttendanceRecordDetailCrewModel *)dataModel{
    _dataModel = dataModel;
    
    if ([dataModel.tag isEqualToString:@"队长"]) {
        [self captainType:0];
    }else if ([dataModel.tag isEqualToString:@"总队长"]){
        [self captainType:1];
    }else{
        _captainLab.hidden = YES;
        _nameLab.nim_centerY = 40;
    }
    _scoreLab.text = dataModel.score;
    _timeLab.text = dataModel.duration;
    _nameLab.text = dataModel.volunteer_name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:dataModel.headphoto_s_url]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_timeLab sizeToFit];
    [_scoreLab sizeToFit];
    self.timeLab.nim_centerX = self.timeCenterX;
    self.scoreLab.nim_centerX = self.scoreCenterX;
    self.nameLab.nim_width = self.timeLab.nim_left-6 - self.nameLab.nim_left;
}

- (void)captainType:(NSInteger )type{
    self.nameLab.nim_top = 14;
    self.captainLab.hidden = false;
    if (type == 0) {
        _captainLab.textColor = MColorBlue;
        _captainLab.layer.borderColor = MColorBlue.CGColor;
        _captainLab.text = @"队长";
    }else{
        _captainLab.textColor = MColorGeneralLeader;
        _captainLab.layer.borderColor = MColorGeneralLeader.CGColor;
        _captainLab.text = @"总队长";
    }
}
@end




@interface MHVoAttendanceRecordEmptyCell ()

@end

@implementation MHVoAttendanceRecordEmptyCell

#pragma mark - override
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24*MScale, 24, 149, 25)];
        [self.contentView addSubview:label];
        label.text = @"本月暂无考勤记录";
        label.textColor = MColorFootnote;
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    }
    return self;
}

@end



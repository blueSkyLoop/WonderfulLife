//
//  MHVoAttendanceRecordCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRecordCell.h"
#import "MHVoAttendanceRecordDailyModel.h"
#import "MHMacros.h"
#import "MHVolunteerUserInfo.h"
@interface MHVoAttendanceRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation MHVoAttendanceRecordCell

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    self.submitBtn.layer.borderColor = MColorTitle.CGColor;
    self.submitBtn.layer.cornerRadius = 2;
    self.submitBtn.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setModel:(MHVoAttendanceRecordDailyActionModel *)model{
    _model = model;
    self.dateLabel.text = [model.date_begin componentsSeparatedByString:@" "].firstObject;
    self.startTimeLabel.text = model.date_begin;
    self.endTimeLabel.text = model.date_end;
    self.teamLabel.text = model.team_name;
    self.addressLabel.text = model.addr;
    self.countLabel.text = model.qty;
    if (model.attendance_status.integerValue == 0 ) {
        self.statusLabel.text = @"待审核";
        self.statusLabel.textColor = MColorBlue;
       [self.submitBtn setTitle:@"修改考勤" forState:UIControlStateNormal];
    }else if (model.attendance_status.integerValue == 1){
        self.statusLabel.text = @"已通过";
        self.statusLabel.textColor = MColorFootnote;
    }else if (model.attendance_status.integerValue == 2){
        self.statusLabel.text = @"不通过";
        self.statusLabel.textColor = MColorRed;
        [self.submitBtn setTitle:@"重新提交" forState:UIControlStateNormal];
    }
    
    
    // 队员身份，不显示人数信息
    self.lastLabel.hidden = !self.role_in_team.integerValue;
    self.countLabel.hidden = !self.role_in_team.integerValue;
    self.contentHeight.constant = self.role_in_team.integerValue ? 189 : 156;

    // 队长身份、活动状态！= “已通过”，都可以操作 登记考勤： “修改”、“重新提交”
    if (model.attendance_status.integerValue != 1 && self.role_in_team.integerValue == 1) {
        self.submitBtn.hidden = NO;
//        [self changeSubmitViewStatus:NO];
        self.contentHeight.constant = 189 ;
    }else {
        self.submitBtn.hidden = YES;
//        [self changeSubmitViewStatus:YES];
        if (self.role_in_team.integerValue != 0) {
            
            self.contentHeight.constant = 189;
            
        }else {
            self.contentHeight.constant = 156;
        }
    }
}


- (void)changeSubmitViewStatus:(BOOL)isHidden {
    self.btnView.hidden = isHidden ;
    self.bottomView.hidden = isHidden ;
}

#pragma mark - 按钮点击

- (IBAction)buttonDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellButtonDidClick:)] ) {
        [self.delegate cellButtonDidClick:_model];
    }
}
#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end








//
//  MHAttendanceRegisterTableViewCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAttendanceRegisterTableViewCell.h"
#import "MHMacros.h"
#import "NSString+Number.h"
#import "MHVoAttendanceRecordDetailModel.h"

#import "UIImageView+WebCache.h"

@interface MHAttendanceRegisterTableViewCell (){
    CGFloat time;
}
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constrainsts;

@property (weak, nonatomic) IBOutlet UILabel *captainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *pointButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;

@end

@implementation MHAttendanceRegisterTableViewCell

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    time = self.timeLabel.text.floatValue;
    if (MScreenW == 320) {
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.constrainsts enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL * _Nonnull stop) {
            constraint.constant = 16;
        }];
    }
    
    _captainLabel.layer.masksToBounds = YES;
    _captainLabel.layer.cornerRadius = 3;
    _captainLabel.layer.borderWidth = 1;
    
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setModel:(MHVoAttendanceRecordDetailCrewModel *)model{
    _model = model;
    if (self.type == MHAttendanceRegisterTableViewCellTypeModify) {
        time = model.modifyTime;
    }else{
        time = model.registerAllocTime;
    }
    if ([model.tag isEqualToString:@"队长"]) {
        [self captainType:0];
    }else if ([model.tag isEqualToString:@"总队长"]){
        [self captainType:1];
    }else{
        self.nameTop.priority = UILayoutPriorityDefaultLow;
        self.nameCenterY.priority = UILayoutPriorityDefaultHigh;
        self.captainLabel.hidden = true;
    }
    
    self.nameLabel.text = model.volunteer_name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headphoto_s_url] placeholderImage:MAvatar];
    self.timeLabel.text = time == (NSInteger)time ? [NSString stringWithFormat:@"%zd",(NSInteger)time] : [NSString stringWithFormat:@"%.1f",time];
    
    self.minusButton.hidden = (!time || time==0.5);
    self.pointButton.selected = !(time==(NSInteger)time);
    
}

#pragma mark - 按钮点击
- (IBAction)minusOrPlus:(UIButton *)sender {
    if (sender.tag == 0 && time >= 1) {
        _model.isIncreasing = NO;
        time -= 1;
        if (time == 0.5 || time == 0) {
            sender.hidden = YES;
        }
    }else if (sender.tag == 1){
        _model.isIncreasing = YES;
        time += 1;
        if (self.minusButton.isHidden) {
            self.minusButton.hidden = NO;
        }
    }
    [self addDataWithModel];
}

- (IBAction)choose05:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
         _model.isIncreasing = YES;
        time += 0.5;
    }else{
         _model.isIncreasing = NO;
        time -= 0.5;
    }
    
    [self addDataWithModel];
}

// 把点击的时间值，赋值到model 上
- (void)addDataWithModel {
    NSString *string = time == (NSInteger)time ? [NSString stringWithFormat:@"%zd",(NSInteger)time] : [NSString stringWithFormat:@"%.1f",time];
    self.timeLabel.text = string;
    if (self.type == MHAttendanceRegisterTableViewCellTypeModify) {
        _model.modifyTime = time;
        _model.duration = string;
    }else{
        _model.registerAllocTime = time;
        _model.duration = string;
    }
    
    if ([self.delegate respondsToSelector:@selector(recordCrewWithModel:)]) {
        [self.delegate recordCrewWithModel:_model];
    }
}

#pragma mark - delegate

#pragma mark - private
- (void)captainType:(NSInteger )type{
    self.nameTop.priority = UILayoutPriorityDefaultHigh;
    self.nameCenterY.priority = UILayoutPriorityDefaultLow;
    self.captainLabel.hidden = false;
    if (type == 0) {
        _captainLabel.textColor = MColorBlue;
        _captainLabel.layer.borderColor = MColorBlue.CGColor;
        _captainLabel.text = @"队长";
    }else{
        _captainLabel.textColor = MColorGeneralLeader;
        _captainLabel.layer.borderColor = MColorGeneralLeader.CGColor;
        _captainLabel.text = @"总队长";
    }
}
#pragma mark - lazy

@end








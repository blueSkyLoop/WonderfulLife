//
//  MHVoAtReCoScoreFillCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAtReCoScoreFillCell.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHVoAttendanceRecordDetailModel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface MHVoAtReCoScoreFillCell ()

@property (nonatomic,strong) UIView *shapeView;
@property (weak, nonatomic) IBOutlet UILabel *captainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTop;
@end

@implementation MHVoAtReCoScoreFillCell


#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    _captainLabel.textColor = MColorBlue;
    _captainLabel.layer.masksToBounds = YES;
    _captainLabel.layer.cornerRadius = 3;
    _captainLabel.layer.borderColor = MColorBlue.CGColor;
    _captainLabel.layer.borderWidth = 1;
    
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        constraint.constant = constraint.constant *MScale;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setModel:(MHVoAttendanceRecordDetailCrewModel *)model{
    _model = model;
    self.nameLabel.text = model.volunteer_name;
    NSString *score;
    if (model.registerAllocScore == (NSInteger)model.registerAllocScore) {
        score = [NSString stringWithFormat:@"%zd",(NSInteger)model.registerAllocScore];
    }else{
        score = [NSString stringWithFormat:@"%.1f",model.registerAllocScore];
    }
    model.score = score;
    self.scoreField.text = score;
    
    if (model.registerAllocTime == (NSInteger)model.registerAllocTime) {
        NSString *duration = [NSString stringWithFormat:@"%zd",(NSInteger)model.registerAllocTime];
        model.duration = duration;
    }else{
        NSString *duration = [NSString stringWithFormat:@"%.1f",model.registerAllocTime];
        model.duration = duration;
    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headphoto_s_url] placeholderImage:MAvatar];
    
    if ([model.tag isEqualToString:@"队长"]) {
        [self captainType:0];
    }else if ([model.tag isEqualToString:@"总队长"]){
        [self captainType:1];
    }else{
        self.nameTop.priority = UILayoutPriorityDefaultLow;
        self.nameCenterY.priority = UILayoutPriorityDefaultHigh;
        self.captainLabel.hidden = YES;
    }
}
#pragma mark - 按钮点击

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








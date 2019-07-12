//
//  MHVoAttendanceRegisterScoreCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRegisterScoreCell.h"
#import "MHMacros.h"
#import "MHVoAttendanceRegisterModel.h"

@interface MHVoAttendanceRegisterScoreCell ()
@property (weak, nonatomic) IBOutlet UILabel *unAllocLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTop;

@end

@implementation MHVoAttendanceRegisterScoreCell

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.constant = obj.constant*MScale;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private
- (void)setModel:(MHVoAttendanceRegisterModel *)model{
    _model = model;
    self.topLabel.hidden = !model.has_virtual_account;
    self.labelTop.constant = model.has_virtual_account ? 71 : 71-25;
    
    if (_model.unAllocScore >= 0) {
        self.unAllocLabel.textColor = MColorTitle;
        
    }else{
        self.unAllocLabel.textColor = MColorToRGB(0xFC2F39);
    }
    if (_model.unAllocScore == (NSInteger)_model.unAllocScore) {//整数
        self.unAllocLabel.text = [NSString stringWithFormat:@"%zd分",(NSInteger)_model.unAllocScore];
    }else{
        self.unAllocLabel.text = [NSString stringWithFormat:@"%.1f分",_model.unAllocScore];
    }
    if (_model.action_total_score.floatValue == _model.action_total_score.integerValue) {//整数
        self.totalLabel.text = [NSString stringWithFormat:@"%zd分",_model.action_total_score.integerValue];
    }else{
        self.totalLabel.text = [NSString stringWithFormat:@"%.1f分",_model.action_total_score.floatValue];
    }
}

#pragma mark - lazy

@end








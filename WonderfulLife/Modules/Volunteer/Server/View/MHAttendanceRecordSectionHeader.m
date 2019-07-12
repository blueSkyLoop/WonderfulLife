//
//  MHAttendanceRecordSectionHeader.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAttendanceRecordSectionHeader.h"
#import "UIView+NIM.h"
#import "MHMacros.h"

@interface MHAttendanceRecordSectionHeader ()
@property (nonatomic,strong) UIFont *font16;
@property (nonatomic,strong) UIFont *font20;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UIButton *coverButton;

@end

@implementation MHAttendanceRecordSectionHeader

#pragma mark - override
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
        
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, MScreenW, 0.5)];
//        line.backgroundColor = MColorSeparator;
//        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setType:(MHAttendanceRecordSectionHeaderType)type{
    _type = type;
    if (type == MHAttendanceRecordSectionHeaderTypeList) {
        _timeLabel.font = self.font16;
        self.contentView.backgroundColor = MColorDidSelectCell;
        _timeLabel.textColor = MColorTitle;
    }else if (_type == MHAttendanceRecordSectionHeaderTypeListMonth){
        _timeLabel.font = self.font16;
        self.contentView.backgroundColor = MColorDidSelectCell;
        _timeLabel.textColor = MColorTitle;
    }else if (type == MHAttendanceRecordSectionHeaderTypeDetail){
        _timeLabel.font = self.font20;
        self.contentView.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = MColorTitle;
        [_countLabel removeFromSuperview];
        self.arrowImageView.hidden = YES;
        self.coverButton.hidden = YES;

    }else if (type == MHAttendanceRecordSectionHeaderTypePeople){
        _timeLabel.font = self.font20;
        self.contentView.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = MColorTitle;
        self.arrowImageView.hidden = YES;
        self.coverButton.hidden = YES;
        [self.contentView addSubview:self.countLabel];
    }else if (type == MHAttendanceRecordSectionHeaderTypeReject){
        _timeLabel.font = self.font20;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [_countLabel removeFromSuperview];
        _timeLabel.textColor = MColorRed;
    }else if (type == MHAttendanceRecordSectionHeaderTypeOtherMember){
        _timeLabel.font = self.font20;
        self.contentView.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = MColorTitle;
        [self.contentView addSubview:self.countLabel];
        [self.coverButton setHidden:NO];
        self.arrowImageView.hidden = NO;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_timeLabel sizeToFit];
    if (_type == MHAttendanceRecordSectionHeaderTypeList) {
        _timeLabel.nim_left = 18;
    }else if (_type == MHAttendanceRecordSectionHeaderTypeListMonth || _type == MHAttendanceRecordSectionHeaderTypeDetail || _type == MHAttendanceRecordSectionHeaderTypeReject){
        _timeLabel.nim_left = 24*MScale;
    }else if (_type == MHAttendanceRecordSectionHeaderTypePeople){
        _timeLabel.nim_left = 24*MScale;
        
        [_countLabel sizeToFit];
        _countLabel.nim_centerY = self.contentView.nim_height/2;
        _countLabel.nim_right = self.contentView.nim_width - 24;
    }else if (_type == MHAttendanceRecordSectionHeaderTypeOtherMember){
        _timeLabel.nim_left = 24*MScale;
        _coverButton.frame = self.contentView.bounds;
        [_countLabel sizeToFit];
        _countLabel.nim_centerY = self.contentView.nim_height/2;
        _countLabel.nim_right = self.arrowImageView.nim_left;
    }
    _timeLabel.nim_centerY = self.contentView.nim_height/2;
}

#pragma mark - 按钮点击
- (void)buttonDidClick{
    if ([self.delegate respondsToSelector:@selector(sectionHeaderDidClick)]) {
        [self.delegate sectionHeaderDidClick];
    }
}
#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy
- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = MColorTitle;
        
        _countLabel.font = [UIFont systemFontOfSize:18];
    }
    return _countLabel;
}
- (UIFont *)font16{
    if (_font16 == nil) {
        
        if (iOS8) {
            _font16 = [UIFont systemFontOfSize:16];
        }else{
            _font16 = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        }
    }
    return _font16;
}

- (UIFont *)font20{
    if (_font16 == nil) {
        if (iOS8) {
            _font20 = [UIFont systemFontOfSize:20];
        }else{
            _font20 = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        }
    }
    return _font20;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        [_arrowImageView sizeToFit];
        _arrowImageView.nim_origin = CGPointMake(345*MScale, 30);
        [self.contentView addSubview:self.arrowImageView];
    }
    return _arrowImageView;
}

- (UIButton *)coverButton{
    if (_coverButton == nil) {
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_coverButton];
    }
    return _coverButton;
}

@end








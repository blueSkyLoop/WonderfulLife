//
//  MHAttendanceRecordHeader.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAttendanceRecordHeader.h"
#import "MHMacros.h"
#import "UIView+NIM.h"

@interface MHAttendanceRecordHeader ()
@property (nonatomic,strong) UIFont *font;
@end

@implementation MHAttendanceRecordHeader{
    CGPoint titleOriginCenter;
    CGPoint titleFinalCenter;
    CGSize titleOriginSize;
    CGSize titleFinalSize;
}

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 13, 130, 39)];
        
        if (iOS8) {
            _font = [UIFont systemFontOfSize:32];
        }else{
            _font = [UIFont fontWithName:@"PingFangSC-Semibold" size:32];
        }
        _titleLabel.font = _font;
        _titleLabel.textColor = MColorTitle;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_titleLabel];
        
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
    titleOriginSize = CGSizeMake(_titleLabel.intrinsicContentSize.width, 45) ;
    UIFont *tempFont;
    if (iOS8) {
        tempFont = [UIFont systemFontOfSize:17];
    }else{
        tempFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
    }
    _titleLabel.font = tempFont;
    titleFinalSize = CGSizeMake(_titleLabel.intrinsicContentSize.width, 25);
    _titleLabel.font = _font;
    
    _titleLabel.nim_size = titleOriginSize;
    titleOriginCenter = _titleLabel.center;
    titleFinalCenter = CGPointMake(MScreenW/2, 42);
}

#pragma mark - public
- (void)scrollTitleLabelWithScrollView:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < -(-64)) {
        self.nim_top = 64 - (0+offsetY);
        
    }else if (offsetY >= -(-64)){
        self.nim_top = 0;
        self.titleLabel.nim_size = titleFinalSize;
        self.titleLabel.center = titleFinalCenter;
        
    }
    if (offsetY <= -0){
        self.titleLabel.nim_size = titleOriginSize;
        self.titleLabel.center = titleOriginCenter;
    }else if (offsetY > -0 && offsetY< -(0-64)) {
        CGFloat headerTop = 64 - (0+offsetY);
        CGFloat scale = 1 - headerTop/64.00;
        
        CGFloat centerX = titleOriginCenter.x + (titleFinalCenter.x - titleOriginCenter.x)*scale;
        CGFloat centerY = titleOriginCenter.y + (titleFinalCenter.y - titleOriginCenter.y)*scale;
        CGFloat width = titleOriginSize.width - (titleOriginSize.width - titleFinalSize.width)*scale;
        CGFloat height = titleOriginSize.height - (titleOriginSize.height - titleFinalSize.height)*scale;
        self.titleLabel.nim_size = CGSizeMake(width, height);
        self.titleLabel.center = CGPointMake(centerX, centerY);
    }
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

- (void)setType:(MHAttendanceRecordHeaderType)type{
    _type = type;
    if (type == MHAttendanceRecordHeaderTypeAttendanceDetail) {
        self.titleLabel.text = @"考勤详情";
    }else if (type == MHAttendanceRecordHeaderTypeRegisterAttendance){
        self.titleLabel.text = @"登记考勤";
    }else if (type == MHAttendanceRecordHeaderTypeChooseTeam){
        self.titleLabel.text = @"选择服务队";
    }
}
#pragma mark - lazy

@end








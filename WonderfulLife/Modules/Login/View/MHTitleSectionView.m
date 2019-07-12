//
//  MHTitleSectionView.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHTitleSectionView.h"
#import "MHMacros.h"

@implementation MHTitleSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, MScreenW, 32);
        [self addSubview:self.topLine];
        [self addSubview:self.bottomLine];
        [self addSubview:self.titleLabel];
        [self setBackgroundColor:MColorDidSelectCell];
    } return self;
}



- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MScreenW, 1)];
        [_topLine setBackgroundColor:MColorSeparator];
    } return _topLine;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, MScreenW, 1)];
        [_bottomLine setBackgroundColor:MColorSeparator];
    } return _bottomLine;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 6, MScreenW-32, 20)];
        [_titleLabel setTextColor:MColorTitle];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    } return _titleLabel;
}

@end

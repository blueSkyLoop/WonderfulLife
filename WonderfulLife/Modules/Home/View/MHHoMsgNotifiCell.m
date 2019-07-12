//
//  MHHoMsgNotifiCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoMsgNotifiCell.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHHoMsgNotifiModel.h"

@interface MHHoMsgNotifiCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *redPointView;
@property (nonatomic,strong) UIView *bottomLine;
@end

@implementation MHHoMsgNotifiCell{
    CGFloat labelX;
    CGFloat timeLabelTop;
    CGFloat scale;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        scale = MScreenW/375;
        labelX = 16*scale;
        timeLabelTop = 8*scale;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = MFont(18*scale);
        self.titleLabel.textColor = MColorTitle;
        [self.contentView addSubview:self.titleLabel];
        _titleLabel.numberOfLines = 0;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = MFont(12*scale);
        _timeLabel.textColor = MColorFootnote;
        [self.contentView addSubview:_timeLabel];
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = MRGBColor(211, 220, 230);
        [self.contentView addSubview:_bottomLine];
        
        _redPointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHHomeNiticeDot"]];
        [self.contentView addSubview:_redPointView];
        [_redPointView sizeToFit];
    }
    return self;
}

- (void)setModel:(MHHoMsgNotifiModel *)model{
    _model = model;
    
    _timeLabel.text = model.create_datetime;
    _titleLabel.text = model.subject;
    _redPointView.hidden = model.is_read.integerValue;
    
    _titleLabel.nim_size = CGSizeMake(MScreenW-labelX-30*scale, 0);
    _titleLabel.nim_origin = CGPointMake(labelX, labelX);
    [_titleLabel sizeToFit];
    _model.cellHeight = _titleLabel.nim_bottom + 41*scale;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_timeLabel sizeToFit];
    _timeLabel.nim_origin = CGPointMake(labelX, _titleLabel.nim_bottom+timeLabelTop);
    
    _bottomLine.frame = CGRectMake(0, self.contentView.nim_height - 0.5, self.contentView.nim_width, 0.5);
    
    _redPointView.nim_right = self.contentView.nim_width - labelX;
    _redPointView.nim_top = 26*scale;
    
}
@end







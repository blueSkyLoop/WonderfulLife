//
//  MHMineCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineCell.h"
#import <UIImageView+WebCache.h>
#import "MHMacros.h"
#import "UIView+NIM.h"
@interface MHMineCell ()

@property (nonatomic,weak) UIView *line;

@end

@implementation MHMineCell{
    CGFloat scale;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        scale = MScreenW/375;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = MFont(17*scale);
        titleLabel.textColor = MColorTitle;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        [arrowView sizeToFit];
        [self.contentView addSubview:arrowView];
        self.arrowView = arrowView;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.font = titleLabel.font;
        detailLabel.textColor = MRGBColor(132, 146, 166);
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MRGBColor(229, 233, 242);
        [self.contentView addSubview:line];
        self.line = line;
    }
    return self;
}

- (void)setIconWithUrl:(NSString *)user_s_img{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 80*scale/2;
        _iconView.layer.masksToBounds = YES;
        [_iconView sd_setImageWithURL:[NSURL URLWithString:user_s_img] placeholderImage:MAvatar];
        _iconView.nim_size = CGSizeMake(80*scale, 80*scale);
        [self.contentView addSubview:_iconView];
        [self.detailLabel removeFromSuperview];
    }else{
        [_iconView sd_setImageWithURL:[NSURL URLWithString:user_s_img]];
    }
}

- (void)layoutSubviews{
    [self.titleLabel sizeToFit];
    self.titleLabel.nim_left = 24*scale;
    self.titleLabel.nim_centerY = self.contentView.nim_height/2;
    
    self.arrowView.nim_right = self.contentView.nim_width - 24*scale;
    self.arrowView.nim_centerY = self.contentView.nim_height/2;
    
    self.detailLabel.nim_width = self.arrowView.nim_left - 10*scale - self.titleLabel.nim_right;
    [self.detailLabel sizeToFit];
    self.detailLabel.nim_right = self.arrowView.nim_left - 10*scale;
    self.detailLabel.nim_top = self.titleLabel.nim_top;
    
    self.line.frame = CGRectMake(0, self.nim_height-0.5, self.nim_width, 0.5);
    
    _iconView.nim_centerY = self.nim_height/2;
    _iconView.nim_right = self.arrowView.nim_left - 10*scale;
}

//beelin 2017.8.10
#pragma mark - Getter
- (UISwitch *)swi {
    if (!_swi) {
          _swi = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    return _swi;
}
@end






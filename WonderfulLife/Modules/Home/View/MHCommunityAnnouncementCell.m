//
//  MHCommunityAnnouncementCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCommunityAnnouncementCell.h"

#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHCommunityAnnouncementModel.h"
#import "UIImageView+WebCache.h"

@interface MHCommunityAnnouncementCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *pictureView;
@property (nonatomic,strong) UILabel *timeLabel;
@end

@implementation MHCommunityAnnouncementCell{
    CGFloat x;
    CGFloat width;
    CGFloat scale;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        scale = MScreenW/375;
        x = 24*scale;
        width = 295*scale;
        
        self.layer.cornerRadius = 6*scale;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = MColorSeparator.CGColor;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = MFont(18*scale);
        self.titleLabel.textColor = MColorTitle;
        [self.contentView addSubview:self.titleLabel];
        _titleLabel.numberOfLines = 2;
        _titleLabel.frame = CGRectMake(x, 16*scale, width, 0);
        
        _pictureView = [[UIImageView alloc] init];
        [self.contentView addSubview:_pictureView];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = MFont(12*scale);
        _timeLabel.textColor = MColorFootnote;
        [self.contentView addSubview:_timeLabel];
        
        
    }
    return self;
}

- (void)setModel:(MHCommunityAnnouncementModel *)model{
    _model = model;
    _titleLabel.text = model.subject;
    [_titleLabel sizeToFit];
    
    _timeLabel.text = model.post_time;
    [_timeLabel sizeToFit];
    
    if (_model.img_url.length) {
        _pictureView.hidden = NO;
        _pictureView.frame = CGRectMake(x, _titleLabel.nim_bottom+16*scale, 295*scale, 156*scale);
        [_pictureView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@""]];
        _timeLabel.nim_origin = CGPointMake(x, _pictureView.nim_bottom+9*scale);
    }else{
        _pictureView.hidden = YES;
        _timeLabel.nim_origin = CGPointMake(x, _titleLabel.nim_bottom+8*scale);
    }
    
    model.cellHeight = _timeLabel.nim_bottom + 2*24*scale;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y = frame.origin.y + 24*scale;
    frame.origin.x = 16*scale;
    frame.size.width = frame.size.width - 2*frame.origin.x;
    frame.size.height = frame.size.height - 24*scale;
    [super setFrame:frame];
}

@end






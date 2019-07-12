//
//  MHVoRegisOhterMemberCell.m
//  WonderfulLife
//
//  Created by 哈马屁 on 2017/12/6.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoRegisOhterMemberCell.h"
#import "MHVoAttendanceRecordDetailModel.h"
#import "UIImageView+WebCache.h"
#import "MHMacros.h"

@interface MHVoRegisOhterMemberCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MHVoRegisOhterMemberCell

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = 24;
    self.iconView.layer.masksToBounds = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

- (void)setCrewModel:(MHVoAttendanceRecordDetailCrewModel *)crewModel{
    _crewModel = crewModel;
    self.selectedImageView.highlighted = crewModel.selected;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:crewModel.headphoto_s_url] placeholderImage:MAvatar];
    self.nameLabel.text = crewModel.volunteer_name;
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end








//
//  MHVoSerUnJoinTeamCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerUnJoinTeamCell.h"

#import "MHMacros.h"
#import "MHVolSerTeamModel.h"
#import "YYText.h"

@interface MHVoSerUnJoinTeamCell ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UILabel *mh_titleLb;
@property (weak, nonatomic) IBOutlet UILabel *mh_subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_bottomLabel;
@end

@implementation MHVoSerUnJoinTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layerView.layer.cornerRadius = 6;
    self.layerView.layer.borderWidth = 1;
    self.layerView.layer.borderColor = MColorSeparator.CGColor;
    
    self.layerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.layerView.layer.shadowRadius = 5;
    self.layerView.layer.shadowColor = MColorShadow.CGColor;
    self.layerView.layer.shadowOpacity = 1;
    
    self.mh_statusLabel.layer.borderWidth = 1;
    self.mh_statusLabel.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(MHVolSerTeamModel *)model {
    _model = model;
    
    [self.mh_titleLb setText:model.project_name];
    [self.mh_subTitleLabel setText:model.community_name];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.community_name];
    str.yy_kern = @1;
    self.mh_subTitleLabel.attributedText = str;
    if (model.type == MHVolSerTeamApproving) {
        [self.mh_bottomLabel setText:@"等待队长审核通过"];
        self.mh_statusLabel.layer.borderColor = MColorYellow.CGColor;
        [self.mh_statusLabel setTextColor:MColorYellow];
        [self.mh_statusLabel setText:@"审核中"];
    } else if (model.type == MHVolSerTeamUnPass){
        [self.mh_bottomLabel setText:@" 审核不通过 "];
        self.mh_statusLabel.layer.borderColor = MColorRed.CGColor;
        [self.mh_statusLabel setTextColor:MColorRed];
        [self.mh_statusLabel setText:@" 不通过 "];
    }else if (model.type == MHVolSerTeamWithdraw){
        [self.mh_bottomLabel setText:@" 已撤回加入申请 "];
        [self.mh_statusLabel setText:@"已撤回"];
        [self.mh_statusLabel setTextColor:MColorToRGB(0xC0CCDA)];
        self.mh_statusLabel.layer.borderColor = MColorToRGB(0xC0CCDA).CGColor;
    }
}


@end

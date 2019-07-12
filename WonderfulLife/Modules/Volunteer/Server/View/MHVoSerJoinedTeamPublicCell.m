//
//  MHVoSerJoinedTeamPublicCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerJoinedTeamPublicCell.h"

#import "MHMacros.h"
#import "MHVolSerTeamModel.h"
#import "MHWeakStrongDefine.h"

#import "Masonry.h"
#import "YYText.h"

@interface MHVoSerJoinedTeamPublicCell()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UILabel *mh_titleLb;

@property (weak, nonatomic) IBOutlet UILabel *mh_subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *myAttendanceButton;



@end


@implementation MHVoSerJoinedTeamPublicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layerView.layer.cornerRadius = 6;
    self.layerView.layer.borderWidth = 1;
    self.layerView.layer.borderColor = MColorSeparator.CGColor;
    self.layerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.layerView.layer.shadowRadius = 5;
    self.layerView.layer.shadowColor = MColorShadow.CGColor;
    self.layerView.layer.shadowOpacity = 1;
    
    self.mh_roleLabel.layer.cornerRadius = 3;
    self.mh_roleLabel.layer.borderWidth = 1;
}

- (void)setModel:(MHVolSerTeamModel *)model {
    _model = model;
    
    [self.mh_titleLb setText:model.team_name];
    [self.mh_subTitleLabel setText:model.project_summary];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.project_summary];
    attStr.yy_kern = @1;
    
    self.mh_subTitleLabel.attributedText = attStr;

    [self.mh_numberLabel setText:[NSString stringWithFormat:@"%@人",model.people_count]];
    [self.mh_roleLabel setText:model.role_name];
    
    if (model.type == MHVolSerTeamQuit) {// 傻逼后台让我们多做一个判断
        [self.mh_roleLabel setText:@"已退出"];
        [self.mh_roleLabel setTextColor:MColorToRGB(0xC0CCDA)];
        self.mh_roleLabel.layer.borderColor = MColorToRGB(0xC0CCDA).CGColor;
        return;
    }
    
    
    if (model.role_in_team == 0) {//队员
        [self.mh_roleLabel setTextColor:MColorGreen];
        self.mh_roleLabel.layer.borderColor = MColorGreen.CGColor;
    } else if (model.role_in_team == 1) {//队长
        [self.mh_roleLabel setTextColor:MColorBlue];
        self.mh_roleLabel.layer.borderColor = MColorBlue.CGColor;

    } else if (model.role_in_team == 9) {//总队长
        [self.mh_roleLabel setTextColor:MColorRed];
        self.mh_roleLabel.layer.borderColor = MColorRed.CGColor;

    } else {
        
    }
}

@end

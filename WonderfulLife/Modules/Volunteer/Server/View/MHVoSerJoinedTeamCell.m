//
//  MHVoSerJoinedTeamCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerJoinedTeamCell.h"

#import "MHMacros.h"
#import "MHVolSerTeamModel.h"
#import "MHWeakStrongDefine.h"

#import "Masonry.h"
//#import "UILabel+HLLineSpacing.h"
#import "YYText.h"

@interface MHVoSerJoinedTeamCell ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UILabel *mh_titleLb;

@property (weak, nonatomic) IBOutlet UILabel *mh_subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_captainLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_numberLabel;
//@property (weak, nonatomic) IBOutlet UIButton *myAttendanceButton;
//@property (weak, nonatomic) IBOutlet UIButton *teamAttendanceButton;
//@property (weak, nonatomic) IBOutlet UIButton *registAttendanceButton;
//@property (weak, nonatomic) IBOutlet UIView *lineOne;
//@property (weak, nonatomic) IBOutlet UIView *lineTwo;
//@property (weak, nonatomic) IBOutlet UIView *topLine;
@end

@implementation MHVoSerJoinedTeamCell

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
    [self.mh_captainLabel setText:model.captain_name];
    [self.mh_numberLabel setText:[NSString stringWithFormat:@"%@人",model.people_count]];
    [self.mh_roleLabel setText:model.role_name];
    
    if (model.type == MHVolSerTeamQuit) {// 傻逼后台让我们多做一个判断
        [self.mh_roleLabel setText:@"已退出"];
        [self.mh_roleLabel setTextColor:MColorToRGB(0xC0CCDA)];
        self.mh_roleLabel.layer.borderColor = MColorToRGB(0xC0CCDA).CGColor;
//        [self setButtonNumber:1];
        return;
    }
    
    
    if (model.role_in_team == 0) {//队员
        [self.mh_roleLabel setTextColor:MColorGreen];
        self.mh_roleLabel.layer.borderColor = MColorGreen.CGColor;
//        [self setButtonNumber:1];
    } else if (model.role_in_team == 1) {//队长
//        [self.mh_roleLabel setText:@"队长"];
        [self.mh_roleLabel setTextColor:MColorBlue];
        self.mh_roleLabel.layer.borderColor = MColorBlue.CGColor;
        if (model.is_promise_approve) {
//            [self setButtonNumber:3];
        } else {
//            [self setButtonNumber:2];
        }
    } else if (model.role_in_team == 9) {//总队长
//        [self.mh_roleLabel setText:@"总队长"];
        [self.mh_roleLabel setTextColor:MColorRed];
        self.mh_roleLabel.layer.borderColor = MColorRed.CGColor;
//        [self setButtonNumber:3];
    } else {
    
    }
}

/*
- (void)setButtonNumber:(NSInteger)count {
    MHWeakify(self);
    if (count == 1) {
        [self.lineOne mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weak_self.topLine.mas_bottom);
            make.width.equalTo(@0);
            make.right.bottom.equalTo(weak_self.layerView);
            make.trailing.equalTo(weak_self.teamAttendanceButton.mas_leading);
            make.leading.equalTo(weak_self.myAttendanceButton.mas_trailing);
        }];
        [self.lineTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weak_self.lineOne);
            make.trailing.equalTo(weak_self.registAttendanceButton.mas_leading);
            make.leading.equalTo(weak_self.teamAttendanceButton.mas_trailing);
        }];
        
    } else if (count == 2) {
        [self.lineOne mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weak_self.topLine.mas_bottom);
            make.width.equalTo(@1);
            make.bottom.equalTo(weak_self.layerView);
            make.centerX.equalTo(weak_self.layerView.mas_centerX);
            make.trailing.equalTo(weak_self.teamAttendanceButton.mas_leading);
            make.leading.equalTo(weak_self.myAttendanceButton.mas_trailing);
        }];
        [self.lineTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weak_self.topLine.mas_bottom);
            make.width.equalTo(@0);
            make.right.bottom.equalTo(weak_self.layerView);
            make.trailing.equalTo(weak_self.registAttendanceButton.mas_leading);
            make.leading.equalTo(weak_self.teamAttendanceButton.mas_trailing);
        }];
    } else if (count == 3) {
        [self.lineOne mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weak_self.topLine.mas_bottom);
            make.width.equalTo(@1);
            make.bottom.equalTo(weak_self.layerView);
            make.centerX.equalTo(weak_self.layerView.mas_centerX).multipliedBy(2.00/3);
            make.trailing.equalTo(weak_self.teamAttendanceButton.mas_leading);
            make.leading.equalTo(weak_self.myAttendanceButton.mas_trailing);
        }];
        [self.lineTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weak_self.topLine.mas_bottom);
            make.width.equalTo(@1);
            make.bottom.equalTo(weak_self.layerView);
            make.centerX.equalTo(weak_self.layerView.mas_centerX).multipliedBy(4.00/3);
            make.trailing.equalTo(weak_self.registAttendanceButton.mas_leading);
            make.leading.equalTo(weak_self.teamAttendanceButton.mas_trailing);
        }];
    } else {}
}
*/

#pragma mark - action

- (IBAction)myAttendance:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickMyAttendanceButtonAtIndexPath:)]) {
        [self.delegate didClickMyAttendanceButtonAtIndexPath:self.indexPath];
    }
}

- (IBAction)allAttendance:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAllAttendanceButtonAtIndexPath:)]) {
        [self.delegate didClickAllAttendanceButtonAtIndexPath:self.indexPath];
    }
}

- (IBAction)registAttendance:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickRegistAttendanceButtonAtIndexPath:)]) {
        [self.delegate didClickRegistAttendanceButtonAtIndexPath:self.indexPath];
    }
}

@end

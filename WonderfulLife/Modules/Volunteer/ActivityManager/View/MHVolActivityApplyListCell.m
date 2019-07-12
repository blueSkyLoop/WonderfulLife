//
//  MHVolActivityApplyListCell.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityApplyListCell.h"

#import "MHVolActivityApplyListModel.h"

#import "MHMacros.h"
#import "UIView+MHFrame.h"
#import "UIImageView+WebCache.h"
#import "NSObject+isNull.h"
@interface MHVolActivityApplyListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLabCenter;
@property (weak, nonatomic) IBOutlet UILabel *captainLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captainLabWidth;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *alreadyLab;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyBtnWidth;
@end
@implementation MHVolActivityApplyListCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVolActivityApplyListCell";
    MHVolActivityApplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVolActivityApplyListCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
//    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _captainLab.hidden = YES;
    _captainLab.layer.masksToBounds = YES;
    _captainLab.layer.cornerRadius = 3;
    _captainLab.layer.borderWidth = 1;
    
    self.applyBtn.hidden = YES;
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.cornerRadius = 3;
    self.applyBtn.layer.borderWidth = 1;
    
    
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadView:)];
    [self.iconView addGestureRecognizer:tap];
    
}

- (void)tapHeadView:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickIcon:)]) {
        [self.delegate didClickIcon:self.model];
    }
}

- (void)setModel:(MHVolActivityApplyCrew *)model {
    _model = model;
    
    _nameLab.text  = _model.volunteer_name;
    _nameLabCenter.text  = _model.volunteer_name;

    
    if (model.role == 0) {
        self.captainLab.hidden = YES;
        self.nameLab.hidden = YES;
        self.nameLabCenter.hidden = NO;
    } else if (model.role == 1) {
        self.captainLabWidth.constant = 35;
        self.captainLab.hidden = NO;
        self.captainLab.text = @"队长";
        _captainLab.layer.borderColor = MColorBlue.CGColor;
        _captainLab.textColor = MColorBlue;
        self.nameLab.hidden = NO;
        self.nameLabCenter.hidden = YES;
        
    } else if (model.role == 9) {
        self.captainLabWidth.constant = 50;
        self.captainLab.hidden = NO;
        self.captainLab.text = @"总队长";
        _captainLab.layer.borderColor = [UIColor orangeColor].CGColor;
        _captainLab.textColor = [UIColor orangeColor];
        self.nameLab.hidden = NO;
        self.nameLabCenter.hidden = YES;
    }
    
    
    switch (self.type) {
        case MHVolActivityApplyTypeApply:
            self.applyBtn.hidden = NO;
            self.alreadyLab.hidden = YES;
            [self.applyBtn setTitle:@"报名" forState:UIControlStateNormal];
//            [self.applyBtnWidth setConstant:59.0];
            break;
            
        case MHVolActivityApplyTypeAlreadyApply:
            self.applyBtn.hidden = YES;
            self.alreadyLab.hidden = NO;
            [self.applyBtnWidth setConstant:0];
            break;
            
        case MHVolActivityApplyTypeCancelApply:
            self.applyBtn.hidden = NO;
            self.alreadyLab.hidden = YES;
            [self.applyBtn setTitle:@"取消" forState:UIControlStateNormal];
//            [self.applyBtnWidth setConstant:59.0];
            break;
            
        default:
            break;
    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headphoto_s_url] placeholderImage:MAvatar];
}
- (IBAction)applyAction:(id)sender {
    if (self.delegate) {
        if (self.type == MHVolActivityApplyTypeApply) {
            [self.delegate didClickCellWithApply:self.model];
        }else if (self.type == MHVolActivityApplyTypeCancelApply){
            [self.delegate didClickCellWithCancelApply:self.model];
        }
        
    }
}

@end

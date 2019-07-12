//
//  MHVolActivityListTeammateCell.m
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityListTeammateCell.h"
#import "MHAlertView.h"
#import "MHVolActivityListViewModel.h"
#import "MHVolActivityListDataViewModel.h"

#import "MHMacros.h"
#import "UIView+MHFrame.h"

@interface MHVolActivityListTeammateCell ()
@property (weak, nonatomic) IBOutlet UIButton *bottomButton0;  //立即报名
@property (weak, nonatomic) IBOutlet UIButton *bottomButton1;  //取消报名


@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startOfActivityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endOfActivityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *placesOfActivityLabel;

@property (weak, nonatomic) IBOutlet UIView *activityTipsView;
@property (weak, nonatomic) IBOutlet UIView *temporaryActivityBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *temporaryActivityImage;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *temporaryViewHeightConstraint;

@property (strong,nonatomic) MHVolActivityListViewModel *viewModel;
@property (strong,nonatomic) NSNumber *activity_id;
@property (strong,nonatomic) NSNumber *team_id;

@end

@implementation MHVolActivityListTeammateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVolActivityListTeammateCell";
    MHVolActivityListTeammateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVolActivityListTeammateCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.bottomButton0.layer.cornerRadius = 3;
    self.bottomButton0.layer.borderWidth  = 1;
    self.bottomButton0.layer.borderColor  = MColorTitle.CGColor;

    self.bottomButton1.layer.cornerRadius = 3;
    self.bottomButton1.layer.borderWidth  = 1;
    self.bottomButton1.layer.borderColor  = MColorTitle.CGColor;
    
    self.bottomButton0.layer.masksToBounds = YES;
    self.bottomButton1.layer.masksToBounds = YES;
}


- (void)setModel:(MHVolActivityListDataViewModel*)model viewModel:(MHVolActivityListViewModel*)viewModel{
    self.viewModel = viewModel;
    self.activity_id = model.action_id;
    self.team_id = model.activity_team_id;
    
    self.activityTitleLabel.text        = model.t_activityTitle;
    self.activityStateLabel.text        = model.t_activityState;
    self.startOfActivityTimeLabel.text  = model.t_startOfActivityTime;
    self.endOfActivityTimeLabel.text    = model.t_endOfActivityTime;
    self.activityAddressLabel.text      = model.t_activityAddress;
    self.placesOfActivityLabel.text     = model.t_placesOfActivity;
    
    ///color
    [self.activityTipsView   setBackgroundColor:model.t_activityTipsColor];
    [self.activityStateLabel setTextColor:model.t_activityTitleColor];
    
    ///hidden
    self.bottomBaseView.hidden                  = !model.t_hasBottomBaseView;
    self.temporaryViewHeightConstraint.constant =  model.t_temporaryHeight;
    self.temporaryActivityBaseView.hidden       = !model.t_isTemporaryActivity;
    self.temporaryActivityImage.hidden          = !model.t_isTemporaryActivity;
    
    self.bottomButton0.hidden =  model.t_isShowEnrolling;
    self.bottomButton1.hidden = !model.t_isShowEnrolling;
}
- (IBAction)button0Sender:(id)sender {
    [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确定报名参加该活动？" leftHandler:^{
        [[MHAlertView sharedInstance]dismiss];
    } rightHandler:^{
        [[MHAlertView sharedInstance]dismiss];
        [self.viewModel.enrollingCommand execute:RACTuplePack(self.team_id,self.activity_id)];
    } rightButtonColor:nil];

}
- (IBAction)button1Sender:(id)sender {
    [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确认取消报名?" leftHandler:^{
        [[MHAlertView sharedInstance]dismiss];
    } rightHandler:^{
        [[MHAlertView sharedInstance]dismiss];
        [self.viewModel.enrollCancelCommand execute:RACTuplePack(self.team_id,self.activity_id)];
    } rightButtonColor:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

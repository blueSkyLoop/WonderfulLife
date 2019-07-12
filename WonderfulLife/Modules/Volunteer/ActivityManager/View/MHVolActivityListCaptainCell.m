//
//  MHVolActivityListCaptainCell.m
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//Places of activity

#import "MHVolActivityListCaptainCell.h"
#import "MHVolActivityListViewModel.h"
#import "MHVolActivityListDataViewModel.h"
#import "MHMacros.h"
#import "MHAlertView.h"

@interface MHVolActivityListCaptainCell ()
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn1;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn0;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn2;

@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startOfActivityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endOfActivityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *placesOfActivityLabel;

@property (weak, nonatomic) IBOutlet UIView *activityTipsView;
@property (weak, nonatomic) IBOutlet UIImageView *temporaryActivityImage;
@property (weak, nonatomic) IBOutlet UIView *temporaryActivityBaseView;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *temporaryViewHeightConstraint;

@property (strong,nonatomic) MHVolActivityListViewModel *viewModel;
@property (strong,nonatomic) NSNumber *activity_id;
@property (strong,nonatomic) NSNumber *action_team_ref_id;
@property (assign,nonatomic) BOOL c_isShowEnrolling;
@property (assign,nonatomic) BOOL c_isShowCancelEnrolling;
@property (strong,nonatomic) NSNumber *team_id;
@end

@implementation MHVolActivityListCaptainCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVolActivityListCaptainCell";
    MHVolActivityListCaptainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVolActivityListCaptainCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bottomBtn0.layer.cornerRadius = 3;
    self.bottomBtn0.layer.borderWidth  = 1;
    self.bottomBtn0.layer.borderColor  = MColorTitle.CGColor;
    
    self.bottomBtn1.layer.cornerRadius = 3;
    self.bottomBtn1.layer.borderWidth  = 1;
    self.bottomBtn1.layer.borderColor  = MColorTitle.CGColor;
    
    self.bottomBtn2.layer.cornerRadius = 3;
    self.bottomBtn2.layer.borderWidth  = 1;
    self.bottomBtn2.layer.borderColor  = MColorBlue.CGColor;
    
    self.bottomBtn0.layer.masksToBounds = YES;
    self.bottomBtn1.layer.masksToBounds = YES;
    self.bottomBtn2.layer.masksToBounds = YES;
}

- (void)setModel:(MHVolActivityListDataViewModel*)model viewModel:(MHVolActivityListViewModel*)viewModel{
    //因cell重用，需要重置数据;
    self.c_isShowEnrolling = NO;
    self.c_isShowCancelEnrolling = NO;
    [self.bottomBtn0 setTitle:@"管理报名" forState:UIControlStateNormal];

    self.viewModel = viewModel;
    self.activity_id = model.action_id;
    self.action_team_ref_id = model.action_team_ref_id;
    self.team_id = model.activity_team_id;
    
    self.activityTitleLabel.text        = model.c_activityTitle;
    self.activityStateLabel.text        = model.c_activityState;
    self.startOfActivityTimeLabel.text  = model.c_startOfActivityTime;
    self.endOfActivityTimeLabel.text    = model.c_endOfActivityTime;
    self.activityAddressLabel.text      = model.c_activityAddress;
    self.placesOfActivityLabel.text     = model.c_placesOfActivity;
    
    ///color
    [self.activityTipsView   setBackgroundColor:model.c_activityTipsColor];
    [self.activityStateLabel setTextColor:model.c_activityTitleColor];
    
    ///hidden
    self.bottomBaseView.hidden                  = !model.c_hasBottomBaseView;
    self.temporaryViewHeightConstraint.constant =  model.c_temporaryHeight;
    self.temporaryActivityBaseView.hidden       = !model.c_isTemporaryActivity;
    self.temporaryActivityImage.hidden          = !model.c_isTemporaryActivity;
    
    self.bottomBtn0.hidden    =  model.c_isNeedToAttendance;
    self.bottomBtn1.hidden    = !model.c_isShowModifyActivity;
    self.bottomBtn2.hidden    = !model.c_isNeedToAttendance;
    
    //开发型临时活动，分队长需要报名
    if (model.c_isShowEnrolling||model.c_isShowCancelEnrolling) {
        NSString *buttonTitle = @"立即报名";
        if (model.c_isShowCancelEnrolling) {
            buttonTitle = @"取消报名";
        }
        self.c_isShowEnrolling = model.c_isShowEnrolling;
        self.c_isShowCancelEnrolling = model.c_isShowCancelEnrolling;
        [self.bottomBtn0 setTitle:buttonTitle forState:UIControlStateNormal];
    }
    
}
- (IBAction)button0Sender:(id)sender {
    if (self.c_isShowEnrolling) {
        [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确定报名参加该活动？" leftHandler:^{
            [[MHAlertView sharedInstance]dismiss];
        } rightHandler:^{
            [[MHAlertView sharedInstance]dismiss];
            [self.viewModel.enrollingCommand execute:RACTuplePack(self.team_id,self.activity_id)];
        } rightButtonColor:nil];
        return;
    }else if (self.c_isShowCancelEnrolling) {
        [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确认取消报名?" leftHandler:^{
            [[MHAlertView sharedInstance]dismiss];
        } rightHandler:^{
            [[MHAlertView sharedInstance]dismiss];
            [self.viewModel.enrollCancelCommand execute:RACTuplePack(self.team_id,self.activity_id)];
        } rightButtonColor:nil];
        return;
    }
    [self.viewModel.enrollListManagerSubject sendNext:RACTuplePack(self.team_id,self.action_team_ref_id,self.activity_id)];
}

- (IBAction)buttun1Sender:(id)sender {
    [self.viewModel.modifyActivitySubject sendNext:RACTuplePack(self.team_id,self.activity_id)];
}
- (IBAction)buttun2Sender:(id)sender {
    [self.viewModel.attendanceRegistrationSubject sendNext:self.action_team_ref_id];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

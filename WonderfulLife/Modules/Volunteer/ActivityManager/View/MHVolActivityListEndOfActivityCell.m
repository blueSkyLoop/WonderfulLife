//
//  MHVolActivityListResultCell.m
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityListEndOfActivityCell.h"
#import "MHVolActivityListViewModel.h"
#import "MHVolActivityListDataViewModel.h"
#import "MHMacros.h"

@interface MHVolActivityListEndOfActivityCell ()
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

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
@property (strong,nonatomic) NSNumber *action_team_ref_id;
@property (strong,nonatomic) NSNumber *team_id;

@end

@implementation MHVolActivityListEndOfActivityCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHVolActivityListEndOfActivityCell";
    MHVolActivityListEndOfActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHVolActivityListEndOfActivityCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomBtn.layer.cornerRadius = 3;
    self.bottomBtn.layer.borderWidth  = 1;
    self.bottomBtn.layer.borderColor  = MColorTitle.CGColor;

    self.bottomBtn.layer.masksToBounds = YES;
}

- (void)setModel:(MHVolActivityListDataViewModel*)model viewModel:(MHVolActivityListViewModel*)viewModel {
    
    self.viewModel = viewModel;
    self.activity_id = model.action_id;
    self.action_team_ref_id = model.action_team_ref_id;
    self.team_id = model.activity_team_id;

    self.activityTitleLabel.text        = model.e_activityTitle;
    self.activityStateLabel.text        = model.e_activityState;
    self.startOfActivityTimeLabel.text  = model.e_startOfActivityTime;
    self.endOfActivityTimeLabel.text    = model.e_endOfActivityTime;
    self.activityAddressLabel.text      = model.e_activityAddress;
    self.placesOfActivityLabel.text     = model.e_placesOfActivity;
    
    ///color
    [self.activityTipsView   setBackgroundColor:model.e_activityTipsColor];
    [self.activityStateLabel setTextColor:model.e_activityTitleColor];
    
    ///hidden
    self.bottomBaseView.hidden                  = !model.e_hasBottomBaseView;
    self.temporaryViewHeightConstraint.constant =  model.e_temporaryHeight;
    self.temporaryActivityBaseView.hidden       = !model.e_isTemporaryActivity;
    self.temporaryActivityImage.hidden          = !model.e_isTemporaryActivity;

}
- (IBAction)button0Sender:(id)sender {
    [self.viewModel.reviewDetailSubject sendNext:RACTuplePack(self.team_id,self.action_team_ref_id,self.activity_id)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

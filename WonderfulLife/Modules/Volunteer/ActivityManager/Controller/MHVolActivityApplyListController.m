//
//  MHVolActivityApplyListController.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityApplyListController.h"
#import "MHVolActivityModifyController.h"
#import "MHVolActivityInfoCardController.h"

#import "MHVolActivityApplyHeaderView.h"
#import "MHVolActivityApplyListSectionView.h"
#import "MHVolActivityApplyListCell.h"
#import "MHAlertView.h"
#import "Masonry.h"

#import "UIViewController+HLNavigation.h"
#import "UIViewController+MHConfigControls.h"

#import "MHVolActivityApplyListModel.h"
#import "MHVolActivityRequestHandler.h"
#import "MHHUDManager.h"
#import "MHVolunteerUserInfo.h"
#import "MHWeakStrongDefine.h"
#import "UIViewController+MHConfigControls.h"
#import "SVProgressHUD.h"

@interface MHVolActivityApplyListController ()<UITableViewDelegate,UITableViewDataSource,MHVolActivityApplyListCellDelegate>

@property (nonatomic, strong) MHVolActivityApplyListModel  *model;

@end

@implementation MHVolActivityApplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self mh_createTalbeViewStyleGrouped];
    [self mh_initTitleAlignmentLeftLabelWithTitle:@"报名列表"];
    self.lineAlpha = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.bounces = NO;
    self.isCaptain = [[MHVolunteerUserInfo sharedInstance].volunteer_role isEqualToNumber:@1];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    if (self.isCaptain == YES) {
        UIButton *repair = [[UIButton alloc] init];
        [repair setTitle:@"修改活动" forState:UIControlStateNormal];
        [repair setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        repair.titleLabel.font = [UIFont systemFontOfSize:17];
        [repair sizeToFit];
        [repair addTarget:self action:@selector(repairAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:repair];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SVProgressHUD dismissWithCompletion:^{
        [self request];
    }];
}

#pragma mark -  Request
- (void)request {
    [MHHUDManager show];
    [MHVolActivityRequestHandler acticityApplyList:self.action_team_ref_id ActivityApplyListBlock:^(MHVolActivityApplyListModel *model, BOOL isSuccess) {
        self.model = model ;
        [self relaodTableViewHeaderView];
        [self.tableView reloadData];
        [SVProgressHUD dismissWithDelay:0.25];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showText:errmsg];
    }];
}

#pragma mark - SetUI
- (void)relaodTableViewHeaderView{
    self.tableView.tableHeaderView  = [MHVolActivityApplyHeaderView volActivityApplyHeaderViewWithModel:self.model];
}


#pragma mark - Event
// 修改活动
- (void)repairAction {
    MHVolActivityModifyController *controller = [[MHVolActivityModifyController alloc] init];
    controller.action_id = self.action_id;
    controller.activity_team_id = self.team_id;
    controller.type = MHActivityModifyTypeNormal;
    [self.navigationController pushViewController:controller animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.model.applied.count ;
    }else{
        return self.model.not_apply.count ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVolActivityApplyListCell *cell = [MHVolActivityApplyListCell cellWithTableView:tableView];
    
    MHVolActivityApplyCrew *crew ;
    
    if (indexPath.section == 0) {
        crew = self.model.applied[indexPath.row];
        if ([crew.volunteer_id isEqualToNumber:[MHVolunteerUserInfo sharedInstance].volunteer_id]) {
        cell.type = MHVolActivityApplyTypeCancelApply ;
        }else {
            /** isCancelApply 是否可以取消报名，0不可取消，1可以取消 */
            cell.type = crew.isCancelApply ? MHVolActivityApplyTypeCancelApply: MHVolActivityApplyTypeAlreadyApply;
        }
        
    }else {
        crew = self.model.not_apply[indexPath.row];
        cell.type = MHVolActivityApplyTypeApply ;
    }
    
    cell.model = crew ;
    cell.delegate = self;
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 57 ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MHVolActivityApplyListSectionView * view = [MHVolActivityApplyListSectionView volActivityApplySectionView];
    if (section == 0) {
        view.titleLB.text = @"已报名成员";
        view.countLB.text = [NSString stringWithFormat:@"%ld人",self.model.applied.count];
    }else{
        view.titleLB.text = @"未报名成员";
        view.countLB.text = [NSString stringWithFormat:@"%ld人",self.model.not_apply.count];
    }
    return view;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self mh_scrollUpdateTitleLabel];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self mh_scrollUpdateTitleLabel];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self mh_scrollUpdateTitleLabel];
}



#pragma mark - CellDelegate
// 报名
- (void)didClickCellWithApply:(MHVolActivityApplyCrew *)model {
    [self applyRequestWithCrew:model];
}

- (void)applyRequestWithCrew:(MHVolActivityApplyCrew *)model {
    [MHHUDManager show];
    MHWeakify(self)
    [MHVolActivityRequestHandler activityDetailsApplyCreateWithAction_id:self.model.action_id volunteer_id:model.volunteer_id team_id:self.team_id ActivityDetailsBlock:^(BOOL isSuccess) {
        MHStrongify(self)
        [MHHUDManager dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadVolSerActivityListResultNotification" object:nil];
        [self request];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

// 取消报名
- (void)didClickCellWithCancelApply:(MHVolActivityApplyCrew *)model {
    [MHHUDManager show];
    MHWeakify(self)
    [MHVolActivityRequestHandler activityDetailsApplyDeleteWithAction_id: self.model.action_id volunteer_id:model.volunteer_id team_id:self.team_id ActivityDetailsBlock:^(BOOL isSuccess) {
        MHStrongify(self)
        [MHHUDManager dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadVolSerActivityListResultNotification" object:nil];
        [self request];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}


- (void)didClickIcon:(MHVolActivityApplyCrew *)model {
    MHVolActivityInfoCardController *vc = [[MHVolActivityInfoCardController alloc] init];
    vc.type = MHVolActivityInfoCardTypeActivity ;
    vc.volunteerId = model.volunteer_id ;
    vc.teamId = self.model.team_id;
    vc.userId = model.user_id;
    vc.activtyId = self.model.activity_id ;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

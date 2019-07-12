//
//  MHVolActivityDetailsController.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityDetailsController.h"
#import "MHVolActivityInfoCardController.h"
#import "MHVolActivityApplyListController.h"
#import "MHVolActivityModifyController.h"
#import "MHVoRegisterAttendanceController.h"


#import "MHAlertView.h"
#import "MHActivityStatusView.h"
#import "MHActivityActionView.h"
#import "MHVolActivityDetailsHeaderView.h"
#import "MHVolActivityDetailsInfoCell.h"
#import "MHVolActivityDeatilsTimeCell.h"
#import "MHVolActivityDetailsAddressCell.h"
#import "MHVolActivityDetailsReadMordCell.h"
#import "MHVolActivityDetailsMembersCell.h"
#import "MHVolActivityDetailsCancelCell.h"

#import "Masonry.h"
#import "MHMacros.h"
#import "UIViewController+HLNavigation.h"
#import "MHWeakStrongDefine.h"
#import "UILabel+HLLineSpacing.h"
#import "YYLabel+LinesString.h"
#import "MHVolActivityRequestHandler.h"
#import "MHVolActivityDetailsModel.h"
#import "MHHUDManager.h"
#import "MHUserInfoManager.h"
#import "MHVolSerTeamMember.h"
#import "MHVolunteerUserInfo.h"

#import "UIViewController+MHConfigControls.h"

@interface MHVolActivityDetailsController ()<UITableViewDelegate,UITableViewDataSource,MHVolActivityDetailsInfoCellDelegate,MHVolActivityDetailsReadMordCellDelegate,MHVolActivityDetailsCancelCellDelegate,MHVolActivityDetailsMembersCellDelegate>


/** bottomView */
@property (strong,nonatomic) UIView *bottomView;

@property (nonatomic, strong) MHVolActivityDetailsModel  *model;

@property (nonatomic, assign) BOOL isOpenIntro;

@property (nonatomic, assign) BOOL isOpenRules;

@property (nonatomic, strong) NSNumber  *myVolunteer_id;

@end

@implementation MHVolActivityDetailsController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self mh_createTalbeView];
    [self mh_initTitleAlignmentLeftLabelWithTitle:@""];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.separatorColor = MRGBColor(210, 220, 230);
    self.tableView.estimatedRowHeight = 300;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.myVolunteer_id = [MHVolunteerUserInfo sharedInstance].volunteer_id ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self request]; //每次进来更新数据
    
}

#pragma mark - SetUI
- (void)setUI{
    //  1. 队长判断是否能够修改  2.进行中、活动已取消、活动已结束 3.常规活动 action_type
    BOOL isShowBar = (self.model.is_cancel == 0) && (self.model.action_state == 0 || self.model.action_state == 1) && (self.model.action_type == 0);
    if (self.model.is_captain == 1 && isShowBar) {
        UIButton *repair = [[UIButton alloc] init];
        [repair setTitle:@"修改活动" forState:UIControlStateNormal];
        [repair setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        repair.titleLabel.font = [UIFont systemFontOfSize:17];
        [repair sizeToFit];
        [repair addTarget:self action:@selector(repairAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:repair];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    //    is_cancel	Integer	0|1	活动是否已经取消，0表示未取消，1表示已取消
    if (self.model.is_cancel == 1) {
        [self isCancelSetBottomView];
    }else{
        [self actionStateSetBottomView];
    }
    [self addTableViewWithView];
}


- (void)actionStateSetBottomView {
    //    action_state	Integer	0|1|2|3	活动状态，0报名中，1名额已满，2进行中，3已结束
    //   is_apply  是否已报名，0否，1是
    //  is_captain   是否为队长，0否，1是
    // action_type	活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
//    if (self.model.action_state == 3) { // 队长 &&  队员  显示样式一样
//        [self addStatusBottomView:MHActivityStatusViewTypeEnd];
//        return;
//    }
    
    if (self.model.is_captain) { // 分队长
        if (self.model.action_type == 0) { // 常规活动
            if (self.model.action_state == 0 || self.model.action_state == 1) { // 管理报名
                [self addActionBottomView:MHActivityActionViewTypeManagementSignUp];
            }else if (self.model.action_state == 2) { // 进行中
                [self addStatusBottomView:MHActivityStatusViewTypeGoing];
            }else if (self.model.action_state == 3) {
                if (self.model.is_attendance == 0) { // 是否需要登记考勤
                    [self addActionBottomView:MHActivityActionViewTypeRegAttendance];
                }else { // 已登记过，结束活动
                    [self addStatusBottomView:MHActivityStatusViewTypeEnd];
                }
            }
        }else { // 临时活动
            
            if (self.model.action_state == 2){ // 共同状态：进行中
                [self addStatusBottomView:MHActivityStatusViewTypeGoing];
                return ;
            } else if (self.model.action_state == 3) {
                [self addStatusBottomView:MHActivityStatusViewTypeEnd];
                return;
            }
            if (self.model.action_type == 1){ // 指派型临时活动
                  if (self.model.action_state == 0 || self.model.action_state == 1) {  // 报名中 、 满人
                      [self addActionBottomView:MHActivityActionViewTypeManagementSignUp];
                  }
            }else if (self.model.action_type == 2) { // 开放型临时活动
                if (self.model.action_state == 0) {  // 报名中
                    [self applyStatusBottemView];
                }else if (self.model.action_state == 1){
                   [self fillStausBottemView];
                }
            }
        }
    }else {  // 队员
        if (self.model.action_state == 0) {
            [self applyStatusBottemView];
        } else if (self.model.action_state == 1) { // 满人
            [self fillStausBottemView];
        } else if (self.model.action_state == 2) {
            [self addStatusBottomView:MHActivityStatusViewTypeGoing];
        } else if (self.model.action_state == 3) {
            [self addStatusBottomView:MHActivityStatusViewTypeEnd];
        }
    }
}

// 可报名 & 取消报名
- (void)applyStatusBottemView {
    if (self.model.is_apply) { // 已报名
        [self addActionBottomView:MHActivityActionViewTypeMembersSignUpCancel];
    }else{   // 没报名
        [self addActionBottomView:MHActivityActionViewTypeMembersSignUpNormal];
    }
}

// 满人 & 取消报名
- (void)fillStausBottemView {
    if (self.model.is_apply) { // 已报名 可以取消
        [self addActionBottomView:MHActivityActionViewTypeMembersSignUpCancel];
    }else{   // 没报名，显示满人
        [self addActionBottomView:MHActivityActionViewTypeMembersSignUpFill];
    }
}


// 活动已取消
- (void)isCancelSetBottomView {
    [self addStatusBottomView:MHActivityStatusViewTypeCancel];
    [self addTableViewWithView];
}

// 不可点击样式
- (void)addStatusBottomView:(MHActivityStatusViewType)type{
    if (self.bottomView) [self.bottomView removeFromSuperview];
    self.bottomView = [MHActivityStatusView activityViewWithStatus:type actionBlock:nil];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.equalTo(@95);
    }];
}


// 可点击样式
- (void)addActionBottomView:(MHActivityActionViewType)type{
    if(self.bottomView) [self.bottomView removeFromSuperview];

    self.bottomView = [MHActivityActionView activityActionViewWithStatus:type qty:self.model.qty sty: self.model.sty handler:^{
        switch (type) {
            case MHActivityActionViewTypeManagementSignUp:  // 管理报名
            {
                MHVolActivityApplyListController *vc = [[MHVolActivityApplyListController alloc] init];
                vc.isCaptain = self.model.is_captain ;
                vc.action_id = self.action_id;
                vc.action_team_ref_id =  self.model.action_team_ref_id ;
                vc.team_id = self.team_id ;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case MHActivityActionViewTypeRegAttendance:  // 登记考勤
            {
//                [MHHUDManager showText:@"登记考勤暂未接入"];
                MHVoRegisterAttendanceController *controller = [MHVoRegisterAttendanceController new];
                controller.action_team_ref_id = self.model.action_team_ref_id ;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case MHActivityActionViewTypeMembersSignUpCancel: // 队员取消报名
            {
                [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确定取消报名？" leftHandler:^{
                } rightHandler:^{
                    [MHHUDManager show];
                    MHWeakify(self)
                    [MHVolActivityRequestHandler activityDetailsApplyDeleteWithAction_id: self.model.action_id volunteer_id:self.myVolunteer_id team_id:self.team_id ActivityDetailsBlock:^(BOOL isSuccess) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadVolSerActivityListResultNotification" object:nil];
                        [self request];
                    } failure:^(NSString *errmsg) {
                        [MHHUDManager showText:errmsg];
                    }];
                } rightButtonColor:nil];
            }
                break;
            case MHActivityActionViewTypeMembersSignUpNormal:  // 队员报名
            {
                [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确定参加该活动？" leftHandler:^{
                } rightHandler:^{
                    [MHHUDManager show];
                    MHWeakify(self)
                    [MHVolActivityRequestHandler activityDetailsApplyCreateWithAction_id:self.model.action_id volunteer_id:self.myVolunteer_id team_id:self.team_id  ActivityDetailsBlock:^(BOOL isSuccess) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadVolSerActivityListResultNotification" object:nil];
                        [self request];
                    } failure:^(NSString *errmsg) {
                        [MHHUDManager showText:errmsg];
                    }];
                } rightButtonColor:nil];
            }
                break;
                
            default:
                break;
        }
        
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.equalTo(@95);
    }];
}



- (void)addTableViewWithView{
    self.titleLab.text = self.model.title;
    [self mh_scrollUpdateTitleLabel];
    
    self.tableView.tableHeaderView = [MHVolActivityDetailsHeaderView activityDetailsHeaderView:self.model];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-95);
    }];
    [self.tableView reloadData];
}



#pragma mark -  Request
- (void)request {
    [MHHUDManager show];
    [MHVolActivityRequestHandler activityDetailsRequest:self.action_id volunteer_id:self.myVolunteer_id action_team_ref_id:self.action_team_ref_id ActivityDetailsBlock:^(MHVolActivityDetailsModel *model, BOOL isSuccess) {
        if (isSuccess) {
            self.model = model;
            [self setUI];
        }
        [MHHUDManager dismiss];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showText:errmsg];
    }];
}


#pragma mark - TableViewDelagete & DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.model.is_cancel && self.model.is_captain && self.model.action_type == 0 && self.model.is_attendance == 0) { // 分队长身份，活动未取消 ,常规活动，考勤还没登记都可以取消登记
        return 7 ;
    }else return 6 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MHVolActivityDetailsInfoCell *cell = [MHVolActivityDetailsInfoCell cellWithTableView:tableView];
        cell.delegate = self ;
        cell.model = self.model ;
        return cell ;
    }else if (indexPath.section == 1) {
        MHVolActivityDeatilsTimeCell *cell = [MHVolActivityDeatilsTimeCell cellWithTableView:tableView];
        cell.model = self.model;
        return cell ;
    }else if (indexPath.section == 2) {
        MHVolActivityDetailsAddressCell *cell = [MHVolActivityDetailsAddressCell cellWithTableView:tableView];
        cell.model = self.model;
        return cell ;
    }else if (indexPath.section == 3 || indexPath.section == 4){
        MHVolActivityDetailsReadMordCell *cell = [MHVolActivityDetailsReadMordCell cellWithTableView:tableView];
        cell.indexPath = indexPath ;
        cell.delegate = self;
        if (indexPath.section == 3) {
            cell.readMoreType = MHVolActivityDetailsReadMordTypeIntro;
        }else{
            cell.readMoreType = MHVolActivityDetailsReadMordTypeRules;
        }
        cell.model = self.model;
        [cell layoutIfNeeded];
        return cell ;
    }else if (indexPath.section == 5) {
        MHVolActivityDetailsMembersCell *cell = [MHVolActivityDetailsMembersCell cellWithTableView:tableView];
        cell.memberList = self.model.team_member_list ;
        cell.delegate = self;
        return cell ;
    }else if (indexPath.section == 6) {
        MHVolActivityDetailsCancelCell * cell = [MHVolActivityDetailsCancelCell cellWithTableView:tableView];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001 ;
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



#pragma mark - Event
// 修改活动
- (void)repairAction{
    MHVolActivityModifyController *controller = [[MHVolActivityModifyController alloc] init];
    controller.action_id = self.action_id;
    controller.activity_team_id = self.team_id;
    controller.type = MHActivityModifyTypeNormal;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Delegate
// 头像点击
- (void)InfoCellDidClickIcon:(id)model {
    [self openInfoCardWithVolunteer_id:self.model.captain.volunteer_id user_id:[MHUserInfoManager sharedManager].user_id activtyId:self.model.activity_id  team_id:self.model.team_id];
    
}

- (void)volSerMemberdidSelectItemWithModel:(MHVolSerTeamMember *)model{
    [self openInfoCardWithVolunteer_id:model.volunteer_id user_id:model.user_id activtyId:self.model.activity_id  team_id:self.model.team_id];
}


- (void)openInfoCardWithVolunteer_id:(NSNumber *)volunteer_id
                             user_id:(NSNumber *)user_id
                           activtyId:(NSNumber *)activity_id
                            team_id :(NSNumber *)team_id{
    MHVolActivityInfoCardController *vc = [[MHVolActivityInfoCardController alloc] init];
    vc.type = MHVolActivityInfoCardTypeActivity ;
    vc.volunteerId = volunteer_id ;
    vc.teamId = team_id;
    vc.userId = user_id;
    vc.activtyId = activity_id ;
    [self.navigationController pushViewController:vc animated:YES];
}

// 阅读更多
- (void)didClickReadMoreWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3)self.model.isOpenIntro = YES ;
    if (indexPath.section == 4)self.model.isOpenRules = YES ;
    [self.tableView reloadData];
}

// 取消活动
- (void)didClickCellCancelButton{
    [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确定取消活动？" leftHandler:^{
    } rightHandler:^{
        [MHHUDManager show];
        MHWeakify(self)
        [MHHUDManager show];
        [MHVolActivityRequestHandler activityCancelWithAction_id:self.model.action_id volunteer_id:self.model.captain.volunteer_id ActivityBlock:^(BOOL isSuccess) {
            MHStrongify(self)
            if (isSuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadVolSerActivityListResultToTopNotification" object:nil];
                [MHHUDManager dismiss];
                [MHHUDManager showText:@"取消成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MHHUDManager showText:@"取消失败，请稍后再试！"];
            }
        } failure:^(NSString *errmsg) {
            [MHHUDManager showText:errmsg];
        }];
    } rightButtonColor:nil];
}


@end

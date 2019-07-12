//
//  MHVolSerDetailController.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerDetailController.h"
#import "MHVolActivityInfoCardController.h"

#import "MHVolSerDescripeCell.h"
#import "MHVolSerCaptainCell.h"
#import "MHVolSerMemberCell.h"
#import "MHVolSerDetailSectionView.h"
#import "MHVolSerDetailTableFooterView.h"
#import "MHAwaitingModerationView.h"
#import "MHVolSerDetailRefusedHeaderView.h"
#import "MHVolSerRefuseAlertView.h"
#import "MHAlertSheetView.h"

#import "MHVolSerTeamRequest.h"
#import "MHSerTeamDetailModel.h"
#import "MHVolSerCaptainModel.h"
#import "MHVolSerTeamMember.h"
#import "MHUserInfoManager.h"

#import "MHWeakStrongDefine.h"
#import "MHHUDManager.h"
#import "MHAlertView.h"
#import <UIViewController+HLNavigation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+HLJudge.h"
#import "MHMacros.h"
#import "MHConst.h"
#import "UILabel+HLLineSpacing.h"
@interface MHVolSerDetailController ()<MHVolSerCaptainCallDelegate,MHVolSerMemberDelegate>
/// <#summary#>
@property (strong,nonatomic) MHSerTeamDetailModel *detail;
@end

@implementation MHVolSerDetailController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
        [self hl_setNavigationItemColor:[UIColor whiteColor]];
    //    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:kReloadVoSerDetailNotification object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVolSerDescripeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVolSerDescripeCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVolSerCaptainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVolSerCaptainCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MHVolSerMemberCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MHVolSerMemberCell class])];
    self.tableView.estimatedRowHeight = 150;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self request];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 刷新服务队列表*/
- (void)reloadSerTeamList{
  if (self.type != MHVolSerDetailTypeJoinItem)  [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVoSerTeamNotification object:nil];
}

#pragma mark -  Request
- (void)request{
    [MHHUDManager show];
    self.tableView.hidden = YES;
    if (self.type == MHVolSerDetailTypeTeam) {
        MHWeakify(self)
        [MHVolSerTeamRequest loadVolSerTeamWithId:self.detailId callBack:^(BOOL success, id info) {
            if (success) {
                weak_self.detail = info;
                [weak_self setHeaderFooterView];
                [weak_self.tableView reloadData];
            } else {
                [MHHUDManager showErrorText:info];
            }
            self.tableView.hidden = NO;
            [MHHUDManager dismiss];
        }];
    } else if (self.type == MHVolSerDetailTypeItem || self.type == MHVolSerDetailTypeJoinItem) {
        MHWeakify(self)
        [MHVolSerTeamRequest loadVolSerItemWithId:self.detailId callBack:^(BOOL success, id info) {
            if (success) {
                
                weak_self.detail = info;
                if (self.type == MHVolSerDetailTypeItem) { // 如果 “服务项目列表”
                    [self setHeaderFooterView];
                }
                [weak_self.tableView reloadData];
            } else {
                [MHHUDManager showErrorText:info];
            }
            self.tableView.hidden = NO;
            [MHHUDManager dismiss];
        }];
    } else {}
}

- (void)setHeaderFooterView{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    /**  状态，
     -1表示未申请该服务项目或已撤销申请，
     0表示待审核，
     1表示审核通过，
     2表示审核未通过，
     3表示已退出，
     4表示被移除
     */
    // 显示加入按钮
    if (self.detail.approve_status == -1 || self.detail.approve_status == 2 || self.detail.approve_status == 4) {
        // 撤销 & 未加入 都显示加入按钮
        self.tableView.tableFooterView = [MHVolSerDetailTableFooterView awakeFromNibWithButtonEvent:^{
            [self applyToJoin];
        }];
        if (self.detail.approve_status == 2) { // 显示拒绝理由 headerView
            self.tableView.tableHeaderView = [MHVolSerDetailRefusedHeaderView refusedHeaderViewWithReason:self.detail.reason title:@"审核不通过"];
        }else if (self.detail.approve_status == 4){
            self.tableView.tableHeaderView = [MHVolSerDetailRefusedHeaderView refusedHeaderViewWithReason:self.detail.reason title:@"已被移出服务队"];
        }
        
        
    }
    // 审核中  可撤回状态
    else if (self.detail.approve_status == 0){
        self.tableView.tableHeaderView = [MHAwaitingModerationView awakeFromNib:self.detail.approve_status];
        self.tableView.tableFooterView = [MHVolSerDetailTableFooterView awakeFromNibExitWithBtnTitle:@"撤回申请" buttonEvent:^{
            [self withdrawSer];
        }];
    }
    // 已通过 可退出  如果是队员的话
    else if (self.detail.approve_status == 1 && self.detail.volunteer_role == 0){
        MHWeakify(self)
        self.tableView.tableFooterView = [MHVolSerDetailTableFooterView awakeFromNibExitWithBtnTitle:@"退出服务队" buttonEvent:^{
             MHStrongify(self)
            [self quitSer];
        }];
    }
    // 已退出
    else if (self.detail.approve_status == 3){
        self.tableView.tableHeaderView = [MHAwaitingModerationView awakeFromNib:self.detail.approve_status];
        self.tableView.tableFooterView = [MHVolSerDetailTableFooterView awakeFromNibWithButtonEvent:^{
            [self applyToJoin];
        }];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hl_setNavigationItemColor:[UIColor clearColor]];
}

// 申请加入
- (void)applyToJoin {
    MHWeakify(self)
    
    if(self.detail.approve_status == 2){
    MHMessageAlertView * view = [[MHAlertView sharedInstance] showMessageAlertViewTitle:nil message:@"您的入队申请已被拒绝，无法重复申请！" sureHandler:nil];
        [view.doneBtn setTitle:@"知道了" forState:UIControlStateNormal];
        view.messageLabel.textColor = MColorTitle ;
        return;
    }
    
    
    if(self.detail.approve_status == 3 || self.detail.approve_status == 4){
        [[MHAlertView sharedInstance] showMessageAlertViewTitle:@"不可申请" message:@"一个服务项目只可申请一次" sureHandler:nil];
        return;
    }
    
    if (self.detail.activity_count == 2) {
        [[MHAlertView sharedInstance]showMessageAlertViewTitle:@"申请加入" message:@"每人最多加入或申请2个服务项目" sureHandler:nil];
        return;
    }
    
    [[MHAlertView sharedInstance]showNormalAlertViewTitle:@"确认申请加入" message:@"发起申请后，如符合加入条件，队长将会与您取得联系，请留意来电或短信通知" leftHandler:nil rightHandler:^{
        MHStrongify(self)
        [MHHUDManager show];
        [MHVolSerTeamRequest applyJoinActiveId:self.detail.activity_id.stringValue callBack:^(BOOL success, id info) {
            if (success) {
                [MHHUDManager showText:@"申请已发送"];
                
                // 定位到最近选择的服务区内
                [MHUserInfoManager sharedManager].serve_community_name = self.detail.community_name ;
                [MHUserInfoManager sharedManager].serve_community_id = self.detail.community_id ;
                [[MHUserInfoManager sharedManager] saveUserInfoData];
                
                
                [self request];
                [self reloadSerTeamList];
            } else {
                [[MHAlertView sharedInstance]showMessageAlertViewTitle:@"申请加入" message:@"每人最多加入或申请2个服务项目" sureHandler:nil];
            }
            [MHHUDManager dismiss];
        }];
    } rightButtonColor:nil];
}

/** 退出服务队 request*/
- (void)quitSer{
    // 文本框
   [MHVolSerRefuseAlertView volSerRefuseAlertViewWithTitle:@"退出原因" tipStr:@"填写退出原因150字以内"  clickSureButtonBlock:^(NSString *reason){
        NSString *message = [NSString stringWithFormat:@"退出服务队后无法再次申请进入该服务项目"];
        [[MHAlertView sharedInstance] showNormalAlertViewTitle:@"确定退出服务队" message:message leftHandler:^{
            
        } rightHandler:^{
            // request
            [MHHUDManager show];
            [MHVolSerTeamRequest loadVolSerTeamQuitWithId:self.detailId reason:reason callBack:^(BOOL success, id info) {
                if (success) {
                    [self request];
                    [self reloadSerTeamList];
                    [MHHUDManager showText:@"成功退出服务队"];
                }else{
                    [MHHUDManager showErrorText:info];
                }
                 [MHHUDManager dismiss];
            }];
        } rightButtonColor:nil];
    }];
}


/** 撤回申请 request*/
- (void)withdrawSer{
    [[MHAlertView sharedInstance] showNormalTitleAlertViewWithTitle:@"确定撤回加入服务项目申请"  leftHandler:^{
        
    } rightHandler:^{
        // request
        [MHHUDManager show];
//        Volunteer/Activity/IsWithdraw
        [MHVolSerTeamRequest loadVolSerWithdrawWithId:self.detailId callBack:^(BOOL success, id info) {
            if (success) {
                [self request];
                [self reloadSerTeamList];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MHHUDManager showText:@"已撤回加入申请"];
                });
            }else{
                [MHHUDManager showErrorText:info];

            }
            
        }];
    } rightButtonColor:nil];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MHVolSerDescripeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVolSerDescripeCell class])];
        [cell.mh_whereLabel setText:self.detail.community_name];
        
        /*
         MHVolSerDetailTypeTeam : 使用  team_name
         MHVolSerDetailTypeItem : 使用  activity_name
         */
        NSString *title = self.type == MHVolSerDetailTypeTeam ? self.detail.team_name: self.detail.activity_name;
        [cell.mh_titleLabel setText:title];
        [cell.mh_descripeLabel setText:self.detail.activity_intro];
        [cell.mh_descripeLabel hl_setLineSpacing:10 text:cell.mh_descripeLabel.text];
        return cell;
    } else if (indexPath.section == 1) {
        MHVolSerCaptainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVolSerCaptainCell class])];
        MHVolSerCaptainModel *model = self.detail.captain_list[indexPath.row];
        [cell.mh_imageView sd_setImageWithURL:model.captain_icon placeholderImage:MAvatar];
        [cell.mh_titleLabel setText:model.captain_name];
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell.mh_subTitleLabel setText:model.role_name];
        cell.phoneBtn.hidden = self.detail.approve_status == 1 ? NO : YES ;
        
        return cell;
    } else {
        MHVolSerMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MHVolSerMemberCell class])];
        cell.memberLiat = self.detail.team_member_list;
        cell.delegate = self;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        if ([self.detail.activity_type isEqualToNumber:@0]) { // 公益服务项目隐藏负责人栏目
            return nil;
        }else{
            return ({
                MHVolSerDetailSectionView *sectionView = [MHVolSerDetailSectionView awakeFromNib];
                [sectionView.mh_leftLabel setText:@"负责人"];
                sectionView.mh_rightLabel.hidden = YES;
                sectionView;
            });
        }
    } else {
        return ({
            MHVolSerDetailSectionView *sectionView = [MHVolSerDetailSectionView awakeFromNib];
            [sectionView.mh_leftLabel setText:@"成员"];
            [sectionView.mh_rightLabel setText:[NSString stringWithFormat:@"共%ld人",(unsigned long)self.detail.team_member_list.count]];
            sectionView;
        });
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.detail.captain_list.count;
    } else {
        return 1;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
////    if (indexPath.section == 0) {
////        return 200;
////    } else
//        if (indexPath.section == 1) {
//        return 88;
//    } else {
//        return 148;
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
        if ([self.detail.activity_type isEqualToNumber:@0]) { // 公益服务项目隐藏负责人栏目
            return 0.01;
        }else{
         return 60;
        }
    } else {
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}



#pragma mark - MHVolSerCaptainCallDelegate

- (void)CaptainCellDidClickCallButtonAtIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)phoneBtn {
    MHVolSerCaptainModel *captaion = self.detail.captain_list[indexPath.row];
    NSString *phone = captaion.phone;
    NSString *captaionLevel ;
    if (captaion.role==9) {// 总队长
        captaionLevel = @"总队长";
    }else{ // 队长
        captaionLevel = @"队长";
    }
    
    NSString *title =  [NSString stringWithFormat:@"拨打%@电话",captaion.role_name];
    
    if ([phone hl_isEmpty]) {
        [MHHUDManager showText:@"找不到电话号码"];
    } else {
        [[MHAlertView sharedInstance] showTitleActionSheetTitle:title sureHandler:^{
            NSString *phoneStr = [[NSMutableString alloc] initWithFormat:@"tel://%@",phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        } cancelHandler:^{
            [[MHAlertView sharedInstance] dismiss];
        } sureButtonColor:MColorBlue sureButtonTitle:phone];
    }
}

- (void)CaptainCellDidClickHeadViewAtIndexPath:(NSIndexPath *)indexPath {
    MHVolActivityInfoCardController *vc = [[MHVolActivityInfoCardController alloc]init];
    vc.type = MHVolActivityInfoCardTypeSer;
    vc.volunteerId = self.detail.captain_list[indexPath.row].volunteer_id;
    vc.userId = self.detail.captain_list[indexPath.row].user_id;
    
    if (self.detail.captain_list[indexPath.row].role == 0) {  // 傻逼后台返回了0 本来队长应该是1的，此处写死
        vc.role = 1 ;
    }else{
        vc.role = self.detail.captain_list[indexPath.row].role;
    }
    
    vc.activtyId = self.detail.activity_id;
    
    MHVolSerCaptainModel *model = self.detail.captain_list[indexPath.row];
    if (model.team_list.count > 1) {
        NSMutableArray *alertButtons = [NSMutableArray array];
        [model.team_list enumerateObjectsUsingBlock:^(MHVolSerTeamIDTeamName * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MHAlertConfig *button = [[MHAlertConfig alloc]initWithTitle:obj.team_name image:nil];
            [alertButtons addObject:button];
        }];
        MHAlertSheetView *sheet = [[MHAlertSheetView alloc] initWithTitle:@"选择要查看的服务队" buttons:alertButtons comple:^(NSInteger index) {
            vc.teamId = model.team_list[index].team_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [sheet show];
    }else{
        if (self.type == MHVolSerDetailTypeTeam){
            vc.teamId = self.detail.team_id;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MHVolSerMemberDelegate

- (void)volSerMemberdidSelectItemWithModel:(MHVolSerTeamMember *)model{
    MHVolActivityInfoCardController *vc = [[MHVolActivityInfoCardController alloc]init];
    vc.type = MHVolActivityInfoCardTypeSer;
    vc.volunteerId = model.volunteer_id;
    vc.userId = model.user_id;
    vc.activtyId = self.detail.activity_id;
    vc.role =  0;  // 队员的cell 点击， 所以角色一定是队员
    if (model.team_list.count > 1) {
        NSMutableArray *alertButtons = [NSMutableArray array];
        [model.team_list enumerateObjectsUsingBlock:^(MHVolSerTeamIDTeamName * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MHAlertConfig *button = [[MHAlertConfig alloc]initWithTitle:obj.team_name image:nil];
            [alertButtons addObject:button];
        }];
        MHAlertSheetView *sheet = [[MHAlertSheetView alloc] initWithTitle:@"选择要查看的服务队" buttons:alertButtons comple:^(NSInteger index) {
            vc.teamId = model.team_list[index].team_id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [sheet show];
    }else{
        if (self.type == MHVolSerDetailTypeTeam){
            vc.teamId = self.detail.team_id;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

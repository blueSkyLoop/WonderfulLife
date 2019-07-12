//
//  MHHoMsgNotifiTableViewController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoMsgNotifiTableViewController.h"
#import "MHNavigationControllerManager.h"
#import "MHMacros.h"
#import "MHConst.h"
#import "UIView+NIM.h"
#import "MHHoMsgNotifiCell.h"
#import "MHHoMsgNotifiModel.h"
#import "MHHomeRequest.h"
#import "MJRefresh.h"
#import "MHHUDManager.h"
#import "YYModel.h"
#import "MHConstJpushCmd.h"
#import "MHHoMsgListLogic.h"

#import "MHhoNotificationDetailViewController.h"
#import "MHVolSerReviewDetailController.h"
#import "MHVolSerDetailController.h"
#import "MHVoSerTeamController.h"

#import "MHRefreshGifHeader.h"

#define MHHoMsgNotifiCellID @"MHHoMsgNotifiCellID"
@interface MHHoMsgNotifiTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *mj_footer;
@end

@implementation MHHoMsgNotifiTableViewController{
    CGFloat scale;
    long page;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    scale = MScreenW/375;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"消息通知";
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, 1)];
    line.backgroundColor = MRGBColor(224, 230, 237);
    [self.view addSubview:line];
    
    [self setupTableView];
    
    
    // 监听消息通知，用于实时刷新列表数据   Lo 2017.8.18
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nofiticationReload) name:kReloadMsgNotifiDataSource object:nil];
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)nofiticationReload {
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarWhite];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData{
//    [self.tableView setContentOffset:CGPointZero animated:YES];
    [MHHUDManager show];
    page = 1;
    [MHHomeRequest postNotificationlistWithPage:@(page) NotifyType:nil Callback:^(BOOL success, NSDictionary *data, NSString *errmsg){
        [MHHUDManager dismiss];
        if (success) {
            NSArray *temp = [NSArray yy_modelArrayWithClass:[MHHoMsgNotifiModel class] json:[data objectForKey:@"list"]];
            self.dataList = [NSMutableArray arrayWithArray:temp];
            
            if ([data[@"has_next"] integerValue] == 1) {
                page = 2;
                self.tableView.mj_footer = self.mj_footer;
                [self.mj_footer resetNoMoreData];
            }
            [self.tableView reloadData];
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark -  Request
- (void)loadMoreData{
    [MHHUDManager show];
    [MHHomeRequest postNotificationlistWithPage:@(page) NotifyType:nil Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            NSArray *temp = [NSArray yy_modelArrayWithClass:[MHHoMsgNotifiModel class] json:[data objectForKey:@"list"]];
            [self.dataList addObjectsFromArray:temp];
            if (temp.count) {
                [self.dataList addObjectsFromArray:temp];
                [self.mj_footer endRefreshing];
                page++;
            }else{
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}




#pragma mark - SetUI
- (void)setupTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.nim_width, self.view.nim_height-65)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MHHoMsgNotifiCell class] forCellReuseIdentifier:MHHoMsgNotifiCellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHHoMsgNotifiCell *cell = [tableView dequeueReusableCellWithIdentifier:MHHoMsgNotifiCellID];
    MHHoMsgNotifiModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHHoMsgNotifiModel *model = self.dataList[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MHHoMsgNotifiModel *model = self.dataList[indexPath.row];
    if (model.is_read.integerValue == 0) { //未读
        [MHHUDManager show];
        [MHHomeRequest postNotificationReadWithNotificationId:model.notification_id Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            [MHHUDManager dismiss];
            if (success) {
                model.is_read = @1;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self msgListLogic:model];
            }else{
                [MHHUDManager showErrorText:errmsg];
            }
        }];
        
    }else{ // 已读
        [self msgListLogic:model];
    }
}


- (void)msgListLogic:(MHHoMsgNotifiModel *)model{
    NSString *cmd = model.ext_data.cmd;
    /**  住户审核*/
    if ([cmd isEqualToString:tenementValidateResult]) { // 审核结果
        [MHHoMsgListLogic msgListLogicWithValidateWithResult:model.ext_data.data.is_success];
    }
    
    /** 积分类型*/
    if ([cmd isEqualToString:getScore]) { // 获得积分
        [self pushNotificationDetailWithModel:model];
    }else if ([cmd isEqualToString:sendScore]){ // 职务积分发放
        [self pushNotificationDetailWithModel:model];
    }else if ([cmd isEqualToString:expendScore]){ // 积分消费
        [self pushNotificationDetailWithModel:model];
    }
    
    
    /** 物业类*/
    if ([cmd isEqualToString:propertyPay]) { // 支付物业费成功
        [self pushNotificationDetailWithModel:model];
    }else if ([cmd isEqualToString:dealOrder]){ // 投诉报修已处理
        [self pushNotificationDetailWithModel:model];
    }
    
    /** 职务类型*/
    if ([cmd isEqualToString:volunteerKick]){ // 队员被踢出服务队 > 通知详情页
        [self pushNotificationDetailWithModel:model];
    }else if ([cmd isEqualToString:volunteerExit]){ // 队员退出服务队 > 服务队详情页
        [self pushSerDetailWithApply_id:model.ext_data.data.team_id type:MHVolSerDetailTypeTeam];
    }else if ([cmd isEqualToString:volunteerAppointOther]){ //  被任命其他职务
        [self pushNotificationDetailWithModel:model];
    }else if ([cmd isEqualToString:volunteerKillOther]){ //  被解除其他职务
        [self pushNotificationDetailWithModel:model];
    }
    
    // 以下 4项有关 总队长、队长的操作都会发送给其他成员接收
    if ([cmd isEqualToString:volunteerKillChief]){// 总队长被革职
        [self pushNotificationDetailWithModel:model];
    }else if ([cmd isEqualToString:volunteerKillCaptain]){ // 队长被革职
        [self pushNotificationDetailWithModel:model];
    }else if ([cmd isEqualToString:volunteerAppointCaptain]){ // 被任命为队长
        [self pushSerMyTeam];
    }else if ([cmd isEqualToString:volunteerAppointChief]){ // 被任命为总队长
        [self pushNotificationDetailWithModel:model];
    }
    
    /** 服务项目申请 类型*/
    if ([cmd isEqualToString:volunteerAuditApply]){ // 别人申请加入服务项目
        [self pushSerReviewWithApply_id:model.ext_data.data.apply_id type:MHVolSerReviewDetailControllerReview];
    }else if ([cmd isEqualToString:volunteerApplyWithdraw]){ // 别人撤回了申请
        [self pushSerReviewWithApply_id:model.ext_data.data.apply_id type:MHVolSerReviewDetailControllerBack];
    }
    
    if ([cmd isEqualToString:volunteerAuditPass]){ // 通过 服务队
        [self pushSerDetailWithApply_id:model.ext_data.data.team_id type:MHVolSerDetailTypeTeam];
    }else if ([cmd isEqualToString:volunteerAuditDeny]){ // 拒绝 服务项目
        [self pushSerDetailWithApply_id:model.ext_data.data.activity_id type:MHVolSerDetailTypeItem];
    }
}


// 申请详情
- (void)pushSerReviewWithApply_id:(NSNumber *)apply_id type:(MHVolSerReviewDetailControllerType)type{
    MHVolSerReviewDetailController *vc = [[MHVolSerReviewDetailController alloc] init];
    vc.type = type;
    vc.applyId = apply_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//  服务队详情 | 服务项目详情
- (void)pushSerDetailWithApply_id:(NSNumber *)detailId type:(MHVolSerDetailType)type{
    MHVolSerDetailController *vc = [[MHVolSerDetailController alloc] init];
    vc.type = type;
    vc.detailId = detailId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 我的服务队
- (void)pushSerMyTeam{
    MHVoSerTeamController * vc = [[MHVoSerTeamController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 消息详情
- (void)pushNotificationDetailWithModel:(MHHoMsgNotifiModel *)model{
    MHhoNotificationDetailViewController *vc = [MHhoNotificationDetailViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - lazy
- (MJRefreshAutoNormalFooter *)mj_footer{
    if (_mj_footer == nil) {
        _mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _mj_footer;
}
@end






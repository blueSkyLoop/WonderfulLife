//
//  MHVolActivityListController.m
//  WonderfulLife
//
//  Created by zz on 07/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityListController.h"
#import "MHVolActivityDetailsController.h"//活动详情
#import "MHVolActivityModifyController.h"//修改活动
#import "MHVolActivityConfigurationInfoSelectController.h"//选择服务队
#import "MHVolActivityApplyListController.h" //管理报名列表
#import "MHVoRegisterAttendanceController.h" //考勤登记

#import "MHHUDManager.h"
#import "MHVoActivityListHeaderView.h"
#import "MHActivityStatusView.h"
#import "MHVolActivityListCaptainCell.h"
#import "MHVolActivityListTeammateCell.h"
#import "MHVolActivityListEndOfActivityCell.h"
#import "MHRefreshGifHeader.h"

#import "MHVolActivityListViewModel.h"
#import "MHVolActivityListDataViewModel.h"
#import "MHVolunteerUserInfo.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "ReactiveObjC.h"
#import "Masonry.h"
#import "MHAlertView.h"

#import "UIView+MHFrame.h"
#import "UIViewController+HLNavigation.h"

static NSInteger const MHActivityListDoing = 2; //进行中数据类型
static NSInteger const MHActivityListEnded = 3; //已结束数据类型

typedef NS_ENUM(NSUInteger, MHVolActivityListType) {
    MHVolActivityListTypeCaptain,        //分队长列表
    MHVolActivityListTypeTeammate,       //队友列表
    MHVolActivityListTypeEndOfActivity,  //已结束列表
};

@interface MHVolActivityListController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic) MHVoActivityListHeaderView    *ninHeaderView;
@property (strong ,nonatomic) MHVolActivityListViewModel    *viewModel;
@property (assign ,nonatomic) MHVolActivityListType          listType;
@property (strong ,nonatomic) MHActivityStatusView          *bottomButton;
@property (strong ,nonatomic) MASConstraint                 *tableViewbottomConstraint;
@property (assign ,nonatomic) BOOL  isCaptain;
@end

@implementation MHVolActivityListController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tableView.userInteractionEnabled = YES;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor     = MColorBackgroud;
    
    [self mh_createTalbeView];
    [self mh_initTitleAlignmentLeftLabelWithTitle:@"活动管理"];
    [self mh_addSubViewOnHeaderView:self.ninHeaderView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = MColorSeparator;

    [self bindViewModel];
    [self bindTableViewDataSourceCommand];
    
    [MHHUDManager show];
    [self.viewModel.updateActivityListDatasCommand execute:@(MHActivityListDoing)];
    
    [self configureWidget];
}

- (void)configureWidget {
    //进行中|已结束 点击事件回调
    @weakify(self);
    self.ninHeaderView.clickBlock = ^(NSInteger tag) {
        @strongify(self);
        [MHHUDManager show];
        if (tag == 3) {
            [self.viewModel.doneActivityListDatasCommand execute:nil];
        }else {
            [self.viewModel.doingActivityListDatasCommand execute:nil];
        }
    };
    
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.mas_equalTo(0);
        self.tableViewbottomConstraint = make.bottom.mas_equalTo(0).priorityLow();
    }];
    
    //判断是否是分队长，显示对应的控件、更新列表状态listType
    self.bottomButton = [MHActivityStatusView activityViewWithStatus:MHActivityStatusViewTypeRelease actionBlock:^{
        @strongify(self);
        [self.viewModel.getMyteamsCommand execute:nil];
    }];
    self.bottomButton.frame = CGRectMake(0,MScreenH - 96, MScreenW, 96);
    [self.view addSubview:self.bottomButton];

}

#pragma mark - Public Method
- (void)bindViewModel{
    @weakify(self);
    //修改活动
    [self.viewModel.modifyActivitySubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *team_id,NSNumber *action_id) = x;

        MHVolActivityModifyController *controller = [[MHVolActivityModifyController alloc] init];
        controller.action_id = action_id;
        controller.activity_team_id = team_id;
        controller.type = MHActivityModifyTypeNormal;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //管理报名
    [self.viewModel.enrollListManagerSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *team_id,NSNumber *action_team_ref_id,NSNumber *action_id) = x;
        MHVolActivityApplyListController *controller = [[MHVolActivityApplyListController alloc] init];
        controller.action_team_ref_id = action_team_ref_id;
        controller.action_id = action_id;
        controller.team_id = team_id;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //登记考勤
    [self.viewModel.attendanceRegistrationSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        MHVoRegisterAttendanceController *controller = [MHVoRegisterAttendanceController new];
        controller.action_team_ref_id = x;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //查看详情
    [self.viewModel.reviewDetailSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *team_id,NSNumber *action_team_ref_id,NSNumber *action_id) = x;
        MHVolActivityDetailsController *controller = [[MHVolActivityDetailsController alloc] init];
        controller.action_id = action_id;
        controller.action_team_ref_id = action_team_ref_id;
        controller.team_id = team_id;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    //立即报名
    [self.viewModel.enrollingCommand.executionSignals.switchToLatest  subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x;//元组（是否成功，数据data）
        if ([isSuccess boolValue]) {
            //刷新进行中状态列表
            [MHHUDManager showText:@"活动已报名成功"];
            [self.viewModel.loadNewActivityListDatasCommand execute:@(MHActivityListDoing)];//刷新进行中列表数据
        }else {
            [MHHUDManager showErrorText:datas];
        }
    }];
    //取消报名
    [self.viewModel.enrollCancelCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x; //元组（是否成功，数据data）
        if ([isSuccess boolValue]) {
            //刷新进行中状态列表
            [MHHUDManager showText:@"已取消报名成功"];
            [self.viewModel.loadNewActivityListDatasCommand execute:@(MHActivityListDoing)];//刷新进行中列表数据
        }else{
            [MHHUDManager showErrorText:datas];
        }
    }];
    //发布活动，请求获取我的服务队数量为1的时候，直接跳过
    [self.viewModel.getMyteamsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,id datas) = x; //元组（是否成功，数据data）
        
        if (![isSuccess boolValue]) {
            [MHHUDManager showErrorText:datas];
            return ;
        }
        NSArray *array = datas;
        if (array.count == 1) {
            NSDictionary *dic = [array objectAtIndex:0];
            
            if (![dic[@"has_action_template"] boolValue]) {
                [MHAlertView showMessageAlertViewMessage:@"未配置活动模板，不可发布\n请联系文化专员" sureHandler:^{}];
                return;
            }
            MHVolActivityModifyController *controller = [[MHVolActivityModifyController alloc]init];
            controller.team_id = dic[@"team_id"];
            controller.team_name = dic[@"team_name"];
            controller.type = MHActivityModifyTypePublish;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            MHVolActivityConfigurationInfoSelectController *controller = [[MHVolActivityConfigurationInfoSelectController alloc] init];
            controller.type = MHVolActivityConfigurationInfoSelectTypeTeams;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];

    
    //------------------------- 通知 与 UI更新 -----------------------------/
    
    //注册通知，刷新界面数据
    RACSignal *notificationSignal = [[[NSNotificationCenter defaultCenter]
                                rac_addObserverForName:kReloadVolSerActivityListResultNotification object:nil] takeUntil:self.rac_willDeallocSignal];
    RACSignal *toTopNotificationSignal = [[[NSNotificationCenter defaultCenter]
                                      rac_addObserverForName:kReloadVolSerActivityListResultToTopNotification object:nil] takeUntil:self.rac_willDeallocSignal];
    [notificationSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.ninHeaderView changeToDoingStatus];
        self.listType = self.isCaptain?MHVolActivityListTypeCaptain:MHVolActivityListTypeTeammate;//更新列表状态listType为进行中
        [self.viewModel.loadNewActivityListDatasCommand execute:@(MHActivityListDoing)];//刷新进行中列表数据
    }];
    
    [toTopNotificationSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.ninHeaderView changeToDoingStatus];
        self.listType = self.isCaptain?MHVolActivityListTypeCaptain:MHVolActivityListTypeTeammate;//更新列表状态listType为进行中
        [self.viewModel.updateActivityListDatasToTopCommand execute:@(MHActivityListDoing)];//刷新进行中列表数据
    }];
}

//------------------------- 优化请求 -----------------------------/

- (void)bindTableViewDataSourceCommand {
    
    @weakify(self);
    //活动进行中
    [[self.viewModel.doingActivityListDatasCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,NSNumber *is_last, id datas) = x; //元组（是否成功，是否有下一页，数据列表）
        BOOL success = [isSuccess boolValue];
        [MHHUDManager dismiss];
        if (success) {
            [self.viewModel resetTableviewDataSource];
            [self.viewModel enumerateObjects:datas];
            self.isCaptain = [[MHVolunteerUserInfo sharedInstance].volunteer_is_captain boolValue];
            self.listType = self.isCaptain? MHVolActivityListTypeCaptain:MHVolActivityListTypeTeammate;
            [self refreshDoingActiveTableView:is_last];
        }else {
            [MHHUDManager showErrorText:datas];
        }
    }];
    //活动已结束
    [[self.viewModel.doneActivityListDatasCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,NSNumber *is_last, id datas) = x; //元组（是否成功，是否有下一页，数据列表）
        BOOL success = [isSuccess boolValue];
        [MHHUDManager dismiss];
        if (success) {
            [self.viewModel resetTableviewDataSource];
            [self.viewModel enumerateEndActivityObjects:datas];
            self.listType = MHVolActivityListTypeEndOfActivity; //更新列表状态listType为已结束
            [self refreshDoingActiveTableView:is_last];
        }else {
            [MHHUDManager showErrorText:datas];
        }
    }];
    //刷新活动列表数据请求 [进行中]（首次进来刷新）
    [[self.viewModel.updateActivityListDatasCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,NSNumber *is_last, id datas) = x; //元组（是否成功，是否有下一页，数据列表）
        BOOL success = [isSuccess boolValue];
        [MHHUDManager dismiss];
        if (success) {
            [self.viewModel resetTableviewDataSource];
            [self.viewModel enumerateObjects:datas];
            self.isCaptain = [[MHVolunteerUserInfo sharedInstance].volunteer_is_captain boolValue];
            self.listType = self.isCaptain? MHVolActivityListTypeCaptain:MHVolActivityListTypeTeammate;
            [self refreshDoingActiveTableView:is_last];
        }else {
            [MHHUDManager showErrorText:datas];
        }
    }];
    //刷新活动列表数据请求（下拉刷新）
    [[self.viewModel.loadNewActivityListDatasCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,NSNumber *is_last, id datas) = x; //元组（是否成功，是否有下一页，数据列表）
        BOOL success = [isSuccess boolValue];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if (success) {
            [self.viewModel resetTableviewDataSource];
            if (self.listType == MHVolActivityListTypeEndOfActivity) {
                [self.viewModel enumerateEndActivityObjects:datas];
            }else {
                [self.viewModel enumerateObjects:datas];
            }
            [self refreshDoingActiveTableView:is_last];
        }else {
            [MHHUDManager showErrorText:datas];
        }
    }];
    //加载活动列表更多数据请求（上拉刷新）
    [[self.viewModel.loadMoreActivityListDatasCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,NSNumber *is_last, id datas) = x; //元组（是否成功，是否有下一页，数据列表）
        BOOL success = [isSuccess boolValue];
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (success) {
            [self.viewModel assignNewPage];
            if (self.listType == MHVolActivityListTypeEndOfActivity) {
                [self.viewModel enumerateEndActivityObjects:datas];
            }else {
                [self.viewModel enumerateObjects:datas];
            }
            [self refreshDoingActiveTableView:is_last];
        }else {
            [self.viewModel resetToOldPage];
            [MHHUDManager showErrorText:datas];
        }
    }];
    
    //刷新活动列表（同时已经切换到[进行中]） 数据请求（tableview返回顶部）
    [[self.viewModel.updateActivityListDatasToTopCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *isSuccess,NSNumber *is_last, id datas) = x; //元组（是否成功，是否有下一页，数据列表）
        BOOL success = [isSuccess boolValue];
        if (success) {
            [self.viewModel resetTableviewDataSource];
            [self.viewModel enumerateObjects:datas];
            [self refreshDoingActiveTableView:is_last];
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        }else {
            [MHHUDManager showErrorText:datas];
        }
    }];
}

- (void)refreshDoingActiveTableView:(id)isLast {
    NSArray *array = [self getCurrentListTypeArray];
    NSInteger itemcount = array.count;

    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableViewbottomConstraint.offset = self.isCaptain ? -96 : 0;
        self.bottomButton.hidden = !self.isCaptain;
        [self.view layoutIfNeeded];
        
        self.tableView.userInteractionEnabled = YES;
        [self.tableView reloadData];
        
        if (![isLast boolValue]||itemcount == 0){
            self.tableView.mj_footer = nil;
        }else{
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
    });
}

///下拉刷新数据
- (void)reloadNewData {
    //刷新 进行中|已结束 状态列表
    self.tableView.userInteractionEnabled = NO;
    NSInteger type = self.listType == MHVolActivityListTypeEndOfActivity?MHActivityListEnded:MHActivityListDoing;
    [self.viewModel.loadNewActivityListDatasCommand execute:@(type)];//刷新进行中列表数据
}
///上拉加载更多数据
- (void)loadMoreData {
    self.tableView.userInteractionEnabled = NO;
    //刷新 进行中|已结束 状态列表
    NSInteger type = self.listType == MHVolActivityListTypeEndOfActivity?MHActivityListEnded:MHActivityListDoing;
    [self.viewModel.loadMoreActivityListDatasCommand execute:@(type)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self getCurrentListTypeArray];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    switch (self.listType) {
        case MHVolActivityListTypeCaptain: {
            NSArray *doingArray = self.viewModel.dataSources[0];
            if (doingArray.count < indexPath.row +1) { // 防止越界
                return nil;
            }
            MHVolActivityListCaptainCell *cell = [MHVolActivityListCaptainCell cellWithTableView:tableView];
            MHVolActivityListDataViewModel *model = doingArray[indexPath.row];
            [cell setModel:model viewModel: self.viewModel];
            return cell;
        }
            break;
        case MHVolActivityListTypeTeammate: {
            NSArray *doingArray = self.viewModel.dataSources[0];
            if (doingArray.count < indexPath.row +1) { // 防止越界
                return nil;
            }
            MHVolActivityListTeammateCell *cell = [MHVolActivityListTeammateCell cellWithTableView:tableView];
            MHVolActivityListDataViewModel *model = doingArray[indexPath.row];
            [cell setModel:model viewModel: self.viewModel];
            return cell;
        }
            break;
        case MHVolActivityListTypeEndOfActivity: {
            NSArray *endArray = self.viewModel.dataSources[1];
            MHVolActivityListEndOfActivityCell *cell = [MHVolActivityListEndOfActivityCell cellWithTableView:tableView];
            MHVolActivityListDataViewModel *model = endArray[indexPath.row];
            [cell setModel:model viewModel: self.viewModel];
            return cell;
        }
            break;
    }
    return nil;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.dataSources.count == 0) {
        return .1f;
    }
    NSArray *array = [self getCurrentListTypeArray];
    MHVolActivityListDataViewModel *model = array[indexPath.row];
    return model.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVolActivityDetailsController *controller = [[MHVolActivityDetailsController alloc] init];
    NSArray *array = [self getCurrentListTypeArray];
    MHVolActivityListDataViewModel *model = array[indexPath.row];
    controller.action_id = model.action_id;
    controller.action_team_ref_id = model.action_team_ref_id;
    controller.team_id = model.activity_team_id;

    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self mh_scrollUpdateTitleLabelWithContainerView];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self mh_scrollUpdateTitleLabelWithContainerView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self mh_scrollUpdateTitleLabelWithContainerView];
}

#pragma mark - Private Method
- (NSArray*)getCurrentListTypeArray {
    NSArray *array;
    if (self.listType == MHVolActivityListTypeEndOfActivity) {
        array = self.viewModel.dataSources[1];
    }else {
        array = self.viewModel.dataSources[0];
    }
    return array;
}

- (MHVoActivityListHeaderView*)ninHeaderView {
    if (!_ninHeaderView) {
        _ninHeaderView = [MHVoActivityListHeaderView voSeButtonHeaderView];
        _ninHeaderView.frame = CGRectMake(16, 80, MScreenW - 32, 56);
    }
    return _ninHeaderView;
}

- (MHVolActivityListViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [[MHVolActivityListViewModel alloc] init];
    }
    return _viewModel;
}

@end

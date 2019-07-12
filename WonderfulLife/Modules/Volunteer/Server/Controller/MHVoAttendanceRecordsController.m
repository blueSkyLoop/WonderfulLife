//
//  MHVoAttendenceRecordsController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRecordsController.h"
#import "MHVoAtReDaySiftController.h"
#import "MHNavigationControllerManager.h"
#import "MHVoAttendanceRecordDetailController.h"
#import "MHVoAtReMonthSiftController.h"
#import "MHVolActivityListController.h"
#import "MHVoRegisterAttendanceController.h"

#import "MHVoAttendanceRecordCell.h"
#import "MHAttendanceRecordSectionHeader.h"
#import "MHVoseAttendanceRecordMonCell.h"
#import "MHRefreshGifHeader.h"

#import "MHMacros.h"
#import "UIView+NIM.h"
#import "UIView+Shadow.h"
#import "YYText.h"
#import "MHHUDManager.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "UINavigationController+RemoveChildController.h"
#import "MHConst.h"

#import "MHVoServerRequestDataHandler.h"
#import "MHVoAttendanceRecordDailyModel.h"
#import "MHVoAttendanceRecordDetailModel.h"
#import "MHVoAttendanceRecordSiftModel.h"
#import "MHVoAttendanceRegisterModel.h"

#define MHVoAttendanceRecordCellID @"MHVoAttendanceRecordCellID"
#define MHAttendanceRecordSectionHeaderID @"MHAttendanceRecordSectionHeaderID"
NSString *MHVoseAttendanceRecordMonCellID = @"MHVoseAttendanceRecordMonCellID";
#define MHVoAttendanceRecordEmptyCellID @"MHVoAttendanceRecordEmptyCellID"
@interface MHVoAttendanceRecordsController ()<UITableViewDelegate,UITableViewDataSource,MHNavigationControllerManagerProtocol,MHVoAttendanceRecordCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,weak) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet UIView *redLine;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (strong, nonatomic) IBOutlet UIView *monthTopView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic,strong) UIView *emptyFooterView;
@property (nonatomic,strong) UIView *emptySiftFooterView;

@property (nonatomic,strong) UIView *footerView;

@property (nonatomic,strong) MHVoAttendanceRecordSiftModel *siftModel;
@property (nonatomic,strong) NSMutableArray  <MHVoAttendanceRecordMonthModel *>* monthDataModels;

@property (nonatomic,strong) NSMutableArray *actions_monthly_list;
@end

@implementation MHVoAttendanceRecordsController{
    CGPoint titleOriginCenter;
    CGPoint titleFinalCenter;
    CGSize titleOriginSize;
    CGSize titleFinalSize;
    CGFloat topInset;
    BOOL change;
    NSDate *date;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    date = [NSDate date];
    self.monthDataModels = [NSMutableArray array];
    self.actions_monthly_list = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerView.frame = CGRectMake(0, 64, MScreenW, 160);
    
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    titleOriginCenter = self.titleLabel.center;
    titleFinalCenter = CGPointMake(MScreenW/2, 42);
    titleOriginSize = CGSizeMake(130, 45) ;
    titleFinalSize = CGSizeMake(74, 25);
    topInset = 96;
    [self.view addSubview:self.headerView];
    [self.buttonContainerView mh_setupContainerLayerWithContainerView];
    
    self.lineView.nim_top = 159.5;
    self.lineView.nim_height = 0.5;
    
    [self setupTableView];
    [self setupNav];
    
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    
    [self.tableView.mj_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@54);
        make.top.equalTo(@(-topInset-54));
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.tableView setContentOffset:CGPointMake(0, -(topInset-64)) animated:NO];
}

#pragma mark - protocol
- (BOOL)bb_ShouldBack{
    if (change == NO) {
        if ([self.navigationController.viewControllers[2] isKindOfClass:[MHVolActivityListController class]]) {
            if (self.navigationController.viewControllers.count == 5 ) {
                [self.navigationController mh_removeChildViewControllersInRange:NSMakeRange(3, 1)];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolSerActivityListResultNotification object:nil];
            }else if (self.navigationController.viewControllers.count == 6){
                [self.navigationController mh_removeChildViewControllersInRange:NSMakeRange(3, 2)];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolSerActivityListResultNotification object:nil];

            }
        }
        
        change = YES;
    }
    return YES;
}

#pragma mark - 按钮点击

- (void)sift{
    if (self.selectedButton.tag == 1) {
        MHVoAtReMonthSiftController *vc = [MHVoAtReMonthSiftController new];
        vc.siftModel = self.siftModel;
        [vc setBeginSift:^{
            [self loadMonthData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        MHVoAtReDaySiftController *vc = [MHVoAtReDaySiftController new];
        vc.siftModel = self.siftModel;
        [vc setBeginSift:^{
            [self loadDayData];
        }];
        MHNavigationControllerManager *nav = [[MHNavigationControllerManager alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}
- (IBAction)dayMonthChange:(UIButton *)sender {
    if ([self.tableView.mj_header isRefreshing]) {
        return;
    }
    if (sender.tag == 0) {
        topInset = 96;
        [self.monthTopView removeFromSuperview];
        self.headerView.nim_height -= 48;
        
        self.footerView.nim_height = 16;
        
    }else if (sender.tag == 1){
        topInset = 144;
        [self.headerView addSubview:self.monthTopView];
        self.monthTopView.frame = CGRectMake(0, 160, MScreenW, 48);
        self.headerView.nim_height += 48;
        
        self.footerView.nim_height = 42;
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView.mj_header mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(-topInset-54));
    }];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.redLine.nim_centerX = sender.nim_centerX;
    [UIView commitAnimations];
    
    self.selectedButton.enabled = YES;
    sender.enabled = NO;
    
    
    self.selectedButton = sender;
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    [self.tableView setContentOffset:CGPointMake(0, -topInset) animated:NO];
    [self.tableView reloadData]; //妈的必不可少
    [self.tableView.mj_header beginRefreshing];
    
    

}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selectedButton.tag == 0) {
        return self.actions_monthly_list.count;
    }else{
        return self.monthDataModels.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectedButton.tag == 0) {
        MHVoAttendanceRecordDailyMonthModel *monthModel = self.actions_monthly_list[section];
        return monthModel.actions.count ? monthModel.actions.count : 1;
    }else{
        MHVoAttendanceRecordMonthModel *monthModel = self.monthDataModels[section];
        return monthModel.crews.count ? monthModel.crews.count : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedButton.tag == 0) {
        
        MHVoAttendanceRecordDailyMonthModel *monthModel = self.actions_monthly_list[indexPath.section];
        if (monthModel.actions.count) {
            MHVoAttendanceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordCellID];
            MHVoAttendanceRecordDailyActionModel *action = monthModel.actions[indexPath.row];
            cell.role_in_team = self.role_in_team;
            cell.model = action;
            cell.delegate = self;
            return cell;
        }else{
            MHVoAttendanceRecordEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordEmptyCellID];
            return cell;
        }

    }else{
        MHVoAttendanceRecordMonthModel *monthModel = self.monthDataModels[indexPath.section];
        if (monthModel.crews.count != 0) {
            MHVoseAttendanceRecordMonCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoseAttendanceRecordMonCellID forIndexPath:indexPath];
            
            cell.dataModel = monthModel.crews[indexPath.row];
            cell.timeCenterX = self.timeLabel.nim_centerX;
            cell.scoreCenterX = self.scoreLabel.nim_centerX;
            return cell;
            
        }else{
            MHVoAttendanceRecordEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordEmptyCellID];
            return cell;
        }

    }
    
}


#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedButton.tag == 0) {
        MHVoAttendanceRecordDailyMonthModel *monthModel = self.actions_monthly_list[indexPath.section];
        if (monthModel.actions.count) {
            MHVoAttendanceRecordDailyActionModel *action = monthModel.actions[indexPath.row];
            
            if (self.role_in_team.integerValue == 0){
                // 默认为最简约的cell  ， 队员身份
                return 252 ;
                
            }else if (action.attendance_status.integerValue != 1 && self.role_in_team.integerValue == 1) { // 不为"已通过”状态 && 队长  可操作
                return  357;

            }else{  // 总队长 || 队长 ， 审核状态 已通过都用这个高度
                return  285;
            }
            
//            CGFloat  cell_H = self.role_in_team.integerValue ? (action.attendance_status.integerValue!=1 ? 357 : 285) : 252;

            
        }else{
            return 72;
        }
        
    }else{
        MHVoAttendanceRecordMonthModel *monthModel = self.monthDataModels[indexPath.section];
        if (monthModel.crews.count != 0) {
            return 80;
            
        }else{
            return 72;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.selectedButton.tag == 0) {
        MHVoAttendanceRecordDailyMonthModel *monthModel = self.actions_monthly_list[indexPath.section];
        if (monthModel.actions.count == 0) {
            return;
        }
        MHVoAttendanceRecordDailyActionModel *action = monthModel.actions[indexPath.row];
        
        [MHHUDManager show];
        [MHVoServerRequestDataHandler postVolunteerAttendanceDetailWithTeamRefId:action.attendance_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            [MHHUDManager dismiss];
            if (success) {
                MHVoAttendanceRecordDetailController *vc = [MHVoAttendanceRecordDetailController new];
                vc.action_team_ref_id = action.attendance_id;
                vc.model = [MHVoAttendanceRecordDetailModel
                             yy_modelWithJSON:data];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [MHHUDManager showErrorText:errmsg];
            }
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.selectedButton.tag == 0) {
        MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
        header.type = self.selectedButton.tag;
        MHVoAttendanceRecordDailyMonthModel *monthModel = self.actions_monthly_list[section];
        header.timeLabel.text = monthModel.year_month;
        return header;
    }else{
        MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
        header.type = self.selectedButton.tag;
        MHVoAttendanceRecordMonthModel *monthModel = self.monthDataModels[section];
        header.timeLabel.text = monthModel.year_month;
        return header;
//        if (self.monthList.count == 0) {
//            return nil;
//        }else{
//        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollTitleLabel];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self scrollTitleLabel];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self scrollTitleLabel];
}

- (void)cellButtonDidClick:(MHVoAttendanceRecordDailyActionModel *)actionModel{
    if (actionModel.attendance_status.integerValue == 2) {//不通过
        [MHHUDManager show];
        [MHVoServerRequestDataHandler postVolunteerAttendanceDetailWithTeamRefId:actionModel.attendance_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            [MHHUDManager dismiss];
            if (success) {
                MHVoAttendanceRecordDetailController *vc = [MHVoAttendanceRecordDetailController new];
                vc.action_team_ref_id = actionModel.attendance_id;
                vc.model = [MHVoAttendanceRecordDetailModel
                            yy_modelWithJSON:data];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [MHHUDManager showErrorText:errmsg];
            }
        }];
    }else{
        
        [MHHUDManager show];
        [MHVoServerRequestDataHandler postVolunteerAttendanceDetailWithTeamRefId:actionModel.attendance_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            if (success) {
                MHVoAttendanceRecordDetailModel *_model = [MHVoAttendanceRecordDetailModel
                            yy_modelWithJSON:data];
                [MHVoServerRequestDataHandler postVolunteerAttendanceStatusQuery:_model.attendance_id CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
                    [MHHUDManager dismiss];
                    if (success) {
                        if ([data[@"attendance_status"] integerValue] == 1) {
                            [MHHUDManager showText:@"已审核通过，不可修改"];
                            return ;
                        }else{
                            
                            MHVoRegisterAttendanceController *vc = [MHVoRegisterAttendanceController new];
                            MHVoAttendanceRegisterModel *modifyModel = [MHVoAttendanceRegisterModel new];
                            modifyModel.has_virtual_account = _model.has_virtual_account;
                            modifyModel.attendance_id = _model.attendance_id;
                            modifyModel.imgs = _model.imgs;
                            modifyModel.tempImgs = _model.imgs.mutableCopy;
                            modifyModel.deleted_imgs = [NSMutableArray array];
                            modifyModel.score_rule_method = _model.score_rule_method;
                            modifyModel.action_total_score = _model.action_total_score;
                            modifyModel.action_total_duration = _model.action_total_duration;
                            
                            modifyModel.imgs = _model.imgs;
                            
                            modifyModel.applied = _model.applied_crews;
                            modifyModel.not_apply = _model.not_apply_crews;
                            
                            CGFloat totalScore = _model.action_total_score.floatValue;
                            CGFloat unAllocScore = totalScore;
                            NSInteger totalHour = _model.action_total_duration.integerValue;
                            
                            for (MHVoAttendanceRecordDetailCrewModel *model in _model.applied_crews) {
                                CGFloat score = model.score.floatValue;
                                unAllocScore -= score;
                                
                                model.registerAllocScore = score;
                                
                                CGFloat registerAllocTime = (score/totalScore)*totalHour;
                                registerAllocTime = floor(registerAllocTime*10)/10;
                                
                                if (registerAllocTime - (NSInteger)registerAllocTime > 0.5) {
                                    registerAllocTime = (NSInteger)registerAllocTime + 0.5;
                                }else if (registerAllocTime - (NSInteger)registerAllocTime < 0.5){
                                    registerAllocTime = (NSInteger)registerAllocTime;
                                }
                                model.registerAllocTime = registerAllocTime;
                            }
                            for (MHVoAttendanceRecordDetailCrewModel *model in _model.not_apply_crews) {
                                CGFloat score = model.score.floatValue;
                                unAllocScore -= score;
                                
                                model.registerAllocScore = score;
                                
                                CGFloat registerAllocTime = (score/totalScore)*totalHour;
                                registerAllocTime = floor(registerAllocTime*10)/10;
                                
                                if (registerAllocTime - (NSInteger)registerAllocTime > 0.5) {
                                    registerAllocTime = (NSInteger)registerAllocTime + 0.5;
                                }else if (registerAllocTime - (NSInteger)registerAllocTime < 0.5){
                                    registerAllocTime = (NSInteger)registerAllocTime;
                                }
                                model.registerAllocTime = registerAllocTime;
                            }
                            modifyModel.unAllocScore = unAllocScore;
                            
                            modifyModel.remarks = _model.remark;
                            vc.model = modifyModel;
                            vc.action_team_ref_id = actionModel.attendance_id;
                            [self.navigationController pushViewController:vc animated:YES];
                            
                            
                        }
                    }else{
                        [MHHUDManager showErrorText:errmsg];
                    }
                }];
            }else{
                [MHHUDManager dismiss];
                [MHHUDManager showErrorText:errmsg];
            }
        }];
        
    }
    
}

#pragma mark - private
- (void)loadData{
    if (self.selectedButton.tag == 0) {
        [self loadDayData];
    }else{
        [self loadMonthData];
        
    }
}

- (void)refresh{
    [self.tableView.mj_header beginRefreshing];
}

- (void)scrollTitleLabel{
    CGFloat offsetY = self.tableView.contentOffset.y;
//#ifdef DEBUG
//    NSLog(@"offsetY = %f",offsetY);
//#endif
    if (offsetY < -(topInset-64)) {
        self.headerView.nim_top = 64 - (topInset+offsetY);
        
    }else if (offsetY >= -(topInset-64)){
        self.headerView.nim_top = 0;
        self.titleLabel.nim_size = titleFinalSize;
        self.titleLabel.center = titleFinalCenter;

    }
    if (offsetY <= -topInset){
        self.titleLabel.nim_size = titleOriginSize;
        self.titleLabel.center = titleOriginCenter;
    }else if (offsetY > -topInset && offsetY< -(topInset-64)) {
        CGFloat headerTop = 64 - (topInset+offsetY);
        CGFloat scale = 1 - headerTop/64.00;
        
        CGFloat centerX = titleOriginCenter.x + (titleFinalCenter.x - titleOriginCenter.x)*scale;
        CGFloat centerY = titleOriginCenter.y + (titleFinalCenter.y - titleOriginCenter.y)*scale;
        CGFloat width = titleOriginSize.width - (titleOriginSize.width - titleFinalSize.width)*scale;
        CGFloat height = titleOriginSize.height - (titleOriginSize.height - titleFinalSize.height)*scale;
        self.titleLabel.nim_size = CGSizeMake(width, height);
        self.titleLabel.center = CGPointMake(centerX, centerY);
    }
}

- (void)recursiveRequestMonth{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger year = [calender component:NSCalendarUnitYear fromDate:date];
    NSInteger month = [calender component:NSCalendarUnitMonth fromDate:date];
    
    [MHVoServerRequestDataHandler postVolunteerAttendanceMonthlyList:_attendance_id Year:@(year) Month:@(month) CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        if (success) {
            if ([data[@"has_next"] integerValue] == 1) {
                [self.monthDataModels addObject:[MHVoAttendanceRecordMonthModel yy_modelWithJSON:data]];
                NSDateComponents *comps = [[NSDateComponents alloc] init];
                [comps setMonth:-1];
                date = [calender dateByAddingComponents:comps toDate:date options:0];
                [self recursiveRequestMonth];
            }else{
                [self.monthDataModels addObject:[MHVoAttendanceRecordMonthModel yy_modelWithJSON:data]];
                date = [NSDate date];
//                if (self.monthDataModels.count == 0) {
//                    self.tableView.tableFooterView = nil;
//                }else{
//
//                }
                [self.tableView reloadData];
//                [MHHUDManager dismiss];
                [self.tableView.mj_header endRefreshing];
            }
        }else{
            date = [NSDate date];
//            [MHHUDManager dismiss];
            [self.tableView.mj_header endRefreshing];
            [MHHUDManager showErrorText:errmsg];
        }
        
    }];
}

- (void)loadDayData{
    [self.actions_monthly_list removeAllObjects];
    [self.tableView reloadData];
//    [MHHUDManager show];
    
    if (_siftModel.requestDateBegin) {
        [MHVoServerRequestDataHandler postVolunteerAttendanceDailyListWithTeamId:_attendance_id Year:nil Month:nil DateBegin:_siftModel.requestDateBegin DateEnd:_siftModel.requestDateEnd AttendanceStatus:[NSNumber numberWithLong:self.siftModel.attendance_status] CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            
            if (success) {
                NSArray <MHVoAttendanceRecordDailyMonthModel *>*array = [NSArray yy_modelArrayWithClass:[MHVoAttendanceRecordDailyMonthModel class] json:data[@"actions_monthly_list"]];
                [self.actions_monthly_list addObjectsFromArray:array];
                [self.tableView reloadData];
                if (array.firstObject.actions.count ==0) {
                    self.tableView.tableFooterView = self.emptyFooterView;
                }else{
                    self.tableView.tableFooterView = self.footerView;
                }
            }else{
                [MHHUDManager showErrorText:errmsg];
            }
            
//            [MHHUDManager dismiss];
            [self.tableView.mj_header endRefreshing];
            
        }];
    }else{
        [self recursiveRequestDay];
    }
    
}

- (void)recursiveRequestDay{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger year = [calender component:NSCalendarUnitYear fromDate:date];
    NSInteger month = [calender component:NSCalendarUnitMonth fromDate:date];
    
    [MHVoServerRequestDataHandler postVolunteerAttendanceDailyListWithTeamId:_attendance_id Year:@(year) Month:@(month) DateBegin:nil DateEnd:nil AttendanceStatus:nil CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        if (success) {
            if ([data[@"has_next"] integerValue] == 1) {
                [self.actions_monthly_list addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MHVoAttendanceRecordDailyMonthModel class] json:data[@"actions_monthly_list"]]];
                NSDateComponents *comps = [[NSDateComponents alloc] init];
                [comps setMonth:-1];
                date = [calender dateByAddingComponents:comps toDate:date options:0];
                [self recursiveRequestDay];
            }else{
                [self.actions_monthly_list addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MHVoAttendanceRecordDailyMonthModel class] json:data[@"actions_monthly_list"]]];
                
                date = [NSDate date];
                [self.tableView reloadData];
//                [MHHUDManager dismiss];
                [self.tableView.mj_header endRefreshing];
            }
        }else{
//            [MHHUDManager dismiss];
            date = [NSDate date];
            [self.tableView.mj_header endRefreshing];
            [MHHUDManager showErrorText:errmsg];
        }
        
    }];
}

- (void)loadMonthData{
    [self.monthDataModels removeAllObjects];
//    [MHHUDManager show];
    if (_siftModel.year) {
        [MHVoServerRequestDataHandler postVolunteerAttendanceMonthlyList:_attendance_id Year:_siftModel.year Month:_siftModel.month CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            if (success) {
                [self.monthDataModels addObject:[MHVoAttendanceRecordMonthModel yy_modelWithJSON:data]];
                [self.tableView reloadData];
                self.tableView.tableFooterView = nil;
            }else{
                [MHHUDManager showErrorText:errmsg];
            }
//            [MHHUDManager dismiss];
            [self.tableView.mj_header endRefreshing];
        }];
        
        
    }else{
        [self recursiveRequestMonth];
    }
}

- (void)setupTableView{
    
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);//注意要放在tableHeaderView前面，不然sectionHeader一下不出来
    UIView *placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
    self.tableView.tableHeaderView = placeHolderView;
    [self.tableView registerNib:[UINib nibWithNibName:@"MHVoAttendanceRecordCell" bundle:nil] forCellReuseIdentifier:MHVoAttendanceRecordCellID];
    [self.tableView registerClass:[MHAttendanceRecordSectionHeader class] forHeaderFooterViewReuseIdentifier:MHAttendanceRecordSectionHeaderID];
    [self.tableView registerNib:[UINib nibWithNibName:@"MHVoseAttendanceRecordMonCell" bundle:nil] forCellReuseIdentifier:MHVoseAttendanceRecordMonCellID];
    [self.tableView registerClass:[MHVoAttendanceRecordEmptyCell class] forCellReuseIdentifier:MHVoAttendanceRecordEmptyCellID];
    self.tableView.backgroundColor = MColorBackgroud;
    self.tableView.separatorColor = MColorSeparator;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
    self.footerView.backgroundColor = MColorDidSelectCell;
}

- (void)setupNav{
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"筛选" forState:UIControlStateNormal];
    UIFont *font;
    if (iOS8) {
        font = [UIFont systemFontOfSize:17];
    }else{
        font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }
    
    confirm.titleLabel.font = font;
    [confirm sizeToFit];
    [confirm setTitleColor:MColorTitle forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(sift) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:MColorTitle}];
}
#pragma mark - lazy
- (MHVoAttendanceRecordSiftModel *)siftModel{
    if (_siftModel == nil) {
        _siftModel = [MHVoAttendanceRecordSiftModel new];
    }
    return _siftModel;
}

- (UIView *)emptyFooterView{
    if (_emptyFooterView == nil) {
        UIView *emptyFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MScreenH-160)];
        emptyFooterView.backgroundColor = MColorDidSelectCell;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vo_se_empty_attendance"]];
        [emptyFooterView addSubview:imageView];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.nim_size = CGSizeMake(120, 120);
        imageView.center = CGPointMake(MScreenW/2, emptyFooterView.nim_height/2-25);
        
        UILabel *label = [[UILabel alloc] init];
        [emptyFooterView addSubview:label];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"暂无考勤记录"];
        att.yy_kern = @2;
        label.textColor = MColorContent;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        label.attributedText = att;
        [label sizeToFit];
        label.nim_top = imageView.nim_bottom + 26;
        label.nim_centerX = imageView.nim_centerX;
        
        _emptyFooterView = emptyFooterView;
    }
    return _emptyFooterView;
}

- (UIView *)emptySiftFooterView{
    if (_emptySiftFooterView == nil) {
        UIView *emptySiftFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MScreenH-160)];
        emptySiftFooterView.backgroundColor = MColorDidSelectCell;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vo_se_empty_attendance"]];
        [emptySiftFooterView addSubview:imageView];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.nim_size = CGSizeMake(120, 120);
        imageView.center = CGPointMake(MScreenW/2, emptySiftFooterView.nim_height/2-25);
        
        UILabel *label = [[UILabel alloc] init];
        [emptySiftFooterView addSubview:label];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"没有符合筛选条件的考勤记录"];
        att.yy_kern = @2;
        label.textColor = MColorContent;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        label.attributedText = att;
        [label sizeToFit];
        label.nim_top = imageView.nim_bottom + 26;
        label.nim_centerX = imageView.nim_centerX;
        
        _emptySiftFooterView = emptySiftFooterView;
    }
    return _emptySiftFooterView;
}
#ifdef DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif
@end








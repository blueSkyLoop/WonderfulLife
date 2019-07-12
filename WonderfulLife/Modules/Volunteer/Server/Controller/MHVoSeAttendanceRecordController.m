//
//  MHVoSeAttendanceRecordController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSeAttendanceRecordController.h"
#import "MHVoseAttendanceRecordDayController.h"
#import "MHNavigationControllerManager.h"
#import "MHAttendanceRegisterController.h"
#import "MHVoSerTeamController.h"

#import "MHVoSeAttendanceRecordDayCell.h"
#import "MHVoseAttendanceRecordMonCell.h"
#import "MHVoseAttendanceRecordMonHeaderSectionCell.h"
#import "MHVoSeButtonHeaderView.h"
#import "MHVoSeMonStepperButtonView.h"
#import "MHHUDManager.h"

#import "MHVolSerAttendanceRecordModel.h"
#import "MHVoServerRequestDataHandler.h"

#import "UIView+MHFrame.h"
#import "UIView+EmptyView.h"
#import "UIViewController+MHConfigControls.h"
#import "MHWeakStrongDefine.h"
#import "MHMacros.h"

#import "UINavigationController+RemoveChildController.h"
#import <MJRefresh.h>
@interface MHVoSeAttendanceRecordController () <MHNavigationControllerManagerProtocol>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) MHVoSeMonStepperButtonView *monBtnView;
@property (nonatomic, strong) UITableView *monTableView;
@property (nonatomic, strong) UILabel *alertLab;

@property (nonatomic, strong) MHVolSerAttendanceRecordModel *model;
@property (nonatomic, strong) NSMutableArray *recordsByDayDataSource;
@property (nonatomic, strong) NSArray *recordsByMonthDataSource;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger dayDataLastYear;
@property (nonatomic, assign) NSInteger dayDataLastMonth;

@property (nonatomic,assign) BOOL change;

@end

@implementation MHVoSeAttendanceRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mh_createTalbeView];
    self.tableView.mh_y = 152;
    self.tableView.mh_h = MScreenH - self.tableView.mh_y;
    self.tableView.rowHeight = 72;
    self.tableView.backgroundColor = MColorBackgroud;
    
    [self.view addSubview:self.headerView];
    
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    _dayDataLastYear = [dateComponent year];
    _dayDataLastMonth =  [dateComponent month];

    _year = 0;
    _month = 0;
    //request
    [self reqeustDataWithType:0 year:0 month:0];
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    [nav navigationBarTranslucent];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (BOOL)bb_ShouldBack{
    //需求。。。
    NSInteger idx = [self.navigationController.viewControllers indexOfObject:self];
    UIViewController *lastvc = [self.navigationController.viewControllers objectAtIndex:idx - 1];
    if ([lastvc isKindOfClass:[MHAttendanceRegisterController class]]) {
        UIViewController *teamvc = [self.navigationController.viewControllers objectAtIndex:2];
        if ([teamvc isKindOfClass:[MHVoSerTeamController class]]) {
            
            if (self.change == NO) {//防止多次左滑动
                [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
            }
            self.change = YES;
            return NO;
            
        } else {
            if (self.change == NO) {//防止多次左滑动
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            }
            self.change = YES;
            return NO;
        }
    } else {
        return YES;
    }
}

#pragma mark - Reqeust
- (void)reqeustDataWithType:(NSInteger)type year:(NSInteger)year month:(NSInteger)month {
    [MHHUDManager show];
    
    
    [MHVoServerRequestDataHandler getAttendanceRecordListWithType:type teamId:self.teamId id_type:self.id_type year:year month:month Success:^(MHVolSerAttendanceRecordModel *model, NSInteger yearInt, NSInteger monthInt) {
        [MHHUDManager dismiss];
        [self.tableView.mj_footer endRefreshing];
        self.model = model;
        
        if (type == 0) {
            if (monthInt == 1) {
                self.dayDataLastYear = yearInt - 1;
                self.dayDataLastMonth = 12;
            } else {
                self.dayDataLastMonth = monthInt - 1;
            }
            //日
            if (self.model.records_by_day.count) {
                [self.recordsByDayDataSource addObjectsFromArray:self.model.records_by_day];
            }
            [self.tableView reloadData];
            
            if ([self.model.query_finished isEqualToString:@"y"]) {
                [self p_mjRefreshStateNextPageIsHasData:NO];
            } else {
                [self p_mjRefreshStateNextPageIsHasData:YES];
            }
        } else {
            //月
            self.recordsByMonthDataSource = self.model.records_by_month;
            [self.monTableView reloadData];
        }
    } failure:^(NSString *errmsg) {
        [self.tableView.mj_footer endRefreshing];
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}
#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        if (self.recordsByDayDataSource.count) {
            [self.view mh_removeEmptyView];
        } else {
            [self.view mh_addEmptyViewImageName:@"vo_se_empty_attendance" title:@"暂无考勤记录"];
            [self.view mh_setEmptyCenterYOffset:100];
        }
        return self.recordsByDayDataSource.count;
    } else {
        if (self.recordsByMonthDataSource.count) {
            [self.view mh_removeEmptyView];
        } else {
            [self.view mh_addEmptyViewImageName:@"vo_se_empty_attendance" title:@"暂无考勤记录"];
            [self.view mh_setEmptyCenterYOffset:100];
          
        }
        return self.recordsByMonthDataSource.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        MHVolSerAttendanceRecordByDayModel *dayModel = self.recordsByDayDataSource[section];
        return dayModel.attendance_list.count ? dayModel.attendance_list.count : 1;
    }else {
       MHVolSerAttendanceRecordByMonthModel *byMonthModel = self.recordsByMonthDataSource[section];
        return byMonthModel.attendance_list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
         MHVoSeAttendanceRecordDayCell *cell = [MHVoSeAttendanceRecordDayCell cellWithTableView:tableView];
        
        MHVolSerAttendanceRecordByDayModel *byDayModel  = self.recordsByDayDataSource[indexPath.section];
        if (byDayModel.attendance_list.count) {
            MHVolSerAttendanceRecordByDayDetailModel *byDayDetailModel = byDayModel.attendance_list[indexPath.row];
            cell.model = byDayDetailModel;
        } else {
            //传个nil。内部写逻辑。 需求需求需求
            cell.model = nil;
        }
        return cell;
    } else {
        MHVolSerAttendanceRecordByMonthModel *byMonthModel = self.recordsByMonthDataSource[indexPath.section];
        MHVolSerAttendanceRecordDetailByUserModel *byMonthDetailModel = byMonthModel.attendance_list[indexPath.row];
       MHVoseAttendanceRecordMonCell *cell = [MHVoseAttendanceRecordMonCell cellWithTableView:tableView];
        cell.model = byMonthDetailModel;
        return cell;
    }
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        MHVoseAttendanceRecordDayController *vc = [[MHVoseAttendanceRecordDayController alloc] init];
         MHVolSerAttendanceRecordByDayModel *dayModel = self.recordsByDayDataSource[indexPath.section];
        if (dayModel.attendance_list.count) {
            MHVolSerAttendanceRecordByDayDetailModel *detailModel = dayModel.attendance_list[indexPath.row];
            vc.attendance_id = detailModel.attendance_id;
            vc.teamId = self.teamId;
            vc.id_type = self.id_type;
            vc.date = detailModel.service_date;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        static NSString *headId = @"HeadId";
        UITableViewHeaderFooterView *hv = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId];
        if (!hv) {
            hv = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headId];
        }
        // Lo 2017.8.1 尼玛的巨坑，3：48
        [hv.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(24, 48/2 - 17/2.0, 150, 17);
        lab.textColor = MColorTitle;
        [hv.contentView addSubview:lab];
        
        MHVolSerAttendanceRecordByDayModel *byDayModel  = self.recordsByDayDataSource[section];
        lab.text = byDayModel.month;
        
        return hv;
    } else {
        if (section == 0) {
            MHVoseAttendanceRecordMonHeaderSectionCell *hv = [[[NSBundle mainBundle] loadNibNamed:@"MHVoseAttendanceRecordMonHeaderSectionCell" owner:nil options:nil] lastObject];
            hv.backgroundColor = MColorToRGB(0XF9FAFC);
            hv.nameLab.text = @"队员名单";
            hv.timeLab.text = @"时长";
            hv.scoreLab.text = @"积分";
            return hv;
        }
    }
    return nil;
   
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = MColorToRGB(0XF9FAFC);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

#pragma mark - Private
- (void)p_mjRefreshStateNextPageIsHasData:(BOOL )has{
    
    if (has && !self.tableView.mj_footer ) {
        MHWeakify(self);
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            MHStrongify(self);

            [self reqeustDataWithType:0 year:self.dayDataLastYear month:self.dayDataLastMonth];
        }];
    }
    if (!has) {
        self.tableView.mj_footer = nil;
    }
}

#pragma mark - Getter
- (UITableView *)monTableView {
    if (!_monTableView) {
        _monTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, MScreenW, MScreenH - 250) style:UITableViewStylePlain];
        _monTableView.delegate = self;
        _monTableView.dataSource = self;
        _monTableView.tableFooterView = [UIView new];
        _monTableView.rowHeight = 80;
        _monTableView.hidden = YES;
        _monTableView.backgroundColor = MColorBackgroud;

    }
    return _monTableView;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, MScreenW, 152);
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:({
            MHVoSeButtonHeaderView *btnv = [MHVoSeButtonHeaderView voSeButtonHeaderView];
            MHWeakify(self)
            btnv.clickBlock = ^(NSInteger tag){
                MHStrongify(self)
                if (tag == 0) {
                    self.monTableView.hidden = YES;
                    self.monBtnView.hidden = YES;
        
                    _headerView.mh_h = 152;
                    self.tableView.hidden = NO;
                    [self.tableView reloadData];
//                    [self reqeustDataWithType:0 year:0 month:0];
                    
                } else {
                    self.tableView.hidden = YES;
                    self.monBtnView.hidden = NO;
                    
                    [self.view addSubview:self.monTableView];
                    _headerView.mh_h = 250;
                    self.monTableView.hidden = NO;
                    [self reqeustDataWithType:1 year:self.year month:self.month];
                }
            };
            btnv;
        })];
        [self.view addSubview:_headerView];
    }
    return _headerView;
}

- (MHVoSeMonStepperButtonView *)monBtnView {
    if (!_monBtnView) {
        _monBtnView = [MHVoSeMonStepperButtonView voSeMonStepperButtonViewWithType:MHVoSeMonStepperButtonViewMonth];
        _monBtnView.hidden = YES;
        
        MHWeakify(self)
        _monBtnView.clickLastBlock = ^(NSInteger year, NSInteger month) {
            MHStrongify(self)
            _year = year;
            _month = month;
            [self reqeustDataWithType:1 year:year month:month];
        };
        
        _monBtnView.clickNextBlock = ^(NSInteger year, NSInteger month) {
            MHStrongify(self)
            _year = year;
            _month = month;
            [self reqeustDataWithType:1 year:year month:month];
        };
        
        [self.headerView addSubview:_monBtnView];
    }
    return _monBtnView;
}

- (UILabel *)alertLab {
    if (!_alertLab) {
        _alertLab = [[UILabel alloc] init];
        _alertLab.frame = CGRectMake(MScreenW /2.0 - 50, MScreenH /2.0 + 50, 100, 20);
        _alertLab.text = @"暂无记录";
        _alertLab.textAlignment = NSTextAlignmentCenter;
    }
    return _alertLab;
}

- (NSMutableArray *)recordsByDayDataSource {
    if (!_recordsByDayDataSource) {
        _recordsByDayDataSource = [NSMutableArray array];
    }
    return _recordsByDayDataSource;
}
@end

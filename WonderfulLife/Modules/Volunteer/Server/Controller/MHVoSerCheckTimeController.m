//
//  MHVolServiceTimeController.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/14.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerCheckTimeController.h"
#import "MHVolSerComDetailController.h"

#import "MHVolCheckTimeHeaderView.h"
#import "MHVolCheckTimeCell.h"
#import "MHVolDateSectionHeaderView.h"
#import "MHVolNoDataSectionFooterView.h"
#import "MHEmptyFooterView.h"
#import "MHRefreshGifHeader.h"
#import "MHVolunteerUserInfo.h"

#import "MHVolunteerDataHandler.h"
#import "MHVolServiceTimeModel.h"

#import "NSObject+isNull.h"
#import "MHHUDManager.h"
#import "UIView+EmptyView.h"
#import "UIViewController+HLNavigation.h"
#import "MHMacros.h"
#import "MJRefresh.h"
#import "NSDate+MHCalendar.h"
@interface MHVoSerCheckTimeController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *noDataView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MHVolServiceTimeModel  *service;

@property (nonatomic, assign) MHVolCheckTimeType VolCheckType;

@property (nonatomic, strong) NSMutableDictionary  *requestDic;

@property (nonatomic, copy)   NSString * requestUrl;

@end

@implementation MHVoSerCheckTimeController



- (instancetype)initWithType:(MHVolCheckTimeType)type{
    self = [super init];
    if (self) {
        self.VolCheckType = type ;
    }
    return self ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
    [self hl_setNavigationItemLineColor:MColorSeparator];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = MColorToRGB(0xF9FAFC) ;

    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    
    MJRefreshAutoNormalFooter * mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(footerRequest)];
    [mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = mj_footer ;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -  Request
- (void)request{
    [MHHUDManager show];
    NSMutableDictionary * dic = self.requestDic ;
    [MHVolunteerDataHandler getVolunteerServiceTimeWithDic:dic url:_requestUrl  success:^(MHVolServiceTimeModel *dataModel) {
        self.service = dataModel ;
        [self resetUI];
    } failure:^(NSString *reemsg){
        [MHHUDManager showErrorText:reemsg];
        [self.tableView.mj_header endRefreshing];
    }];
}


- (void)footerRequest {
    MHVolServiceTimePerMonth *monthModel = [self.service.attendance_records lastObject];
    NSRange yearRange = [monthModel.month rangeOfString:@"年"];
    NSRange mothRange = [monthModel.month rangeOfString:@"月"];
    
    NSString *year = [monthModel.month substringToIndex:4];
    NSString *mothStr = [monthModel.month substringWithRange:NSMakeRange(5, mothRange.location - yearRange.location - 1)];
    NSInteger month = [mothStr integerValue];

    month -- ;
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.requestDic];
    [dic setValue:year forKey:@"year"];
    [dic setValue:[NSNumber numberWithInteger:month] forKey:@"month"];

    [MHHUDManager show];
    [MHVolunteerDataHandler getVolunteerServiceTimeWithDic:dic url:_requestUrl success:^(MHVolServiceTimeModel *dataModel) {
      self.service.query_finished = dataModel.query_finished ;
        if (dataModel.attendance_records.count) {
            [self.service.attendance_records addObjectsFromArray:dataModel.attendance_records];
        }
        [self resetUI];
    } failure:^(NSString *reemsg){
        [MHHUDManager showErrorText:reemsg];
        [self.tableView.mj_header endRefreshing];
    }];
}


- (void)resetUI{
    self.tableView.tableHeaderView = [MHVolCheckTimeHeaderView volCheckTimeHeaderViewWithType:self.VolCheckType hours:[self.service.total_service_time floatValue]];
    [self.tableView reloadData];
    
    if ([self.service.query_finished isEqualToString:@"n"]) { // 尚未到达最后一条
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    if (!self.service.attendance_records.count){
        self.tableView.tableFooterView = [MHEmptyFooterView voSerEmptyViewImageName:@"vo_se_checktime" title:@"暂无服务时长记录"];
    }
    [self.tableView.mj_header endRefreshing];
    [MHHUDManager dismiss];
}

#pragma mark - TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.service.attendance_records.count ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MHVolServiceTimePerMonth * month = self.service.attendance_records [section] ;
    return month.attendance_list.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVolCheckTimeCell *cell = [MHVolCheckTimeCell cellWithTableView:tableView];
    cell.VolCheckType = self.VolCheckType ;
    MHVolServiceTimePerMonth * month = self.service.attendance_records [indexPath.section] ;
    cell.model = month.attendance_list[indexPath.row];
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.service.attendance_records.count) {
        return 48 ;
    }
    return 0.01 ;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    MHVolServiceTimePerMonth * model = self.service.attendance_records [section] ;
    if (!model.attendance_list.count) {
        return 70 ;
    }
    return 0.01 ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MHVolServiceTimePerMonth * month = self.service.attendance_records [indexPath.section] ;
    MHVolServiceTimePerMonthDetail *dayModel = month.attendance_list[indexPath.row];
    
    
    MHVolSerComDetailController *vc = [[MHVolSerComDetailController alloc] init];
    vc.type = MHVolSerComDetailTypeAttendanceDetail ;
    vc.detail_Id = dayModel.attendance_detail_id ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.service.attendance_records.count) {
        MHVolServiceTimePerMonth *model = self.service.attendance_records[section];
        
        MHVolDateSectionHeaderView *header = [MHVolDateSectionHeaderView volDateHeaderViewWithTableView:tableView];
        header.leftTitleLB.text = model.month;
        header.rightTitleLB.text = [NSString stringWithFormat:@"合计：%@小时",[model.current_month_service_time stringValue]];
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MHVolServiceTimePerMonth * model = self.service.attendance_records [section] ;
    if (!model.attendance_list.count) {
        MHVolNoDataSectionFooterView *footer = [MHVolNoDataSectionFooterView volNoDataFooterViewWithTableView:tableView];
        if (![NSObject isNull:model.month]) {
            NSString *month = [model.month substringFromIndex:5];
            footer.noDataLB.text = [NSString stringWithFormat:@"%@无服务时长记录",month];
        }else{
            footer.noDataLB.text = @"无服务时长记录";
        }
        return footer ;
    }
    return nil;
}


#pragma mark - Getter

- (NSMutableDictionary *)requestDic {
    if (!_requestDic) {
      _requestDic  = [NSMutableDictionary dictionary];
        if (self.VolCheckType == MHVolCheckTimeNormal) {
            _requestUrl = @"volunteer/activity/time";
        }else{
            _requestUrl = @"volunteer/my-attendance-record/by-team/list" ;
            [_requestDic setValue:self.idNum forKey:@"id"];
            [_requestDic setValue:self.id_type forKey:@"id_type"];
        }
    }return  _requestDic;
}


@end

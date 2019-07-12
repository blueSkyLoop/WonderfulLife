//
//  MHVoAtReDaySiftController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAtReDaySiftController.h"
#import "MHNavigationControllerManager.h"
#import "MHYMCalendarController.h"

#import "MHVoAttendanceRecordDetailCell.h"
#import "MHVoAtReDaySiftCell.h"
#import "MHAttendanceRecordSectionHeader.h"

#import "MHAttendancenDetailBottomView.h"
#import "UIView+NIM.h"
#import "MHMacros.h"
#import "NSDate+MHCalendar.h"

#import "MHVoAttendanceRecordSiftModel.h"

@interface MHVoAtReDaySiftController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MHAttendancenDetailBottomViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataList;
@end


@implementation MHVoAtReDaySiftController
extern NSString *const MHVoAttendanceRecordDetailRemarksCellID;
extern NSString *const MHAttendanceRecordSectionHeaderID;

static NSString *const MHVoAtReDaySiftCellID = @"MHVoAtReDaySiftCellID";
#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选条件";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self tableView];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 2 ? 3 : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        MHVoAttendanceRecordDetailRemarksCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
        cell.type = MHVoAttendanceRecordDetailCellTypeRegister;
        if (indexPath.section == 0) {
            cell.remarksLabel.text = _siftModel.showDateBegin.length ? _siftModel.showDateBegin : @"请选择";
        }else{
            cell.remarksLabel.text = _siftModel.showDateEnd.length ? _siftModel.showDateEnd : @"请选择";
        }
        return cell;
    }else{
        
        MHVoAtReDaySiftCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoAtReDaySiftCellID forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.model = _siftModel;
        
        return cell;
        
    }
//    <#Model#> *model = self.dataList[indexPath.row];
//    cell.model = model;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return;
    }
    
    MHYMCalendarController *vc = [MHYMCalendarController new];
    NSString *requestFormat = @"yyyy-MM-dd";
    NSString *showFormat = @"yyyy年MM月dd日";
    vc.outputDateFormat = requestFormat;
    vc.inputDateFormat = showFormat ;
    if (indexPath.section == 0) {
        vc.inputDate = _siftModel.showDateBegin;
        vc.calendarTitle = @"开始时间";
    }else if (indexPath.section == 1) {
        vc.inputDate = _siftModel.showDateEnd;
        vc.calendarTitle = @"结束时间";
    }
    vc.block = ^(NSString *dateStr) {
        if (indexPath.section == 0) {
            NSDate *date = [NSDate dateFromStringDate:dateStr format:requestFormat];
            _siftModel.requestDateBegin = dateStr;
            _siftModel.showDateBegin = [date stringFromDateFormat:showFormat];
            
        }else{
            _siftModel.requestDateEnd = dateStr;
            _siftModel.showDateEnd = [[NSDate dateFromStringDate:dateStr format:requestFormat] stringFromDateFormat:showFormat];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHAttendanceRecordSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MHAttendanceRecordSectionHeaderID];
    header.type = MHAttendanceRecordSectionHeaderTypeDetail;
    if (section == 0) {
        header.timeLabel.text = @"开始时间";
    }else if (section == 1) {
        header.timeLabel.text = @"结束时间";
    }else if (section == 2) {
        header.timeLabel.text = @"考勤状态";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 72;
}

#pragma mark - 按钮点击

- (void)dismiss{
    [self clear];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)clear{
    _siftModel.attendance_status = -1;
    _siftModel.showDateBegin = nil;
    _siftModel.showDateEnd = nil;
    _siftModel.requestDateBegin = nil;
    _siftModel.requestDateEnd = nil;
    [self.tableView reloadData];
}

- (void)bottomButtonDidClick{
    !self.beginSift ? : self.beginSift();
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - private
- (void)setupNav{
    self.extendedLayoutIncludesOpaqueBars = YES;
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarWhite];
    nav.navigationBar.shadowImage = [UIImage new];
    
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"清空" forState:UIControlStateNormal];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    confirm.titleLabel.font = font;
    [confirm sizeToFit];
    [confirm setTitleColor:MColorTitle forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - lazy
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-96) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 72;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[MHVoAttendanceRecordDetailRemarksCell class] forCellReuseIdentifier:MHVoAttendanceRecordDetailRemarksCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"MHVoAtReDaySiftCell" bundle:nil] forCellReuseIdentifier:MHVoAtReDaySiftCellID];
        [_tableView registerClass:[MHAttendanceRecordSectionHeader class] forHeaderFooterViewReuseIdentifier:MHAttendanceRecordSectionHeaderID];

        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setupBottomView];
    }
    return _tableView;
}

- (void)setupBottomView{
    MHAttendancenDetailBottomView *bottomView = [MHAttendancenDetailBottomView bottomView];
    [self.view addSubview:bottomView];
    bottomView.type = MHAttendancenDetailBottomViewTypeCheck;
    bottomView.frame = CGRectMake(0, self.view.nim_height - 96, self.view.nim_width, 96);
    bottomView.delegate = self;
}

#ifdef DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif
@end







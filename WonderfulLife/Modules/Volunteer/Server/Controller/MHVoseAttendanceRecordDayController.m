//
//  MHVoseAttendanceRecordDayController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoseAttendanceRecordDayController.h"

#import "MHVoSeAttendanceRecordDayDetailCell.h"
#import "MHVolDateSectionHeaderView.h"

#import "MHHUDManager.h"

#import "MHVoServerRequestDataHandler.h"
#import "MHVolSerAttendanceRecordModel.h"

#import "UIViewController+MHConfigControls.h"
#import "UIView+MHFrame.h"

#import "MHMacros.h"

@interface MHVoseAttendanceRecordDayController ()
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) NSArray<MHVolSerAttendanceRecordDetailByUserModel*> *dataSource;
@end

@implementation MHVoseAttendanceRecordDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *dateArray = [self.date componentsSeparatedByString:@"-"];
    NSString *title = [NSString stringWithFormat:@"%@月%@日", dateArray[1], dateArray[2]];
    [self mh_createTitleLabelWithTitle:title];
    
   [self mh_createTalbeView];
    self.tableView.mh_h -= ({
        self.tableView.mh_y = 150;
    });
    self.tableView.rowHeight = 80;
    
    [self request];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHVoSeAttendanceRecordDayDetailCell *cell = [MHVoSeAttendanceRecordDayDetailCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}
#pragma mark - TableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MHVolDateSectionHeaderView *header = [MHVolDateSectionHeaderView volDateHeaderViewWithTableView:tableView];
        header.leftTitleLB.text = @"队员名单";
        header.leftTitleLB.font = MFont(17);
        header.rightTitleLB.text = @"时长";
        header.rightTitleLB.font = MFont(17);
        return header;
    }
    return nil;
}

#pragma mark - Request
- (void)request {
    [MHHUDManager show];
    [MHVoServerRequestDataHandler getAttendanceRecordByDayListWithTeamId:self.teamId id_type:self.id_type attendance_id:self.attendance_id Success:^(NSArray<MHVolSerAttendanceRecordDetailByUserModel *> *dataSource) {
        [MHHUDManager dismiss];
        _dataSource = dataSource;
        [self.tableView reloadData];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
    }];
}

@end

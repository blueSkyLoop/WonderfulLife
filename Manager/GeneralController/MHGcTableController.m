//
//  MHGcTableController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHGcTableController.h"
#import "MHNavigationControllerManager.h"

#import "MHMacros.h"
#import "UIView+MHFrame.h"
#import "UIView+NIM.h"

#import "MHAttendanceRecordHeader.h"

@interface MHGcTableController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,weak) MHAttendanceRecordHeader *headerView;

@end

@implementation MHGcTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    MHAttendanceRecordHeader *headerView = [[MHAttendanceRecordHeader alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, 64)];
    self.headerView = headerView;
    headerView.title = self.titleStr;
    
    [self.view addSubview:headerView];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : MColorTitle}];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
    [nav navigationBarTranslucent];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell.contentView addSubview:({
            UILabel *lab = [[UILabel alloc] init];
            lab.frame = CGRectMake(24, 72/2 - 20/2, MScreenW - 100, 20);
            lab.textColor = MColorTitle;
            lab.font = MFont(20);
            [lab setTag:9527];
            lab;
        })];
        [cell.contentView addSubview:({
            UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(MScreenW - 30, 72/2 - 12/2, 6, 12)];
            imv.image = [UIImage imageNamed:@"common_right_arrow"];
            imv;
        })];
        cell.separatorInset = UIEdgeInsetsZero;
    }
    UILabel *lab = [cell viewWithTag:9527];
    MHGcTableModel *model = self.dataSource[indexPath.row];
    lab.text = model.team_name;
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    !self.didSelectBlock ?: self.didSelectBlock(self.dataSource[indexPath.row]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.headerView scrollTitleLabelWithScrollView:scrollView];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.headerView scrollTitleLabelWithScrollView:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.headerView scrollTitleLabelWithScrollView:scrollView];
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MScreenW, MScreenH - 64) style:UITableViewStylePlain];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 72;
    }
    return _tableView;
}

@end


@implementation MHGcTableModel
- (void)setCategory_name:(NSString *)category_name{
    _category_name = category_name;
    _team_name = category_name;
}

- (void)setCategory_id:(NSNumber *)category_id{
    _category_id = category_id;
    _team_id = category_id;
}
@end

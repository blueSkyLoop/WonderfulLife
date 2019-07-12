//
//  MHMineMerWithdrawRecordViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawRecordViewController.h"
#import "MJRefresh.h"

#import "MHMineMerWithdrawRecordCell.h"

#import "MHMineMerWithdrawRecordViewModel.h"
#import "MHMineMerWithdrawRecordDelegateModel.h"

#import "MHMineMerWithdrawRecordModel.h"

#import "MHMineMerWithdrawDetailViewController.h"

@interface MHMineMerWithdrawRecordViewController ()

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MHMineMerWithdrawRecordDelegateModel *delegateModel;
@property (nonatomic,strong)MHMineMerWithdrawRecordViewModel *viewModel;

@property (nonatomic,strong)UIView *emptyView;

@end

@implementation MHMineMerWithdrawRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现记录";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNaviBottomLineDefaultColor];
    if(self.viewModel.dataSoure.count == 0){
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)mh_setUpUI{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.widthdrawRecordCommand execute:@(YES)];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.widthdrawRecordCommand execute:@(NO)];
    }];
}
- (void)mh_bindViewModel{
    @weakify(self);
    self.delegateModel = [[MHMineMerWithdrawRecordDelegateModel alloc] initWithDataArr:self.viewModel.dataSoure tableView:self.tableView cellClassNames:@[NSStringFromClass(MHMineMerWithdrawRecordCell.class)] useAutomaticDimension:NO cellDidSelectedBlock:^(NSIndexPath *indexPath, MHMineMerWithdrawRecordModel *cellModel) {
        @strongify(self);
        if(!cellModel.withdraw_no) return ;
        MHMineMerWithdrawDetailViewController *detailVC = [[MHMineMerWithdrawDetailViewController alloc] initWithWithdraw_no:cellModel.withdraw_no];
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
    [self.viewModel.widthdrawRecordCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *has_Next) {
        @strongify(self);
        [self clearEmptyView];
        if(self.viewModel.dataSoure.count == 0){
            [self showEmptyView];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if([has_Next boolValue]){
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [[self.viewModel.widthdrawRecordCommand errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MHHUDManager showWithError:x withView:self.view];
    }];
    
}
- (void)showEmptyView{
    [self clearEmptyView];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)clearEmptyView{
    if(_emptyView){
        [_emptyView removeFromSuperview];
        _emptyView = nil;
    }
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [MHMineMerWithdrawRecordDelegateModel createTableWithStyle:UITableViewStylePlain rigistNibCellNames:@[NSStringFromClass(MHMineMerWithdrawRecordCell.class)] rigistClassCellNames:nil];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = MRGBColor(249, 250, 252);
        
    }
    return _tableView;
}

- (MHMineMerWithdrawRecordViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHMineMerWithdrawRecordViewModel new];
    }
    return _viewModel;
}

-  (UIView *)emptyView{
    if(!_emptyView){
        _emptyView = [LCommonModel emptyViewWithTitleStr:@"暂时没有记录" topSpace:40];
    }
    return _emptyView;
}


@end

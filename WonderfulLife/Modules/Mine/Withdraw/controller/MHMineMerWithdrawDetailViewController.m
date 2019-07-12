//
//  MHMineMerWithdrawDetailViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerWithdrawDetailViewController.h"
#import "MHRefreshGifHeader.h"

#import "MHMineMerWithdrawFinanceRecordCell.h"
#import "MHMineMerWithdrawDetailHeadView.h"

#import "MHMineMerWithdrawDetailViewModel.h"
#import "MHMineMerWithdrawDetailDelegateModel.h"

#import "UITableView+MHAutoHeaderAndFooterView.h"
#import "MHNavigationControllerManager.h"
#import "UINavigationController+MHDirectPop.h"

@interface MHMineMerWithdrawDetailViewController ()<MHNavigationControllerManagerProtocol>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MHMineMerWithdrawDetailDelegateModel *delegateModel;
@property (nonatomic,strong)MHMineMerWithdrawDetailViewModel *viewModel;
@end

@implementation MHMineMerWithdrawDetailViewController

- (id)initWithWithdraw_no:(NSString *)withdraw_no{
    self = [super init];
    if(self){
        self.viewModel.withdraw_no = withdraw_no;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现详情";
    [self resetBackNaviItem];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.viewModel.dataSoure.count == 0){
        [self.tableView.mj_header beginRefreshing];
    }
}

//子类重写此方法
- (void)nav_back{
    [self.navigationController directTopControllerPop];
}

- (BOOL)bb_ShouldBack{
    return NO;
}

- (void)mh_setUpUI{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.widthdrawDetailCommand execute:@(NO)];
    }];
    
}

- (void)loadNewData{
    [self.viewModel.widthdrawDetailCommand execute:@(YES)];
}

- (void)tableHeadViewLoad{
    @weakify(self);
    self.tableView.mh_tableHeader = [MHTableHeaderFooterHander mh_tableHeaderViewWithView:[MHMineMerWithdrawDetailHeadView loadViewFromXib] refresBlock:^(MHMineMerWithdrawDetailHeadView *mhTableHeadFootView) {
        @strongify(self);
        [mhTableHeadFootView configWithData:self.viewModel.detailModel];
    }];
}
- (void)mh_bindViewModel{
    @weakify(self);
    self.delegateModel = [[MHMineMerWithdrawDetailDelegateModel alloc] initWithDataArr:self.viewModel.dataSoure tableView:self.tableView cellClassNames:@[NSStringFromClass(MHMineMerWithdrawFinanceRecordCell.class)] useAutomaticDimension:NO cellDidSelectedBlock:nil];
    [self.viewModel.widthdrawDetailCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *has_Next) {
        @strongify(self);
        if(!self.tableView.mh_tableHeader){
            [self tableHeadViewLoad];
        }
        [self.tableView.mh_tableHeader mh_refreshData];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if([has_Next boolValue]){
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [[self.viewModel.widthdrawDetailCommand errors] subscribeNext:^(NSError * _Nullable x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MHHUDManager showWithError:x withView:self.view];
    }];
    
}
#pragma mark - lazyload
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [MHMineMerWithdrawDetailDelegateModel createTableWithStyle:UITableViewStylePlain rigistNibCellNames:@[NSStringFromClass(MHMineMerWithdrawFinanceRecordCell.class)] rigistClassCellNames:nil];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = MRGBColor(211, 220, 230);

        
    }
    return _tableView;
}

- (MHMineMerWithdrawDetailViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHMineMerWithdrawDetailViewModel new];
    }
    return _viewModel;
}

@end

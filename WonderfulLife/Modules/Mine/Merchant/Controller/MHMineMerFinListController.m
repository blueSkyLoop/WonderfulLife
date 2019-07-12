//
//  MHMineMerFinListController.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerFinListController.h"
#import "MHMineMerFinFilterController.h"

#import "MHMineMerFinModel.h"
#import "MHMineMerFinViewModel.h"
#import "MHMineMerFinDelegateModel.h"

#import "NSObject+isNull.h"
#import "UIViewController+MHConfigControls.h"
#import "UIViewController+HLNavigation.h"
#import "MHWeakStrongDefine.h"
#import "MHMacros.h"

#import "MJRefresh.h"
#import "MHHUDManager.h"
#import "MHMineMerFinListCell.h"
#import "MHEmptyFooterView.h"
#import "MHRefreshGifHeader.h"

@interface MHMineMerFinListController ()
@property (nonatomic,strong)MHMineMerFinDelegateModel *delegateModel;
@property (nonatomic,strong) MHMineMerFinViewModel *viewModel;

@property (nonatomic, strong) UITableView  *tableView;



@end

@implementation MHMineMerFinListController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    
    [self bindViewModel];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self hl_setNavigationItemColor:[UIColor clearColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
}

#pragma mark - SetUI
- (void)setUI{
  UIBarButtonItem*rightBar = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(filterAction)];
    rightBar.tintColor = MColorTitle ;
    self.navigationItem.rightBarButtonItem =rightBar ;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = MColorBackgroud ;
    self.tableView.backgroundColor = self.view.backgroundColor ;
}


#pragma mark - Event
- (void)filterAction { // 筛选
    MHWeakify(self)
    MHMineMerFinFilterController *vc = [[MHMineMerFinFilterController alloc] init];
    vc.filterBlock = ^(NSString *date_Begin, NSString *date_end) {
        MHStrongify(self)
        self.date_begin = date_Begin ;
        self.date_end = date_end ;
//        [self.viewModel.dataSource removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
- (void)bindViewModel {

    MHWeakify(self)
    // 刷新UI
    [self.viewModel.refreshSub subscribeNext:^(id  _Nullable x) {
        MHStrongify(self)
        RACTupleUnpack(MHMineMerFinModel *model,NSNumber * hasNext) = x ;
        [self endRefreshing];
        if ([hasNext boolValue]) {
           [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.delegateModel.headView.model  = model ; // 刷新headerView
        
        if (self.viewModel.dataSource.count == 0) {
            MHEmptyFooterView *footerView = [MHEmptyFooterView voSerEmptyViewImageName:@"vo_se_integral" title:@"暂无积分记录"];
            self.tableView.tableFooterView = footerView;
        }else {
            self.tableView.tableFooterView = nil ;
        }
        [self.tableView reloadData];
    
    }];
    
    // 请求列表数据
    [self.viewModel.serCom.executionSignals.switchToLatest subscribeNext:^(MHMineMerFinModel *model) {
         MHStrongify(self)
        
    }];
    
    // 发生网络错误时，停止刷新状态
    [self.viewModel.serCom.errors subscribeNext:^(NSError *error) {
        [self endRefreshing];
    }];

    [self.tableView.mj_header beginRefreshing];
   
    // 直接把 viewModel.dataSource 绑定在 delegateModel 上，关联到cell上
    self.delegateModel = [[MHMineMerFinDelegateModel alloc] initWithDataArr:self.viewModel.dataSource tableView:self.tableView cellClassNames:@[NSStringFromClass(MHMineMerFinListCell.class)] useAutomaticDimension:NO cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        
    }];

   
}

- (void)request {
    self.viewModel.page = 1 ;
    [self.viewModel.serCom execute:[self getRequestDic]];
}

- (void)footerRequest {
    self.viewModel.page ++ ;
    [self.viewModel.serCom execute:[self getRequestDic]];
}

- (void)endRefreshing {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Lazy
- (MHMineMerFinViewModel *)viewModel {
    if (_viewModel==nil) {
        _viewModel = [MHMineMerFinViewModel new];
    }return _viewModel ;
}


- (NSMutableDictionary *)getRequestDic {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.merchant_id forKey:@"merchant_id"];
    [dic setValue:[NSNumber numberWithInteger:self.viewModel.page] forKey:@"page"];
    if (![NSObject isNull:self.date_begin] && ![NSObject isNull:self.date_end]) {
        [dic setValue:self.date_begin forKey:@"date_begin"];
        [dic setValue:self.date_end forKey:@"date_end"];
    }
    return dic ;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [MHMineMerFinDelegateModel createTableWithStyle:UITableViewStylePlain rigistNibCellNames:@[NSStringFromClass(MHMineMerFinListCell.class)] rigistClassCellNames:nil];
        _tableView.frame = CGRectMake(0, -MTopHight, MScreenW, MScreenH + MTopHight) ;
        MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(request)];
        mjheader.lastUpdatedTimeLabel.hidden = YES;
        mjheader.stateLabel.hidden = YES;
        self.tableView.mj_header = mjheader;
        MJRefreshAutoNormalFooter * mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(footerRequest)];
        [mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = mj_footer ;
        _tableView.rowHeight = UITableViewAutomaticDimension ;
    }return _tableView ;
}

@end

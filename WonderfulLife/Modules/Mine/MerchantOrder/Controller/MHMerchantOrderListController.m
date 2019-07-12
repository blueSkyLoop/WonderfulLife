//
//  MHMerchantOrderListController.m
//  WonderfulLife
//
//  Created by zz on 24/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderListController.h"
#import "MHMerchantOrderDetailController.h"
#import "MHMerchantOrderqrCodeController.h"

#import "ReactiveObjC.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "MHMacros.h"

#import "MHMerchantOrderListCell.h"
#import "MHRefreshGifHeader.h"

#import "MHMerchantOrderModel.h"
#import "MHHUDManager.h"
#import "MHAlertView.h"

#import "UIView+EmptyView.h"

@interface MHMerchantOrderListController ()<UITableViewDataSource,UITableViewDelegate,MHMerchantListOrderCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) MHMerchantOrderViewModel *viewModel;
@property (nonatomic, strong) UIView *emptyView;
@end

@implementation MHMerchantOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    _dataSource = @[].mutableCopy;
    _currentPage = 1;
    
    self.viewModel.type = self.type;
    [self.viewModel registerCommand]; //提前注册command
    [self addNotificationCenter];
    [self registerNib];
    
    UIPanGestureRecognizer *edgePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pageLayoutSwitch:)];
    [self.view addGestureRecognizer:edgePanGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self pullDataSource];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView reloadData];
}

- (void)pageLayoutSwitch:(UIPanGestureRecognizer*)gesture{
    if ([self.panDelegate respondsToSelector:@selector(MHMerchantOrderListPanGestureEvent:)]) {
        [self.panDelegate MHMerchantOrderListPanGestureEvent:gesture];
    }
}

- (void)addNotificationCenter {
    
    @weakify(self);
    [self.viewModel.pullListCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable output) {
        @strongify(self)

        RACTupleUnpack(NSNumber *issuccess,NSNumber *has_next,id data) = output;
        
        if ([has_next boolValue]) {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [MHHUDManager dismiss];
        if (![issuccess boolValue]) {
            //处理上拉刷新的时候，加载失败时，保留之前的数据，提示加载失败。显示空数据提示，只有_currentPage == 1时的数据加载，才显示。
            if (_currentPage==1) {
                [self.tableView mh_removeEmptyView];
                [self.tableView mh_addEmptyViewImageName:@"merchant_list_no_data" title:@"暂无订单"];
                [self.tableView mh_setEmptyCenterYOffset:-120];
                [self.dataSource removeAllObjects];
                [self.tableView reloadData];
            }else {
                [self.tableView mh_removeEmptyView];
            }

            [MHHUDManager showErrorText:data];
        }else {// 成功
            NSArray *dataArray = data;

            if (dataArray.count == 0&&_currentPage==1) {
                [self.tableView mh_addEmptyViewImageName:@"merchant_list_no_data" title:@"暂无订单"];
                [self.tableView mh_setEmptyCenterYOffset:-120];
            }else {
                [self.tableView mh_removeEmptyView];
            }
            
            if (_currentPage==1) {// 刷新
                [self.dataSource  removeAllObjects];
                [self.tableView.mj_header endRefreshing];
                [self.dataSource addObjectsFromArray:dataArray];
                [self.tableView reloadData];
                
            }else {// 加载更多
                // tableView 更新数据
                NSMutableArray<NSIndexPath*>* indexPaths = [NSMutableArray array];
                for (int i = 0; i < dataArray.count; i++) {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataSource.count+i inSection:0];
                    [indexPaths addObject:indexPath];
                }
                
                [self.dataSource addObjectsFromArray:dataArray];
                
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }}
    }];
    
    [self.viewModel.deleteOrderCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        RACTupleUnpack(NSNumber *issuccess,id data) = x;
        
        if (![issuccess boolValue]) {
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:data];
        }else {// 成功
            [MHHUDManager dismiss];
            // tableView 更新数据
            NSInteger deleteRow = [data integerValue];
            [self.tableView beginUpdates];
            [self.dataSource removeObjectAtIndex:deleteRow];
            NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:deleteRow inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }];
}

- (void)registerNib{
    
    //列表
    [self.tableView registerNib:[UINib nibWithNibName:@"MHMerchantOrderListCell" bundle:nil] forCellReuseIdentifier:@"MHMerchantOrderListCell"];
    
    MHRefreshGifHeader *mjheader = [MHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mjheader.lastUpdatedTimeLabel.hidden = YES;
    mjheader.stateLabel.hidden = YES;
    self.tableView.mj_header = mjheader;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage = self.dataSource.count/10 + 1;
        [self pullDataSource];
    }];
}

- (void)loadNewData {
    _currentPage = 1;
    [self pullDataSource];
}

- (void)pullDataSource {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.type != MHMerchantOrderTypeRefundDoing) {
        params[@"order_status"] = @(self.viewControllerId - 1);
        if (self.viewControllerId - 1 == 4) {
            params[@"order_status"] = @(99);
        }
        if (_merchant_id) {
            params[@"merchant_id"] = self.merchant_id;
        }
    }else {
        params[@"refund_type"] = @(self.viewControllerId - 1);
    }
    params[@"page"] = @(self.currentPage);
 
    [self.viewModel.pullListCommand execute:params];
}

- (void)refreshWithTag:(NSInteger)tag {
    [self pullDataSource];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MHMerchantOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MHMerchantOrderListCell"];
    cell.delegate = self;
    if (self.type != MHMerchantOrderTypeNormal) {
        cell.isMerchantList = YES;
    }else {
        cell.isMerchantList = NO;
    }
    [cell mh_configCellWithInfor:self.dataSource[indexPath.row]];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 257.f;
}

#pragma mark - Cell Delegate
- (void)mh_merchantListOrderCell:(UITableViewCell*)cell didSelectRow:(MHMerchantOrderModel*)data{
    MHMerchantOrderDetailController *controller = [MHMerchantOrderDetailController new];
    controller.order_no = data.order_no;
    switch (self.type) {
        case MHMerchantOrderTypeNormal:
            controller.controlType = MHMerchantOrderDetailControlTypeCustomer;
            break;
        case MHMerchantOrderTypeRefundDoing:
            controller.controlType = MHMerchantOrderDetailControlTypeRefund;
            break;
        case MHMerchantOrderTypeManager:
            controller.controlType = MHMerchantOrderDetailControlTypeMerchant;
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

//支付
- (void)mh_merchantListOrderCell:(UITableViewCell *)cell didSelectRowToPaid:(MHMerchantOrderModel*)data {
    MHMerchantOrderDetailController *controller = [MHMerchantOrderDetailController new];
    controller.order_no = data.order_no;
    [self.navigationController pushViewController:controller animated:YES];
}

//二维码界面
- (void)mh_merchantListOrderCell:(UITableViewCell *)cell didSelectToQRCode:(MHMerchantOrderModel*)data {
    MHMerchantOrderqrCodeController *controller = [MHMerchantOrderqrCodeController new];
    controller.qrcodeUrl = data.qr_code;
    controller.order_no = data.order_no;
    [self.navigationController pushViewController:controller animated:YES];
}

//删除订单
- (void)mh_merchantListOrderCell:(UITableViewCell*)cell didSelectDeleteButton:(MHMerchantOrderModel*)data {
    @weakify(self)
    [[MHAlertView sharedInstance]showNormalTitleAlertViewWithTitle:@"确定删除该订单？" leftHandler:^{
        [[MHAlertView sharedInstance]dismiss];
    } rightHandler:^{
        @strongify(self)
        [[MHAlertView sharedInstance]dismiss];
        NSInteger idx = [self.dataSource indexOfObject:data];
        [MHHUDManager show];
        if (self.type == MHMerchantOrderTypeRefundDoing) {
            [self.viewModel.deleteOrderCommand execute:@[data.refund_id,@(idx)]];
        }else if (self.merchant_id) {
            [self.viewModel.deleteOrderCommand execute:@[data.order_no,@(idx),self.merchant_id]];
        }else {
            [self.viewModel.deleteOrderCommand execute:@[data.order_no,@(idx)]];
        }
    } rightButtonColor:nil];
}

#pragma mark - Getter
- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MColorDidSelectCell;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (MHMerchantOrderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [MHMerchantOrderViewModel new];
    }
    return _viewModel;
}
@end

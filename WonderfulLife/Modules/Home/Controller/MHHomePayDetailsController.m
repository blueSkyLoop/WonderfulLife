//
//  MHHomePayDetailsController.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayDetailsController.h"
#import "MHNavigationControllerManager.h"
#import "MHHomePayChooseController.h"

#import "MHMacros.h"
#import "MHConst.h"
#import "MHHUDManager.h"
#import "MHHomeRequest.h"
#import "MHWeakStrongDefine.h"
#import "UIViewController+MHConfigControls.h"

#import "MHHoPayDetailsModel.h"
#import "MHUnpayModel.h"
#import "MHHoPayExpensesModel.h"

#import "MHHomePayDetailsHeaderView.h"
#import "MHHomePaySectionHeaderView.h"
#import "MHHomePayDetailsFooterView.h"
#import "MHHomePayDetailsCell.h"
#import "MHHomePayBottomView.h"

#import "MHPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YYModel.h"

#import "UIViewController+HLNavigation.h"

#import "UITableView+MHAutoHeaderAndFooterView.h"


static NSString *payDetailsCellID = @"payDetailsCell";

@interface MHHomePayDetailsController () <UITableViewDataSource, UITableViewDelegate>
/**
 *  tableView
 */
@property (weak,nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) MHHomePayBottomView *bottomView;

@property (nonatomic,strong) MHUnpayModel *unpayModel;
@property (nonatomic,strong) MHHoPayDetailsModel *paidModel;

@property (nonatomic,copy) void (^paySuccessBlock)();

@property (nonatomic,assign)BOOL payFlag;

@end

@implementation MHHomePayDetailsController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
    [self hl_setNavigationItemLineColor:[UIColor whiteColor]];
    if(self.payFlag){
        self.payFlag = NO;
        self.paySuccessBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化界面
    [self setupUI];
    
    // 加载待缴费用数据
//    [self loadPayDetailsData];
    if (self.payControllerType == MHHomePayControllerTypePay) {
        [self loadNeedPayData];
    }else{
        [self loadPayDetailsData];
    }
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kStoreOrderPaySuccessNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if(x.object && [x.object isEqualToString:self.property_id] && self.payControllerType == MHHomePayControllerTypePay){
            self.payFlag = YES;
        }
    }];
}


#pragma mark - 加载数据
/**
 加载账单明细数据
 */
- (void)loadNeedPayData {
    [MHHUDManager show];
    [MHHomeRequest postpropertyfeeUnpayDetailWithPropertyID:self.property_id FeeDate:self.fee_date Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        if (success) {
            self.unpayModel = [MHUnpayModel yy_modelWithJSON:data];
            self.bottomView.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.unpayModel.sum];
            [self.tableView reloadData];
        }else{
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}

#define MHPaid_paymentAmount(paymentAmount) [NSString stringWithFormat:@"缴费金额:¥%@",paymentAmount]
#define MHPaid_scoreDeduction(scoreDeduction) [NSString stringWithFormat:@"积分抵扣:¥%@",scoreDeduction]
#define MHPaid_actualPayment(actualPayment) [NSString stringWithFormat:@"实际支付:¥%@",actualPayment]
#define MHPaid_type(type) [NSString stringWithFormat:@"支付方式:%@",type]
#define MHPaid_datetime(datetime) [NSString stringWithFormat:@"支付时间:%@",datetime]

/**
 加载已缴费详情数据
 */
- (void)loadPayDetailsData {
    [MHHUDManager show];
    MHWeakify(self)
    [MHHomeRequest loadHoPayDetailsListWithPropertyID:self.property_id FeeMonth:self.fee_date Callback:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        [MHHUDManager dismiss];
        MHStrongify(self)
        if (success) {
            self.paidModel = [MHHoPayDetailsModel yy_modelWithJSON:data];
            [self.tableView.mh_tableFooter mh_refreshData];
            [self.tableView reloadData];

        }else {
            [MHHUDManager showErrorText:errmsg];
        }
    }];
}


#pragma mark - 设置界面
- (void)setupUI {
    // 0. 自动下滑
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // 1. 注册cell
    UINib *nib = [UINib nibWithNibName:@"MHHomePayDetailsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:payDetailsCellID];
    
    // 2. 设置tableView头部视图
    MHHomePayDetailsHeaderView *headerView = [MHHomePayDetailsHeaderView loadHomePayDetailsHeaderView];
    headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80);
    
    if (self.payControllerType == MHHomePayControllerTypeDetails) {
        headerView.titleLabel.text = @"缴费详情";
    } else {
        headerView.titleLabel.text = @"账单明细";
    }
    
    self.tableView.tableHeaderView = headerView;
    
    // 3. 设置tableView属性
    self.tableView.estimatedRowHeight = 83;
    self.tableView.sectionFooterHeight = 0;
    
    // 4. 设置底部工具栏
    if (self.payControllerType == MHHomePayControllerTypePay) {
        MHWeakify(self);
        MHHomePayBottomView *bottomView = [MHHomePayBottomView loadHomePayBottomView];
        // MARK: 设置总结金额
        self.bottomView = bottomView;
        bottomView.priceLabel.text = [NSString stringWithFormat:@"￥%@", @"0.00"];
        [bottomView.payButton setTitle:@"缴费" forState:UIControlStateNormal];
        
        // MARK: 跳转到支付界面
        bottomView.payHandler = ^{
            MHStrongify(self)
            // 创建选择支付控制器

            MHStoreGoodPayModel *payModel = [MHStoreGoodPayModel new];
            payModel.type = mhPay_property_pay;
            payModel.totalScore = self.unpayModel.sum;
            payModel.payTypeStr = self.unpayModel.property_id.stringValue;
            payModel.payData = [@[self.fee_date] yy_modelToJSONString];
            payModel.noticeObject = self.property_id;
            MHHomePayChooseController *payChooseVc = [[MHHomePayChooseController alloc] initWithPayModel:payModel];
            
            [self.navigationController pushViewController:payChooseVc animated:YES];
        };

        bottomView.frame = CGRectMake(0, MScreenH - 144, MScreenW, 80);
        [self.view addSubview:bottomView];
        
        
        self.tableView.tableFooterView = [UIView new];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
        
    } else {
        @weakify(self);
        self.tableView.mh_tableFooter = [MHTableHeaderFooterHander mh_tableFooterViewWithView:[MHHomePayDetailsFooterView loadPayDetailsFooterView] refresBlock:^(MHHomePayDetailsFooterView *mhTableHeadFootView) {
            @strongify(self);
            mhTableHeadFootView.timeLabel.text = MHPaid_datetime(self.paidModel.pay_datetime);
            mhTableHeadFootView.typeLabel.text = MHPaid_type(self.paidModel.pay_way);
            mhTableHeadFootView.scoreDeductionLabel.text = MHPaid_scoreDeduction(self.paidModel.pay_score);
            mhTableHeadFootView.paymentAmountLabel.text =  MHPaid_paymentAmount(self.paidModel.total_money);
            mhTableHeadFootView.actualPaymentLabel.text = MHPaid_actualPayment(self.paidModel.actual_pay_money);
        }];
        
    }
    
    if (self.payControllerType == MHHomePayControllerTypePay) {
        MHWeakify(self);
        [self setPaySuccessBlock:^{
            MHStrongify(self);
            self.payControllerType = MHHomePayControllerTypeDetails;
            [self.bottomView removeFromSuperview];
            self.tableView.mh_tableFooter = [MHTableHeaderFooterHander mh_tableFooterViewWithView:[MHHomePayDetailsFooterView loadPayDetailsFooterView] refresBlock:^(MHHomePayDetailsFooterView *mhTableHeadFootView) {
                mhTableHeadFootView.timeLabel.text = MHPaid_datetime(self.paidModel.pay_datetime);
                mhTableHeadFootView.typeLabel.text = MHPaid_type(self.paidModel.pay_way);
                mhTableHeadFootView.scoreDeductionLabel.text = MHPaid_scoreDeduction(self.paidModel.pay_score);
                mhTableHeadFootView.paymentAmountLabel.text =  MHPaid_paymentAmount(self.paidModel.total_money);
                mhTableHeadFootView.actualPaymentLabel.text = MHPaid_actualPayment(self.paidModel.actual_pay_money);
            }];
            headerView.titleLabel.text = @"账单明细";
            [self loadPayDetailsData];
        }];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.payControllerType == MHHomePayControllerTypePay) {
        return self.unpayModel.list.count;
    }else{
        return self.paidModel.list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 获取cell
    MHHomePayDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:payDetailsCellID forIndexPath:indexPath];
    
    // 2. 传递模型
    if (self.payControllerType == MHHomePayControllerTypePay) {
        MHUnpaySubjectModel *model = self.unpayModel.list[indexPath.row];
        cell.unpayModel = model;
    }else{
        MHHoPayExpensesModel *model = self.paidModel.list[indexPath.row];
        cell.paidModel = model;
    }
    
    // 3. 返回
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MHHomePaySectionHeaderView *headerView = [MHHomePaySectionHeaderView loadPaySectionHeaderView];
    headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 48);
    // 缴费月份
    NSString *date = [self.fee_date stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    date = [date stringByAppendingString:@"月"];
    headerView.timeLabel.text = date;
    return headerView;
}


#pragma mark - 懒加载

#if DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif
@end

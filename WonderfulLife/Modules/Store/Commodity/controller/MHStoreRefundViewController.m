//
//  MHStoreRefundViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRefundViewController.h"

#import "MHStoreRefundReasonCell.h"
#import "MHStoreRefundOrderInforCell.h"
#import "MHStoreRefundRemarkCell.h"
#import "MHStoreRefundHeaderView.h"

#import "MHThemeButton.h"
#import "MHConst.h"

#import "MHStoreRefundDelegateModel.h"
#import "MHStoreRefundViewModel.h"
#import "MHStoreRefundReasonModel.h"

#import "MHNavigationControllerManager.h"
#import "MHMerchantOrderqrCodeController.h"
#import "UIViewController+PresentLoginController.h"


@interface MHStoreRefundViewController ()<MHNavigationControllerManagerProtocol>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *tableFootView;
@property (nonatomic,strong)MHThemeButton *submitBtn;

@property (nonatomic,strong)MHStoreRefundDelegateModel *delegateModel;
@property (nonatomic,strong)MHStoreRefundViewModel *viewModel;

@end

@implementation MHStoreRefundViewController

- (id)initWithOrderDetailModel:(MHMerchantOrderDetailModel *)orderDetailModel{
    self = [super init];
    if(self){
        self.orderDetailModel = orderDetailModel;
    }
    return self;
}

-  (void)setOrderDetailModel:(MHMerchantOrderDetailModel *)orderDetailModel{
    if(_orderDetailModel != orderDetailModel){
        _orderDetailModel = orderDetailModel;
        self.viewModel.detailModel = _orderDetailModel;
        self.viewModel.order_no = _orderDetailModel.order_no;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请退款";
    
    [self resetBackNaviItem];
}

//子类重写此方法
- (void)nav_back{
    
    if(self.viewModel.isChanged){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleAlert];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"确定放弃当前操作？" attributes:@{NSFontAttributeName:MFont(14),NSForegroundColorAttributeName:MRGBColor(153, 169, 191)}];
        [alert setValue:attr forKey:@"attributedMessage"];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action1];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        if([UIDevice currentDevice].systemVersion.floatValue >= 8.2){
            [action1 setValue:MColorTitle forKey:@"titleTextColor"];
            [action2 setValue:MColorTitle forKey:@"titleTextColor"];
        }
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//右滑手势禁止代理
- (BOOL)bb_ShouldBack{
    return NO;
}

- (void)mh_setUpUI{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setImage:[UIImage imageNamed:@"merchantOrderDetail_QR"] forState:UIControlStateNormal];
    [confirm sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    @weakify(self);
    [[confirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        MHMerchantOrderqrCodeController *controller = [MHMerchantOrderqrCodeController new];
        controller.qrcodeUrl = self.orderDetailModel.qr_code;
        controller.order_no = self.orderDetailModel.order_no;
        [self.navigationController pushViewController:controller animated:YES];
    }];
}
- (void)mh_bindViewModel{
    @weakify(self);
    [self.viewModel.refundReasonListCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.submitBtn.enabled = YES;
        [self.tableView reloadData];
    }];
    [[self.viewModel.refundReasonListCommand errors] subscribeNext:^(NSError *x) {
        @strongify(self);
        self.submitBtn.enabled = NO;
        [MHHUDManager showWithError:x withView:self.view];
    }];
    
    [self.viewModel.appleRefundCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:kStoreRefundSuccessNotification object:self.viewModel.order_no];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [[self.viewModel.appleRefundCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if(error.code == -4){//要重新登录
            [self presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.view];
        }
    }];
    
    self.delegateModel = [[MHStoreRefundDelegateModel alloc] initWithDataArr:self.viewModel.dataSoure tableView:self.tableView cellClassNames:@[NSStringFromClass(MHStoreRefundOrderInforCell.class),NSStringFromClass(MHStoreRefundReasonCell.class),NSStringFromClass(MHStoreRefundRemarkCell.class)] useAutomaticDimension:YES cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        if(indexPath.section == 1){
            @strongify(self);
            MHStoreRefundReasonModel *amodel = (MHStoreRefundReasonModel *)cellModel;
            amodel.selected = !amodel.isSelected;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    
    [self.viewModel.refundReasonListCommand execute:nil];
    
}

//提交时的处理
- (void)handleSubmitRefund{
    NSArray *arr = self.viewModel.selectReaseArr;
    NSString *remark = self.viewModel.reamrk;
    if(!arr || arr.count == 0){
        [MHHUDManager showErrorText:@"请选择至少一项退款理由"];
    }else if(!remark || remark.length == 0){
        [MHHUDManager showErrorText:@"请输入退款说明"];
    }else{
        remark = [remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(remark.length == 0){
            [MHHUDManager showErrorText:@"退款说明不能为空白"];
            return;
        }
        //可以提交信息,申请退款
        [self.viewModel.appleRefundCommand execute:nil];
    }
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [MHStoreRefundDelegateModel createTableWithStyle:UITableViewStyleGrouped rigistNibCellNames:@[NSStringFromClass(MHStoreRefundOrderInforCell.class),NSStringFromClass(MHStoreRefundReasonCell.class),NSStringFromClass(MHStoreRefundRemarkCell.class)] rigistClassCellNames:nil];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MScreenW, 0.001)];
        headView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = headView;
        _tableView.tableFooterView = self.tableFootView;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:MHStoreRefundHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(MHStoreRefundHeaderView.class)];
    }
    return _tableView;
}

- (UIView *)tableFootView{
    if(!_tableFootView){
        _tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, 108)];
        _tableFootView.backgroundColor = MColorBackgroud;
        [_tableFootView addSubview:self.submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(28, 28, 28, 28)).priorityHigh();
        }];
    }
    return _tableFootView;
}

- (MHThemeButton *)submitBtn{
    if(!_submitBtn){
        _submitBtn = [[MHThemeButton alloc] initWithFrame:CGRectMake(0, MScreenH - 60, MScreenW, 56)];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
            _submitBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 18 weight:UIFontWeightMedium];
        }else{
            _submitBtn.titleLabel.font = [UIFont systemFontOfSize:MScale * 18];
        }
        [_submitBtn setTitle:@"退 款" forState:UIControlStateNormal];
        _submitBtn.layer.cornerRadius = 2;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.enabled = NO;
        @weakify(self);
        [[[_submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.view endEditing:YES];
            [self handleSubmitRefund];
        }];
    }
    return _submitBtn;
}

- (MHStoreRefundViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHStoreRefundViewModel new];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

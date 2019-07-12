//
//  MHStoreOrderSubmitViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreOrderSubmitViewController.h"
#import "MHUserInfoManager.h"

#import "MHStoreGoodsSubmitDetailView.h"

#import "MHHomePayChooseController.h"

#import "MHStoreOrderSumitViewModel.h"

#import "UINavigationController+MHDirectPop.h"
#import "UIViewController+PresentLoginController.h"

@interface MHStoreOrderSubmitViewController ()

@property (nonatomic,strong)MHStoreOrderSumitViewModel *viewModel;

@property (nonatomic,strong)MHStoreGoodsSubmitDetailView *submitView;
@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation MHStoreOrderSubmitViewController


- (id)initWithGoodsDetailModel:(MHStoreGoodsDetailModel *)detailModel{
    self = [super init];
    if(self){
        self.viewModel.coupon_id = detailModel.coupon_id;
        self.viewModel.detailModel = detailModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)mh_setUpUI{
    [self.scrollView addSubview:self.submitView];
    [self.view addSubview:self.scrollView];
    
    [_submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollView);
        make.bottom.lessThanOrEqualTo(self.scrollView.mas_bottom);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.greaterThanOrEqualTo(@(MScreenH - MTopHight));
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)mh_bindViewModel{
    @weakify(self);
    //查询商品库存(暂时未开发)
    [self.viewModel.goodsQueryCommand.executionSignals.switchToLatest subscribeNext:^(MHStoreGoodsOrderDetailModel *model) {
        @strongify(self);
        [self.submitView configWithModel:self.viewModel.detailModel];
    }];
    [[self.viewModel.goodsQueryCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        [MHHUDManager showWithError:error withView:self.view];
    }];
    
    //提交订单
    [self.viewModel.goodsSubmitCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *orderNoList) {
        @strongify(self);
        NSString *data = [orderNoList componentsJoinedByString:@","];
        if(!data) return ;
        MHStoreGoodPayModel *payModel = [MHStoreGoodPayModel new];
        payModel.type = mhPay_coupon_pay;
        payModel.totalScore = self.viewModel.detailModel.totalPriceStr;
        payModel.payTypeStr = @"coupon-order";
        payModel.payData = data;
        payModel.noticeObject = [NSString stringWithFormat:@"%ld",self.viewModel.coupon_id];
        MHHomePayChooseController *orderPayVC = [[MHHomePayChooseController alloc] initWithPayModel:payModel];
        //生成订单号之后，从支付界面返回就是回到详情里了,或者在待支付订单列表返回也是回到商品详情
        [self.navigationController saveDirectViewControllerName:@"MHStoreGoodsDetailViewController"];
        [self.navigationController pushViewController:orderPayVC animated:YES];
    }];
    [[self.viewModel.goodsSubmitCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if(error.code == -4){//要重新登录
            [self presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.view];
        }
    }];
    
    [[[self.submitView.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.view endEditing:YES];
        //判断登录
        BOOL isLogin = [MHUserInfoManager sharedManager].isLogin;
        if (!isLogin) {
            [self presentLoginController];
            return ;
        }
        
        //生成订单号
        [self.viewModel.goodsSubmitCommand execute:nil];
    }];
    
    [self.submitView configWithModel:self.viewModel.detailModel];
}

#pragma mark - lazyload
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}
- (MHStoreGoodsSubmitDetailView *)submitView{
    if(!_submitView){
        _submitView = [MHStoreGoodsSubmitDetailView loadViewFromXib];
    }
    return _submitView;
}

- (MHStoreOrderSumitViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHStoreOrderSumitViewModel new];
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

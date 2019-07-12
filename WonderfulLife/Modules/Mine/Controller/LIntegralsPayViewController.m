//
//  LIntegralsPayViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LIntegralsPayViewController.h"
#import "LPayAlertView.h"
#import "LIntegralsPayDetailView.h"
#import "LIntegralsComplePayView.h"
#import "LIntgralsPayViewModel.h"
#import "LIntegralsGoodsModel.h"
#import "YYModel.h"
#import "LFindPasswordViewController.h"
#import "LSetNewPasswordViewController.h"
#import "LIntegralsPayFailureView.h"
#import "MHVoSerIntegralDetailsController.h"
#import "UINavigationController+MHDirectPop.h"
#import "MHIntegralsPayAlertView.h"
#import "UIViewController+PresentLoginController.h"
#import "MHUserInfoManager.h"
#import "MHPasswordCompleViewController.h"
#import "UIViewController+MHBackToRoot.h"

#import "MHStorePayViewModel.h"

static NSInteger const not_volunteerCode = 2001;//不是志愿者
static NSInteger const not_setPassword = 2002;//没有设置支付密码
static NSInteger const integralsLess = 2003;//积分不足
static NSInteger const passwordError = 2004;//支付密码错误

@interface LIntegralsPayViewController ()

@property (nonatomic,strong)LPayAlertView *payAlertView;
@property (nonatomic,strong)LIntegralsPayDetailView *payDetailView;
@property (nonatomic,strong)LIntegralsComplePayView *payCompleView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)LIntgralsPayViewModel *viewModel;
@property (nonatomic,strong)LIntegralsPayFailureView *payFailureView;

@property (nonatomic,strong)MHStorePayViewModel *checkViewModel;

@property (nonatomic,assign)BOOL paySuccess;


@end

@implementation LIntegralsPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分支付";
    [self resetBackNaviItem];
    [self.view addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.paySuccess = NO;

    
    [self bindSignal];
}
//返回
- (void)nav_back{
    if(_payFailureView){
//        [self backToHome];
        UIViewController *controller = [self.navigationController frontControllerWithControllerName:@"MHQRCodeController"];
        if(controller){
            [self.navigationController popToViewController:controller animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController directTopControllerPop];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.showPayAlert){
        self.showPayAlert = NO;
        if(_payDetailView){
            [self.payDetailView.paySubject sendNext:nil];
        }
    }
    
}

#pragma mark 右滑手势禁止
- (BOOL)bb_ShouldBack{
    return !self.paySuccess;
}

- (void)setPaySuccess:(BOOL)paySuccess{
    _paySuccess = paySuccess;
    if(_paySuccess){
        [self setUpPayCompleView];
        
    }else{
        [self setUpPayView];
    }
}

- (void)setGoodsInfor:(id)goodsInfor{
    if(_goodsInfor != goodsInfor){
        self.paySuccess = NO;
        _goodsInfor = goodsInfor;
        LIntegralsGoodsModel *model = [LIntegralsGoodsModel yy_modelWithDictionary:goodsInfor];
        self.viewModel.goodsModel = model;
        if(_payDetailView){
            [_payDetailView configWithInfor:model];
        }
        
    }
}

#pragma mark 设置密码
- (void)setPassword{
    LSetNewPasswordViewController *setPasswordVC = [[LSetNewPasswordViewController alloc] initWithSetType:PayPassword_set];
    setPasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
    [self.navigationController pushViewController:setPasswordVC animated:YES];
}

- (void)bindSignal{

    @weakify(self);
    [self.viewModel.payCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        @strongify(self);
        NSInteger result_code = [dict[@"result_code"] integerValue];
        if(result_code == 0){//支付成功
             [self hiddenPasswordAlert];
            //支付成功
            self.paySuccess = YES;
            [self.payCompleView configWithInfor:self.viewModel.goodsModel];
        }else{
            //处理支付结果
            [self handlePayErrorWithCode:result_code];
        }
        
    }];
    [[self.viewModel.payCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        NSInteger code = [error.userInfo[@"code"] integerValue];
        if(code != passwordError){
            [self hiddenPasswordAlert];
        }
        if(code == -4){
            [self presentLoginController];
            return ;
        }
        [self handlePayErrorWithCode:code];
    }];
    
    //0为全部校验成功,2001表示用户不是志愿者,2002表示未设置支付密码,2003表示积分不足
    [self.checkViewModel.goodsBuyCheckCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        @strongify(self);
        NSInteger result_code = [dict[@"result_code"] integerValue];
        NSString *result_msg = dict[@"result_msg"];
        if(result_code == 0){
            [self hiddenPasswordAlert];
            //校验完成，直接弹起支付
            [self.payAlertView show];
        }else if(result_code == not_volunteerCode || result_code == not_setPassword || result_code == integralsLess){
            //处理校验结果
            [self handlePayErrorWithCode:result_code ];
        }else{
            [MHHUDManager showErrorText:result_msg];
        }
    }];
    [[self.checkViewModel.goodsBuyCheckCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if(error.code == -4){//要重新登录
            [self presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.view];
        }
    }];
    
}

#pragma mark - Private
- (void)hiddenPasswordAlert{
    if(_payAlertView && _payAlertView.superview){
        [_payAlertView removeFromSuperview];
    }
    _payAlertView = nil;
}

- (void)handlePayErrorWithCode:(NSInteger)code{
    if(code == integralsLess){//积分余额不足
        [self hiddenPasswordAlert];
        MHPasswordCompleViewController *vc = [[MHPasswordCompleViewController alloc] initWithAlertType:MHAlertShow_integralsLess];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(code == not_volunteerCode){//非志愿者
        [self hiddenPasswordAlert];
        MHPasswordCompleViewController *vc = [[MHPasswordCompleViewController alloc] initWithAlertType:MHAlertShow_notVolunteer];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(code == passwordError){
        [MHHUDManager showText:@"密码错误，支付失败" Complete:^{
            [self.payAlertView.inputBgView clearInput];
            [self.payAlertView.inputBgView makeFirstResponderIndex:0];
        }];
        
    }else{//支付失败
        [self hiddenPasswordAlert];
        [self setUpFailureView];
    }
    
}

- (void)setUpPayView{
    if(_payCompleView){
        [_payCompleView removeFromSuperview];
        _payCompleView = nil;
    }
    if(_payFailureView){
        [_payFailureView removeFromSuperview];
        _payFailureView = nil;
    }

    if(_payDetailView){
        [_payDetailView removeFromSuperview];
        _payDetailView = nil;
    }
    if(!_payDetailView){
        [self.scrollView addSubview:self.payDetailView];
        [_payDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.equalTo(_scrollView.mas_width);
            make.height.greaterThanOrEqualTo(@(MScreenH - MTopHight));
        }];
    }
    

    @weakify(self);
    [[self.payDetailView.paySubject throttle:0.3] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self.checkViewModel.goodsBuyCheckCommand execute:self.viewModel.goodsModel.score_need_pay];
        
    }];

    
    
}
- (void)setUpPayCompleView{
    if(_payDetailView){
        [_payDetailView removeFromSuperview];
        _payDetailView = nil;
    }
    if(_payFailureView){
        [_payFailureView removeFromSuperview];
        _payFailureView = nil;
    }

    if(_payCompleView){
        [_payCompleView removeFromSuperview];
        _payCompleView = nil;
    }

    if(!_payCompleView){
        [self.scrollView addSubview:self.payCompleView];
        [_payCompleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.equalTo(_scrollView.mas_width);
            make.height.greaterThanOrEqualTo(@(MScreenH - MTopHight));
        }];
    }
    

    @weakify(self);
    [[self.payCompleView.payCompleSubject throttle:0.2] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //跳转到积分明细
        MHVoSerIntegralDetailsController *vc = [[MHVoSerIntegralDetailsController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)setUpFailureView{
    [self.scrollView addSubview:self.payFailureView];
    [_payFailureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView.mas_width);
        make.height.greaterThanOrEqualTo(@(MScreenH - MTopHight));
    }];

    @weakify(self);
    [self.payFailureView.failureSubject subscribeNext:^(NSNumber  *typeNum) {
        @strongify(self);
        [self.payFailureView removeFromSuperview];
        self.payFailureView = nil;
        //继续支付
        if(typeNum.integerValue == 1){
            if(_payAlertView && _payAlertView.superview){
                [self.payAlertView.inputBgView clearInput];
                [self.payAlertView.inputBgView makeFirstResponderIndex:0];
            }else{
                [self.payAlertView show];
            }
        }else{//完成 回到调起扫一扫界面
            UIViewController *controller = [self.navigationController frontControllerWithControllerName:@"MHQRCodeController"];
            if(controller){
                [self.navigationController popToViewController:controller animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }];
}

- (void)hanlePayAlertAction:(PayActionType)type password:(NSString *)passwordStr{
    switch (type) {
        case Pay_inputPasswordComple:
        {
            self.viewModel.password = passwordStr;
            [self.viewModel.payCommand execute:nil];
        }
            break;
        case Pay_forgetPassword:
        {
            _payAlertView = nil;
            LFindPasswordViewController *findPasswordVC = [LFindPasswordViewController new];
            findPasswordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController saveDirectViewControllerName:NSStringFromClass(self.class)];
            [self.navigationController pushViewController:findPasswordVC animated:YES];
        }
            break;
        case Pay_back:
        {
            _payAlertView = nil;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - lazyload
- (LIntgralsPayViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LIntgralsPayViewModel new];
    }
    return _viewModel;
}
- (LPayAlertView *)payAlertView{
    if(!_payAlertView){
        __weak __typeof(self)weakSelf = self;
        _payAlertView = [[LPayAlertView alloc] initWithPayComple:^(PayActionType type, NSString *passwordStr) {
            __strong __typeof(self)strongSelf = weakSelf;
            [strongSelf hanlePayAlertAction:type password:passwordStr];
        }];
        
    }
    return _payAlertView;
}

- (LIntegralsComplePayView *)payCompleView{
    if(!_payCompleView){
        _payCompleView = [LIntegralsComplePayView loadViewFromXib];
    }
    return _payCompleView;
}
- (LIntegralsPayDetailView *)payDetailView{
    if(!_payDetailView){
        _payDetailView = [LIntegralsPayDetailView loadViewFromXib];
        [_payDetailView configWithInfor:self.viewModel.goodsModel];
    }
    return _payDetailView;
}
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}
- (LIntegralsPayFailureView *)payFailureView{
    if(!_payFailureView){
        _payFailureView = [LIntegralsPayFailureView loadViewFromXib];
    }
    return _payFailureView;
}

- (MHStorePayViewModel *)checkViewModel{
    if(!_checkViewModel){
        _checkViewModel = [MHStorePayViewModel new];
    }
    return _checkViewModel;
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

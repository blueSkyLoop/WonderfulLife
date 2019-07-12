//
//  MHStoreIntegralPayHandler.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreIntegralPayHandler.h"
#import "MHUserInfoManager.h"
#import "MHConst.h"

#import "MHIntegralsPayAlertView.h"
#import "LPayAlertView.h"

#import "MHStoreGoodsHandler.h"

#import "LFindPasswordViewController.h"
#import "UINavigationController+MHDirectPop.h"
#import "LSetNewPasswordViewController.h"
#import "MHVoDataFillController.h"
#import "UIViewController+PresentLoginController.h"
#import "MHStoreOrderPayFailureViewController.h"
#import "MHStoreOrderPaySuccessViewController.h"
#import "MHVoSerIntegralDetailsController.h"
#import "MHMerchantOrderController.h"



@interface MHStoreIntegralPayHandler()

@property (nonatomic,weak)UIViewController *weakController;

@property (nonatomic,strong)LPayAlertView *payAlertView;

@property (nonatomic,assign)BOOL needShowPayAlertFlag;

@property (nonatomic,strong,readwrite)MHStorePayViewModel *viewModel;

@property (nonatomic,strong,readwrite)MHStoreGoodPayModel *payModel;

@property (nonatomic,strong)id payInfor;

@property (nonatomic,copy)NSString *tempPassword;

@end

@implementation MHStoreIntegralPayHandler

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (id)init{
    self = [super init];
    if(self){
        [self mh_bindViewModel];
    }
    return self;
}

- (void)mh_bindViewModel{
    
    //下单
    /*
     dict 包含以下字段
     result_code   integer   订单购买结果  0为全部校验成功,2001表示用户不是志愿者,2002表示未设置支付密码,2003表示积分不足,2004密码错误
     result_msg    sring      返回信息
     */
    @weakify(self);
    [self.viewModel.goodsBuyCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        @strongify(self);
        NSInteger result_code = [dict[@"result_code"] integerValue];
        if(result_code == 0){//支付成功
            //成功发出支付成功通知
            if(self.payCompleBlock){
                self.payCompleBlock(YES, dict);
            }
        }else{
            if(self.payCompleBlock){
                self.payCompleBlock(NO, dict);
            }
        }
        //处理支付结果
        [self handlePayErrorWithCode:result_code withArg:dict];
        
    }];
    [[self.viewModel.goodsBuyCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if(error.code == -4){//要重新登录
            [self.weakController presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.weakController.view];
        }
    }];
    
    //0为全部校验成功,2001表示用户不是志愿者,2002表示未设置支付密码,2003表示积分不足
    [self.viewModel.goodsBuyCheckCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        @strongify(self);
        NSInteger result_code = [dict[@"result_code"] integerValue];
        NSString *result_msg = dict[@"result_msg"];
        if(result_code == 0){
            if(self.viewModel.password && self.viewModel.password.length){
                //有密码直接调起支付接口
                [self.viewModel.goodsBuyCommand execute:self.viewModel.password];
            }else{
                //校验完成，直接弹起支付
                [self showPayPasswordAlert];
            }
        }else if(result_code == not_volunteerCode || result_code == not_setPassword || result_code == integralsLess){
            //处理校验结果
            [self handlePayErrorWithCode:result_code withArg:dict];
        }else{
            [MHHUDManager showErrorText:result_msg];
        }
    }];
    [[self.viewModel.goodsBuyCheckCommand errors] subscribeNext:^(NSError *error) {
        @strongify(self);
        if(error.code == -4){//要重新登录
            [self.weakController presentLoginController];
        }else{
            [MHHUDManager showWithError:error withView:self.weakController.view];
        }
        
    }];
    
    //用于积分抵扣密码验证
    [self.viewModel.requestSuccessSubject subscribeNext:^(NSString *password) {
        @strongify(self);
        [self hiddenPasswordAlert];
        if(self.payCompleBlock){
            self.payCompleBlock(YES, password);
        }
    }];
    
    [self.viewModel.requestFailureSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.payAlertView.inputBgView clearInput];
        [self.payAlertView.inputBgView makeFirstResponderIndex:0];
    }];
    
}

//把控制器的viewDidAppear转移到这里来实现
-(void)pay_viewDidAppear:(BOOL)animated{
    
    if(self.needShowPayAlertFlag){
        [self showPayPasswordAlert];
    }else{
        [self hiddenPasswordAlert];
    }
    
    self.needShowPayAlertFlag = NO;
    //重置标记
    [MHStoreGoodsHandler shareManager].volunteerApplyFalg = NO;
    [MHStoreGoodsHandler shareManager].registVolunteerClassName = nil;
    
}


//调起支付，内部会做支付处理校验，支付成功，失败，跳转，外部只关心支付成功与否和结果，成功和失败跳转，外部不需要处理，内部已做好
- (void)startPayWithPayModel:(MHStoreGoodPayModel *)payModel payInfor:(id)payInfor controller:(UIViewController *)controller comple:(void(^)(BOOL success,id data))comple{
    if(!payModel || !controller) return;
    if(!self.weakController || self.weakController != controller){
        self.weakController = controller;
    }
    self.payInfor = payInfor;
    self.payCompleBlock = [comple copy];
    self.payModel = payModel;
    
    self.viewModel.payTypeStr = payModel.payTypeStr;
    self.viewModel.payData = payModel.payData;
    //支付前校验，调接口再检验一下
    [self.viewModel.goodsBuyCheckCommand execute:payModel.totalScore];
    
}
- (void)handlePayResultWithCode:(NSInteger)code arg:(NSDictionary *)dict controller:(UIViewController *)controller payModel:(MHStoreGoodPayModel *)payModel{
    self.weakController = controller;
    self.payModel = payModel;
    [self handlePayErrorWithCode:code withArg:dict];
}
//处理支付结果
- (void)handlePayResultWithCode:(NSInteger)code arg:(NSDictionary *)dict controller:(UIViewController *)controller{
    self.weakController = controller;
    [self handlePayErrorWithCode:code withArg:dict];
}

//处理积分抵扣
- (void)handleIntergralDeductionWithModel:(MHStoreGoodPayModel *)payModel payInfor:(id)payInfor controller:(UIViewController *)controller comple:(void(^)(BOOL success,id data))comple{
    if(!payModel || !controller) return;
    if(!self.weakController || self.weakController != controller){
        self.weakController = controller;
    }
    self.payInfor = payInfor;
    self.payCompleBlock = [comple copy];
    self.payModel = payModel;
    
    //未设置支付密码
    if([MHUserInfoManager sharedManager].is_set_pay_password.integerValue == 0){
        
        [self handlePayErrorWithCode:not_setPassword withArg:nil];
        
    }else{
        
        [self showPayPasswordAlert];
        
    }
}

//根据code处理不同的事件
- (void)handlePayErrorWithCode:(NSInteger)code withArg:(NSDictionary *)dict{
    if(code != passwordError){
        [self hiddenPasswordAlert];
    }
    if(code == integralsLess){//积分余额不足
        
        [self setUpIntegralsLessAlertView];
        
    }else if(code == not_volunteerCode){//非志愿者
        
        [self setUpNotVolunteerAlertView];
        
    }else if(code == not_setPassword){//没有设置支付密码
        
        [self setPassword];
        
    }else if(code == passwordError){//支付密码错误
        self.viewModel.password = nil;
        [MHHUDManager showText:@"密码错误，支付失败" Complete:^{
            [self.payAlertView.inputBgView clearInput];
            [self.payAlertView.inputBgView makeFirstResponderIndex:0];
        }];
        
    }else if(code == 0){//支付成功
        
        //成功发出支付成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kStoreOrderPaySuccessNotification object:self.payModel.noticeObject];
        
        if(self.payModel.type == mhPay_coupon_pay){//商品支付
            //如果是商品支付，成功跳转到待使用订单列表，在待使用订单列表如果返回，则回到商品详情
            MHMerchantOrderController *orderListVC = (MHMerchantOrderController *)[self.weakController.navigationController findControllerWithControllerName:NSStringFromClass(MHMerchantOrderController.class)];
            if(orderListVC){
                orderListVC.type = MHMerchantOrderListTypeUnUsed;
                [self.weakController.navigationController popToViewController:orderListVC animated:YES];
            }else{
                orderListVC = [MHMerchantOrderController new];
                orderListVC.type = MHMerchantOrderListTypeUnUsed;
                [self.weakController.navigationController pushViewController:orderListVC animated:YES];
            }
        
            
        }else if(self.payModel.type == mhPay_qrcode_pay){//扫码支付
            MHStoreOrderPaySuccessViewController *succssVC = [MHStoreOrderPaySuccessViewController new];
            succssVC.payInfor = self.payInfor;
            [self.weakController.navigationController pushViewController:succssVC animated:YES];
            
        }else if(self.payModel.type == mhPay_property_pay){//积分抵扣
            if(self.payCompleBlock){
                self.payCompleBlock(YES, nil);
            }
        }
        
        
    }else{//支付失败
        
        MHStoreOrderPayFailureViewController *payFailureVC = [MHStoreOrderPayFailureViewController new];
        payFailureVC.title = @"积分支付";
        [self.weakController.navigationController pushViewController:payFailureVC animated:YES];
        payFailureVC.payFailureBlock = ^(NSInteger typeNum){
            //继续支付
            if(typeNum == 1){
                
                self.needShowPayAlertFlag = YES;
                
            }
        };
        
    }
    
}

#pragma mark - 不是志愿者的界面
- (void)setUpNotVolunteerAlertView{
    
    MHIntegralsPayAlertView *alertView = [[MHIntegralsPayAlertView alloc] initWithPaySuggestType:IntegralsPayFailuret_notVolunteer comple:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){//注册志愿者
            [self p_checkisLogin];
            
        }else if(buttonIndex == 1){//我知道了
            
        }
    }];
    alertView.suggestLabel.text = @"您还不是志愿者，不可消费积分\n请先注册成为志愿者";
    [alertView show];
    
    
}


#pragma mark - 积分不足的界面
- (void)setUpIntegralsLessAlertView{
    MHIntegralsPayAlertView *alertView = [[MHIntegralsPayAlertView alloc] initWithPaySuggestType:IntegralsPayFailuret_less comple:^(NSInteger buttonIndex) {
        //        [self backTopHomePage];
    }];
    alertView.suggestLabel.text = @"积分余额不足无法支付";
    [alertView show];
    
}

#pragma mark - 设置密码
- (void)setPassword{
    LSetNewPasswordViewController *setPasswordVC = [[LSetNewPasswordViewController alloc] initWithSetType:PayPassword_set];
    [self.weakController.navigationController saveDirectViewControllerName:NSStringFromClass(self.weakController.class)];
    [self.weakController.navigationController pushViewController:setPasswordVC animated:YES];
}



#pragma mark - 调起志愿者申请
- (void)p_checkisLogin {
    [self.weakController.navigationController setNavigationBarHidden:NO animated:NO];
    BOOL isLogin = [MHUserInfoManager sharedManager].isLogin;
    //把标记设置为YES，方便成功之后返回到哪个界面,结合UINavigationController+MHDirectPop里的方法
    [MHStoreGoodsHandler shareManager].volunteerApplyFalg = YES;
    [MHStoreGoodsHandler shareManager].registVolunteerClassName = NSStringFromClass(self.weakController.class);
    if (isLogin) {
        MHVoDataFillController *vc = [[MHVoDataFillController alloc] init];
        [self.weakController.navigationController pushViewController:vc animated:YES];
    } else {
        [self.weakController presentLoginControllerWithJoinVolunteer:YES];
    }
}


#pragma mark - 弹起密码输入界面
- (void)showPayPasswordAlert{
    [self hiddenPasswordAlert];
    [self.payAlertView show];
}
#pragma mark - 隐藏密码输入界面
- (void)hiddenPasswordAlert{
    if(_payAlertView && _payAlertView.superview){
        [_payAlertView removeFromSuperview];
    }
    _payAlertView = nil;
}

#pragma mark - 密码输入界面按钮事件
- (void)hanlePayAlertAction:(PayActionType)type password:(NSString *)passwordStr{
    switch (type) {
        case Pay_inputPasswordComple:
        {
            if(self.payModel.type == mhPay_property_pay || self.payModel.type == mhPay_coupon_pay){
                self.viewModel.password = passwordStr;
                //检测支付密码
                [self.viewModel startPasswordCheck];
                
            }else{
                //密码输入完成，调起支付接口
                [self.viewModel.goodsBuyCommand execute:passwordStr];
            }
            
        }
            break;
        case Pay_forgetPassword:
        {
            _payAlertView = nil;
            LFindPasswordViewController *findPasswordVC = [LFindPasswordViewController new];
            [self.weakController.navigationController saveDirectViewControllerName:NSStringFromClass(self.weakController.class)];
            [self.weakController.navigationController pushViewController:findPasswordVC animated:YES];
        }
            break;
        case Pay_back:
        {
            [self hiddenPasswordAlert];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 支付界面
- (LPayAlertView *)payAlertView{
    if(!_payAlertView){
        @weakify(self);
        _payAlertView = [[LPayAlertView alloc] initWithPayComple:^(PayActionType type, NSString *passwordStr) {
            @strongify(self);
            [self hanlePayAlertAction:type password:passwordStr];
        }];
        
        if(self.payModel.type == mhPay_property_pay || self.payModel.type == mhPay_coupon_pay){
            _payAlertView.atitleLable.text = @"请输入爱心积分支付密码";
        }
        
    }
    return _payAlertView;
}

- (MHStorePayViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHStorePayViewModel new];
    }
    return _viewModel;
}


@end

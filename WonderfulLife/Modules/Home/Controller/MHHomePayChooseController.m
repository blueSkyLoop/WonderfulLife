//
//  MHHomePayChooseController.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayChooseController.h"

#import "MHPayManager.h"
#import "MHHomeRequest.h"

#import "MHNavigationControllerManager.h"


#import "MHConstSDKConfig.h"
#import "MHConst.h"
#import "WXApi.h"

#import "HLWebViewController.h"
#import "UIViewController+PresentLoginController.h"
#import "UINavigationController+MHDirectPop.h"

#import "MHPropertyViewModel.h"
#import "MHStoreIntegralPayHandler.h"

#import "MHPayChooseView.h"



@interface MHHomePayChooseController ()<MHPayManagerDelegate,MHNavigationControllerManagerProtocol>

//积分支付处理者
@property (nonatomic,strong)MHStoreIntegralPayHandler *payHandler;
@property (nonatomic,strong)MHPropertyViewModel *viewModel;

@property (nonatomic,strong)MHPayChooseView *chooseView;
@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation MHHomePayChooseController


- (id)initWithPayModel:(MHStoreGoodPayModel *)payModel{
    self = [super init];
    if(self){
        self.viewModel.payModel = payModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetBackNaviItem];
    
    if(self.viewModel.payModel.type == mhPay_coupon_pay){
        [WXApi registerApp:@"wx84fd83ebf02f3267"];
    }else if(self.viewModel.payModel.type == mhPay_property_pay){
        [WXApi registerApp:@"wx1aaa005c38048f44"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //支付必要的处理
    [self.payHandler pay_viewDidAppear:animated];
}

//子类重写此方法
- (void)nav_back{
    
    [self.navigationController directTopControllerPop];

}
//右滑手势禁止代理
- (BOOL)bb_ShouldBack{
    return NO;
}

- (void)mh_setUpUI{
    [self.scrollView addSubview:self.chooseView];
    [self.view addSubview:self.scrollView];
    
    [_chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.chooseView.mas_width);
    }];
    
    @weakify(self);
    [[[_chooseView.questionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        HLWebViewController *vc = [[HLWebViewController alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",baseUrl,@"h5/scoreDeductible/rule"]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[[_chooseView.intergralChooseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self intergralChooseAction:x];
    }];
    
    [[[_chooseView.payButton rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.viewModel.payModel.type == mhPay_property_pay){//物业缴费
            if (self.chooseView.payType == MHHomePayChooseTypeWeChat){
                
                if(![WXApi isWXAppInstalled]){
                    [MHHUDManager showErrorText:@"你还没安装微信客户端"];
                    return ;
                }
                
                [self.viewModel wechatPayRequest];
                
            }else if(self.chooseView.payType == MHHomePayChooseTypeAliPay){
                [self.viewModel alipayRequest];
            }
            
        }else if(self.viewModel.payModel.type == mhPay_coupon_pay){//周边商城商品支付
            //纯积分支付
            if(self.viewModel.isSelectDeduction && self.viewModel.enableDeductionAllAmount){
                [self.payHandler startPayWithPayModel:self.viewModel.payModel payInfor:nil controller:self comple:nil];
            }else{
                if (self.chooseView.payType == MHHomePayChooseTypeWeChat){
                    if(![WXApi isWXAppInstalled]){
                        [MHHUDManager showErrorText:@"你还没安装微信客户端"];
                        return ;
                    }
                }
                [self.viewModel couponPayRequest];
            }
        }
        
    }];
    
}
- (void)mh_bindViewModel{
    @weakify(self);
    [self.viewModel.requestSuccessSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self handleRequestResult:x];
        
    }];
    [self.viewModel.requestFailureSubject subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSNumber *apiFlag,NSNumber *code) = x;
        @strongify(self);
        if(apiFlag.integerValue == 1){
            self.chooseView.intergralChooseBtn.enabled = NO;
        }
        
        //需要重新登录
        if(code.integerValue == -4){
            [self presentLoginController];
        }
    }];
    
    //双向绑定
    RACChannelTo(self.viewModel,isSelectDeduction) = RACChannelTo(self.chooseView.intergralChooseBtn,selected);
    [RACObserve(self.chooseView, payType) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([x integerValue] == MHHomePayChooseTypeWeChat){
            self.viewModel.payWay = 2;
        }else if([x integerValue] == MHHomePayChooseTypeAliPay){
            self.viewModel.payWay = 1;
        }
    }];
    [RACObserve(self.chooseView.intergralChooseBtn, selected) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([x boolValue]){
            self.chooseView.deductionLabel.text = self.viewModel.used_text;
            self.chooseView.totalLabel.text = [NSString stringWithFormat:@"%.2f",[self.viewModel.payModel.totalScore doubleValue] - [self.viewModel.available_score doubleValue]];
        }else{
            if(self.viewModel.usable_text && self.viewModel.usable_text.length){
                self.chooseView.deductionLabel.text = self.viewModel.usable_text;
            }
            self.chooseView.totalLabel.text = self.viewModel.payModel.totalScore;
        }
    }];
    
    RACSignal *signal1 = RACObserve(self.viewModel,isSelectDeduction);
    RACSignal *signal2 = RACObserve(self.viewModel,enableDeductionAllAmount);
    //组合信号
    [[signal1 merge:signal2] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if(self.viewModel.isSelectDeduction && self.viewModel.enableDeductionAllAmount){
            [self.chooseView payChooseShow:NO];
        }else{
            [self.chooseView payChooseShow:YES];
        }
        
    }];
    
    
    //查询请求
    [self.viewModel startQueryIntergralDeductionRequest];
}
//结果处理分配
- (void)handleRequestResult:(id)x{
    RACTupleUnpack(NSNumber *apiFlag,id data) = x;
    if(apiFlag.integerValue == 1){//查询
        self.chooseView.deductionLabel.text = self.viewModel.usable_text;
        if([self.viewModel.available_score doubleValue] > 0.00001){
            self.chooseView.intergralChooseBtn.enabled = YES;
        }else{
            self.chooseView.intergralChooseBtn.enabled = NO;
        }
        
    }else if(apiFlag.integerValue == 2){//物业缴费支付宝支付
        
        [self alipayWithPayData:data];
        
    }else if(apiFlag.integerValue == 3){//物业缴费微信支付
        
        [self wechatPayWithPayInfor:data];
        
    }else if(apiFlag.integerValue == 4){
        NSInteger result_code = [data[@"result_code"] integerValue];
        if(result_code == 0){
            //商品 支付宝支付
            if(self.viewModel.payWay == 1){
                NSString *payData = data[@"alipay_trade_pay_response"];
                if([payData isEqual:[NSNull null]]){
                    return;
                }
                [self alipayWithPayData:payData];
            }else if(self.viewModel.payWay == 2){//商品 微信支付
                NSString *payData = data[@"weixin_trade_pay_response"];
                if([payData isEqual:[NSNull null]]){
                    return;
                }
                NSData *JSONData = [payData dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
                [self wechatPayWithPayInfor:responseJSON];
            }
            
        }else if(result_code == not_volunteerCode || result_code == not_setPassword || result_code == integralsLess){
            //处理校验结果
            [self.payHandler handlePayResultWithCode:result_code arg:nil controller:self];
        }else{
            [MHHUDManager showErrorText:data[@"result_msg"]];
        }
    }
}

- (void)intergralChooseAction:(UIButton *)sender{
    
    //如果已经输入过密码了，则不需要再次输入了
    if(self.viewModel.password){
        sender.selected = !sender.selected;
    }else{
        if(sender.selected){
            sender.selected = NO;
            return;
        }
        @weakify(self);
        [self.payHandler handleIntergralDeductionWithModel:self.viewModel.payModel payInfor:nil controller:self comple:^(BOOL success, NSString *password) {
            if(success && password){
                @strongify(self);
                self.viewModel.password = password;
                self.chooseView.intergralChooseBtn.selected = YES;
            }
        }];
    }
}


- (void)alipayWithPayData:(NSString *)orderString{
    if(!orderString || !orderString.length) return;
    [MHPayManager doAlipayPayWithOrderString:orderString Callback:^(BOOL success){
        
        [self payResultHandle:success];
        
    }];
}

- (void)wechatPayWithPayInfor:(NSDictionary *)dict{
    if(!dict || ![dict isKindOfClass:[NSDictionary class]] || !dict.count) return;
    MHPayManager *manager = [MHPayManager sharedManager];
    manager.delegate = self;

    [MHPayManager jumpToBizPayWithDic:dict];
}


#pragma mark - MHPayManagerDelegate
- (void)weChatPaySuccess:(BOOL)success{
    
    [self payResultHandle:success];
}

//支付结果处理
- (void)payResultHandle:(BOOL)success{
    if(success){
        
        if(self.viewModel.payModel.type == mhPay_property_pay){
            //成功发出支付成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kStoreOrderPaySuccessNotification object:self.viewModel.payModel.noticeObject];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if(self.viewModel.payModel.type == mhPay_coupon_pay){//商品支付
            
            [self.payHandler handlePayResultWithCode:0 arg:nil controller:self payModel:self.viewModel.payModel];
            
        }
    }
    
}
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}

- (MHPayChooseView *)chooseView{
    if(!_chooseView){
        _chooseView = [MHPayChooseView loadViewFromXib];
        if (self.viewModel.payModel.totalScore.length > 0) {
            _chooseView.totalLabel.text = self.viewModel.payModel.totalScore;
        }
//        if(self.viewModel.payModel.type == mhPay_coupon_pay){
//            [_chooseView hiddenWechat];
//        }

    }
    return _chooseView;
}

- (MHStoreIntegralPayHandler *)payHandler{
    if(!_payHandler){
        _payHandler = [MHStoreIntegralPayHandler new];
    }
    return _payHandler;
}

- (MHPropertyViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHPropertyViewModel new];
    }
    return _viewModel;
}

@end

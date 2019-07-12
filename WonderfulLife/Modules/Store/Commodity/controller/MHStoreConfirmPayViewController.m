//
//  MHStoreConfirmPayViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreConfirmPayViewController.h"

#import "MHStoreIntegralPayHandler.h"
#import "MHStoreQrcodePayViewModel.h"
#import "MHStoreGoodPayModel.h"

#import "MHStoreQrcodeConfirmPayView.h"


@interface MHStoreConfirmPayViewController ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)MHStoreQrcodeConfirmPayView *confirmView;

//积分支付处理者
@property (nonatomic,strong)MHStoreIntegralPayHandler *payHandler;

@property (nonatomic,strong)MHStoreQrcodePayViewModel *viewModel;



@end

@implementation MHStoreConfirmPayViewController

- (void)setInfor:(id)infor{
    if(_infor != infor){
        _infor = infor;
        self.viewModel.merchant_id = _infor[@"merchant_id"];
        [self.confirmView confitUIWithInfor:_infor];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.payHandler pay_viewDidAppear:animated];
    
}
- (void)mh_setUpUI{
    
    [self.scrollView addSubview:self.confirmView];
    [self.view addSubview:self.scrollView];
    
    [_confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollView);
        make.bottom.lessThanOrEqualTo(self.scrollView.mas_bottom);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)mh_bindViewModel{
    
    RAC(self.viewModel,totalScore) = self.confirmView.textField.rac_textSignal;
    
    @weakify(self);
    //确定支付
    [[[self.confirmView.comfirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.view endEditing:YES];
        NSDictionary *dict = @{@"merchant_id":self.viewModel.merchant_id,@"score":self.viewModel.totalScore};
        MHStoreGoodPayModel *payModel = [MHStoreGoodPayModel new];
        payModel.type = mhPay_qrcode_pay;
        payModel.totalScore = self.viewModel.totalScore;
        payModel.payTypeStr = @"seller";
        payModel.payData = [dict yy_modelToJSONString];
        payModel.noticeObject = [NSString stringWithFormat:@"%@",self.viewModel.merchant_id];
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.infor];
        [muDic setValue:self.viewModel.totalScore forKey:@"totalScore"];
        [self.payHandler startPayWithPayModel:payModel payInfor:muDic controller:self comple:nil];
        
        
    }];
}


#pragma mark - lazyload
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}
- (MHStoreQrcodeConfirmPayView *)confirmView{
    if(!_confirmView){
        _confirmView = [MHStoreQrcodeConfirmPayView loadViewFromXib];
    }
    return _confirmView;
}

- (MHStoreIntegralPayHandler *)payHandler{
    if(!_payHandler){
        _payHandler = [MHStoreIntegralPayHandler new];
        
    }
    return _payHandler;
}

- (MHStoreQrcodePayViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [MHStoreQrcodePayViewModel new];
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

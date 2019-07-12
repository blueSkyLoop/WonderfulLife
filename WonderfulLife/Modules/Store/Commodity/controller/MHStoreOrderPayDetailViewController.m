//
//  MHStoreOrderPayDetailViewController.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreOrderPayDetailViewController.h"

#import "MHStoreGoodsOrderPayDetailView.h"

#import "MHStoreIntegralPayHandler.h"

#import "MHStoreConfirmPayViewController.h"
#import "MHNavigationControllerManager.h"
#import "UINavigationController+MHDirectPop.h"


@interface MHStoreOrderPayDetailViewController ()<MHNavigationControllerManagerProtocol>

@property (nonatomic,strong)MHStoreGoodsOrderPayDetailView *orderPayView;
@property (nonatomic,strong)UIScrollView *scrollView;

//积分支付处理者
@property (nonatomic,strong)MHStoreIntegralPayHandler *payHandler;



@end

@implementation MHStoreOrderPayDetailViewController

- (void)dealloc{
    NSLog(@"%s",__func__);
}


- (void)setPayModel:(MHStoreGoodPayModel *)payModel{
    if(_payModel != payModel){
        _payModel = payModel;
        self.orderPayView.scoreLabel.text = [NSString stringWithFormat:@"%@%@",_payModel.totalScore,@"积分"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetBackNaviItem];
}

//子类重写此方法
- (void)nav_back{
    
    [self.navigationController directTopControllerPop];
}
//右滑手势禁止代理
- (BOOL)bb_ShouldBack{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.payHandler pay_viewDidAppear:animated];
    
}

- (void)mh_setUpUI{
    [self.scrollView addSubview:self.orderPayView];
    [self.view addSubview:self.scrollView];
    
    [_orderPayView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    //支付点击事件
    [[[self.orderPayView.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.2] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.payHandler startPayWithPayModel:self.payModel payInfor:nil controller:self comple:nil];
        
    }];
}


#pragma mark - lazyload
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}
- (MHStoreGoodsOrderPayDetailView *)orderPayView{
    if(!_orderPayView){
        _orderPayView = [MHStoreGoodsOrderPayDetailView loadViewFromXib];
    }
    return _orderPayView;
}

//支付处理者
- (MHStoreIntegralPayHandler *)payHandler{
    if(!_payHandler){
        _payHandler = [MHStoreIntegralPayHandler new];
    }
    return _payHandler;
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

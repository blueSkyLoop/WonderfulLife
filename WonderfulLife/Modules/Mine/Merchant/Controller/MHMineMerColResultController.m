//
//  MHMineMerColResultController.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/2.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerColResultController.h"
#import "MHMineMerFinListController.h"
#import "MHVoSerIntegralDetailsController.h"


#import "MHMineMerColCompView.h"    // 收款成功
#import "MHMineMerFailureView.h"    // 支付失败 or 收款失败
#import "MHMineMerPayComView.h"  // 支付成功

#import "MHMineMerchantPayModel.h"

#import "MHNavigationControllerManager.h"
#import "UIViewController+HLNavigation.h"
#import "UINavigationController+MHDirectPop.h"

#import "MHMacros.h"
#import "MHWeakStrongDefine.h"
#import "UILabel+isNull.h"
@interface MHMineMerColResultController ()<MHNavigationControllerManagerProtocol>

@property (assign,nonatomic) MerColResultType type;

@property (nonatomic, assign) MerResultOpenType openType;

@property (nonatomic, strong) MHMineMerchantPayModel  *payModel;

@property (nonatomic, strong) MHMineMerColCompView  *incomeCompView;

@property (nonatomic, strong) MHMineMerFailureView  *failView;

@property (nonatomic, strong) MHMineMerPayComView  *payComView;


@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation MHMineMerColResultController

- (instancetype)initWithModel:(MHMineMerchantPayModel*)model type:(MerColResultType)type openType:(MerResultOpenType)openType{
    if([super init]) {
        self.type = type ;
        self.payModel = model ;
        self.openType = openType ;
    }return self ;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self hl_setNavigationItemLineColor:MColorSeparator];
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {

    
    NSDictionary* dict=[NSDictionary dictionaryWithObject:MColorTitle forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    if (self.openType == MerResultOpenType_Present) {
        [self.navigationController.navigationBar addSubview:self.backBtn];
    }
    
    if (self.type == MerColResultType_CompIncome) {
        
        [self.view addSubview:self.incomeCompView];
        
    }else if (self.type == MerColResultType_CompPay) {
        
        [self.view addSubview:self.payComView];
    }
    else {
        [self.view addSubview:self.failView];
    }
    
    if (self.type == MerColResultType_CompPay || self.type == MerColResultType_FailurePay) {
        self.title = @"支付结果";
        
    }else {
        self.title = @"收款结果";
    }
}

- (BOOL)bb_ShouldBack {
    if (self.openType == MerResultOpenType_Push && self.type == MerColResultType_FailureIncome) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController directTopControllerPop];
    }
    
    return NO ;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Getter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 44, 44);
        [_backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (MHMineMerFailureView *)failView {
    if (!_failView) {
        _failView = [MHMineMerFailureView loadViewFromXibWithResultType:self.type];
        _failView.frame = self.view.bounds ;
    }return _failView ;
}

- (MHMineMerColCompView *)incomeCompView {
    if (!_incomeCompView) {
        _incomeCompView = [MHMineMerColCompView loadViewFromXib:self.payModel resultType:self.type];
        _incomeCompView.frame = self.view.bounds ;
        MHWeakify(self)
        //财务报表
        [[_incomeCompView.paySubject throttle:.2] subscribeNext:^(id  _Nullable x) {
            MHStrongify(self)
            MHMineMerFinListController * vc = [[MHMineMerFinListController alloc] init];
            vc.merchant_id = self.payModel.merchant_id ;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }return _incomeCompView ;
}

- (MHMineMerPayComView *)payComView {
    if (!_payComView) {
        _payComView = [MHMineMerPayComView loadViewFromXib:self.payModel];
        _payComView.frame = self.view.bounds ;
        MHWeakify(self)
        //财务报表
        [[_payComView.doneSubject throttle:.2] subscribeNext:^(id  _Nullable x) {
            MHStrongify(self)
            MHVoSerIntegralDetailsController *vc = [[MHVoSerIntegralDetailsController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }return _payComView ;
}
@end

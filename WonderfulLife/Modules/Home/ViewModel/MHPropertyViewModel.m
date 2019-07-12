//
//  MHPropertyViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2018/1/3.
//  Copyright © 2018年 WuHanMeiHao. All rights reserved.
//

#import "MHPropertyViewModel.h"
#import "MHPropertyParameter.h"

@implementation MHPropertyViewModel

- (void)mh_initialize{
    @weakify(self);
    self.resultBlock = ^(BOOL success, NSInteger apiFlag, NSInteger code, id data, id orginData, NSString *message) {
        @strongify(self);
        if(success){
            if(apiFlag == 1){
                
                self.usable_text = data[@"usable_text"];
                self.available_score = data[@"available_score"];
                self.used_text = data[@"used_text"];
                //如果可抵扣金额大于等于要支付金额，则认为是可完全抵扣
                if([self.available_score doubleValue] - [self.payModel.totalScore doubleValue] > 0 || fabs([self.available_score doubleValue] - [self.payModel.totalScore doubleValue]) < 0.0001){
                    self.enableDeductionAllAmount = YES;
                }else{
                    self.enableDeductionAllAmount = NO;
                }
            }
            
            [self.requestSuccessSubject sendNext:RACTuplePack(@(apiFlag),data)];

        }else{
            
            [self.requestFailureSubject sendNext:RACTuplePack(@(apiFlag),@(code))];
        }
    };
}
// 查询可抵扣积分
- (void)startQueryIntergralDeductionRequest{
    NSString *api;
     NSDictionary *parameter ;
    if(self.payModel.type == mhPay_coupon_pay){
        api = API_coupon_available;
        parameter = [MHPropertyParameter queryCouponAvailableWithOrder_no_list:self.payModel.payData];
    }else if(self.payModel.type == mhPay_property_pay){
        api = API_property_available;
        parameter = [MHPropertyParameter queryPropertyAvailableWithProperty_id:self.payModel.payTypeStr payment_month_list:self.payModel.payData];
    }
    
    LNHttpConfig *config = [self mh_defaultHttpConfigWithApi:api];
    config.parameter = parameter;
    config.apiFlag = 1;
    [self startHttpWithRequestConfig:config];
}

//支付宝支付参数请求
- (void)alipayRequest{
    LNHttpConfig *config = [self mh_defaultHttpConfigWithApi:API_property_alipay];
    config.parameter = [MHPropertyParameter alipayWithProperty_id:self.payModel.payTypeStr payment_month_list:self.payModel.payData score:self.isSelectDeduction?self.available_score:nil pay_password:self.isSelectDeduction?self.password:nil];
    config.apiFlag = 2;
    config.checkClassName = NSStringFromClass([NSString class]);
    [self startHttpWithRequestConfig:config];
}

//微信支付参数请求
- (void)wechatPayRequest{
    LNHttpConfig *config = [self mh_defaultHttpConfigWithApi:API_property_wechat];
    config.parameter = [MHPropertyParameter wechatPayWithProperty_id:self.payModel.payTypeStr payment_month_list:self.payModel.payData score:self.isSelectDeduction?self.available_score:nil pay_password:self.isSelectDeduction?self.password:nil];
    config.apiFlag = 3;
    [self startHttpWithRequestConfig:config];
}

//商城商品支付宝微信支付参数请求
- (void)couponPayRequest{
    LNHttpConfig *config = [self mh_defaultHttpConfigWithApi:API_coupon_pay];
    config.parameter = [MHPropertyParameter couponPayWithOrder_no_list:self.payModel.payData score:self.isSelectDeduction?self.available_score:nil pay_password:self.isSelectDeduction?self.password:nil pay_way:self.payWay];
    config.apiFlag = 4;
    [self startHttpWithRequestConfig:config];
}



@end

//
//  MHStorePayViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStorePayViewModel.h"
#import "MHStoreCommodityParameter.h"
#import "LHttpParameter.h"

@interface MHStorePayViewModel()

//支付订单
@property (nonatomic,strong,readwrite)RACCommand *goodsBuyCommand;
//支付前校验接口
@property (nonatomic,strong,readwrite)RACCommand *goodsBuyCheckCommand;


@end

@implementation MHStorePayViewModel

- (void)mh_initialize{
    @weakify(self);
    self.resultBlock = ^(BOOL success, NSInteger apiFlag, NSInteger code, id data, id orginData, NSString *message) {
        if(success){
            @strongify(self);
            [self.requestSuccessSubject sendNext:self.password];
        }else{
            @strongify(self);
            self.password = nil;
            if(code == 1002){//密码错误
                [self.requestFailureSubject sendNext:nil];
            }
        }
    };
}

//密码检测
- (void)startPasswordCheck{
    LNHttpConfig *config = [self mh_defaultHttpConfigWithApi:API_ValidatePayPassword];
    config.parameter = [LHttpParameter validatePayWithToken:@"" pay_password:self.password];
    [self startHttpWithRequestConfig:config];
}


//支付订单
- (RACCommand *)goodsBuyCommand{
    if(!_goodsBuyCommand){
        @weakify(self);
        _goodsBuyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *password) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parametr = [MHStoreCommodityParameter paymentScoreWithType:self.payTypeStr data:self.payData password:password];
                [[MHNetworking shareNetworking] post:API_payment_score_pay params:parametr success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [data isKindOfClass:[NSDictionary class]]){
                        [subscriber sendNext:data];
                        [subscriber sendCompleted];
                    }else{
                        [self handleErrmsg:nil errorCodeNum:nil subscriber:subscriber];
                    }
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                return nil;
            }];
        }];
    }
    return _goodsBuyCommand;
}
//支付前校验接口
- (RACCommand *)goodsBuyCheckCommand{
    if(!_goodsBuyCheckCommand){
        @weakify(self);
        _goodsBuyCheckCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *totalScore) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parametr = [MHStoreCommodityParameter paymentScoreCheckWithScore:totalScore];
                [[MHNetworking shareNetworking] post:API_payment_score_check params:parametr success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [data isKindOfClass:[NSDictionary class]]){
                        [subscriber sendNext:data];
                        [subscriber sendCompleted];
                    }else{
                        [self handleErrmsg:nil errorCodeNum:nil subscriber:subscriber];
                    }
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                return nil;
            }];
        }];
    }
    return _goodsBuyCheckCommand;
}


@end

//
//  LIntgralsPayViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LIntgralsPayViewModel.h"
#import "MHNetworking.h"
#import "LHttpParameter.h"
#import "MHHUDManager.h"

#import "MHStoreCommodityParameter.h"

@interface LIntgralsPayViewModel()

@property (nonatomic,strong,readwrite)RACCommand *payCommand;

@end

@implementation LIntgralsPayViewModel

- (RACCommand *)payCommand{
    if(!_payCommand){
        @weakify(self);
        _payCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
//                NSDictionary *dict = [LHttpParameter vemPaymentPayWithToken:@"" payment_id:self.goodsModel.payment_id pay_password:self.password];
                //2017.11.6积分支付统一，改成以下接口
                NSDictionary *parameter = [MHStoreCommodityParameter paymentScoreWithType:@"vem" data:[NSString stringWithFormat:@"%ld",self.goodsModel.payment_id] password:self.password];
                [[MHNetworking shareNetworking] post:API_payment_score_pay params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    [subscriber sendNext:data];
                    [subscriber sendCompleted];
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{@"errmsg":errmsg?:@"网络出错",@"code":@(errcode)}];
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                    
                }];
                return nil;
            }];
        }];
    }
    return _payCommand;
}

@end

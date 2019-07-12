//
//  MHStoreOrdersConsumptionViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/11/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreOrdersConsumptionViewModel.h"
#import "MHStoreCommodityParameter.h"

@interface MHStoreOrdersConsumptionViewModel ()

//订单消费，订单详情
@property (nonatomic,strong,readwrite)RACCommand *orderDetailCommand;

//订单消费
@property (nonatomic,strong,readwrite)RACCommand *orderCostCommand;
@end

@implementation MHStoreOrdersConsumptionViewModel

//订单消费，订单详情
- (RACCommand *)orderDetailCommand{
    if(!_orderDetailCommand){
        @weakify(self);
        _orderDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parameter = [MHStoreCommodityParameter orderDetailWithOrder_no:self.order_no];
                [[MHNetworking shareNetworking] post:API_mall_merchant_order_detail params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [data isKindOfClass:[NSDictionary class]]){
                        /*
                        order_no  string 订单号  nickname  string 下单用户昵称  phone string 下单用户手机  order_status integer
                        订单状态，0待付款，1待使用，2待评价，3已完成，4退款中，5退款成功，6退款失败(待使用)，7已过期 */
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
    return _orderDetailCommand;
}
//订单消费
- (RACCommand *)orderCostCommand{
    if(!_orderCostCommand){
        @weakify(self);
        _orderCostCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parameter = [MHStoreCommodityParameter orderCossumeWithOrder_no:self.order_no];
                [[MHNetworking shareNetworking] post:API_mall_merchant_order_consume params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    
                } failure:^(NSString *errmsg, NSInteger errcode) {
                    [MHHUDManager dismiss];
                    [self handleErrmsg:errmsg errorCodeNum:@(errcode) subscriber:subscriber];
                }];
                return nil;
            }];
        }];
    }
    return _orderCostCommand;
}

@end

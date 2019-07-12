//
//  MHStoreOrderSumitViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreOrderSumitViewModel.h"
#import "MHStoreCommodityParameter.h"

@interface MHStoreOrderSumitViewModel()
//商品查询，库存量之类的
@property (nonatomic,strong,readwrite)RACCommand *goodsQueryCommand;
//提交订单
@property (nonatomic,strong,readwrite)RACCommand *goodsSubmitCommand;

@end

@implementation MHStoreOrderSumitViewModel

#pragma mark - lazyLoad
//查询商品库存
- (RACCommand *)goodsQueryCommand{
    if(!_goodsQueryCommand){
        @weakify(self);
        _goodsQueryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parametr = [MHStoreCommodityParameter orderSubmitQueryWithCoupon_id:self.coupon_id];
                [[MHNetworking shareNetworking] post:API_mall_coupon_before_buy params:parametr success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [data isKindOfClass:[NSDictionary class]]){
                        self.orderModel = [MHStoreGoodsOrderDetailModel yy_modelWithJSON:data];
                        [subscriber sendNext:self.orderModel];
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
    return _goodsQueryCommand;
}
//商品提交，生成订单号
- (RACCommand *)goodsSubmitCommand{
    if(!_goodsSubmitCommand){
        @weakify(self);
        _goodsSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parametr = [MHStoreCommodityParameter orderCreateWithCoupon_id:self.coupon_id qty:self.detailModel.currentNum];
                [[MHNetworking shareNetworking] post:API_mall_order_create params:parametr success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [data isKindOfClass:[NSArray class]]){
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
    return _goodsSubmitCommand;
}


@end

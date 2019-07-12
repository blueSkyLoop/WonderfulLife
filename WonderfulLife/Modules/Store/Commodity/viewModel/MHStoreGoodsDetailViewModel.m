//
//  MHStoreGoodsDetailViewModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsDetailViewModel.h"

#import "MHStoreCommodityParameter.h"


@interface MHStoreGoodsDetailViewModel()

@property (nonatomic,strong,readwrite)RACCommand *goodsDetailCommand;


@end

@implementation MHStoreGoodsDetailViewModel

- (void)mh_initialize{
    
    @weakify(self);
    [self.goodsDetailCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.listRequesting = [x boolValue];
    }];
    
}

- (void)updateLocation{
    if([MHStoreGoodsHandler shareManager].current_gps_lat && [MHStoreGoodsHandler shareManager].current_gps_lng){
        self.current_gps_lng = [MHStoreGoodsHandler shareManager].current_gps_lng;
        self.current_gps_lat = [MHStoreGoodsHandler shareManager].current_gps_lat;
    }
}

#pragma mark - lazyload
- (RACCommand *)goodsDetailCommand{
    if(!_goodsDetailCommand){
        @weakify(self);
        _goodsDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [MHHUDManager show];
                NSDictionary *parameter = [MHStoreCommodityParameter goodsDetailWithCoupon_id:self.coupon_id
                                                                                      gps_lng:self.current_gps_lng?[NSString stringWithFormat:@"%@",@(self.current_gps_lng)]:nil
                                                                                      gps_lat:self.current_gps_lat?[NSString stringWithFormat:@"%@",@(self.current_gps_lat)]:nil];
                [[MHNetworking shareNetworking] post:API_mall_coupon_get params:parameter success:^(id data) {
                    [MHHUDManager dismiss];
                    if(data && [data isKindOfClass:[NSDictionary class]]){
                        self.goodsDetailModel = [MHStoreGoodsDetailModel yy_modelWithJSON:data];
                        
                        [self.dataSoure removeAllObjects];
                        if((self.goodsDetailModel.img_list && self.goodsDetailModel.img_list.count) || (self.goodsDetailModel.remark && ![self.goodsDetailModel.remark isEqual:[NSNull null]] && self.goodsDetailModel.remark.length)){
                            //创造两项
                            [self.dataSoure addObject:self.goodsDetailModel];
                            [self.dataSoure addObject:self.goodsDetailModel];
                        }else{
                            //一项
                            [self.dataSoure addObject:self.goodsDetailModel];
                        }
                        
                        [subscriber sendNext:self.goodsDetailModel];
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
    return _goodsDetailCommand;
}

@end

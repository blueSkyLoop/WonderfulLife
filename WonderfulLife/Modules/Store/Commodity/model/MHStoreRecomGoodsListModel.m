//
//  MHStoreRecomGoodsListModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRecomGoodsListModel.h"

@implementation MHStoreRecomGoodsListModel

//这个方法主要是商家列表里的数据转换成这个模型（因为商家商品列表和推荐商品列表结构不一致，后台不愿统一）
- (id)initWithMerchantCouponDic:(NSDictionary *)dict{
    
    MHStoreRecomGoodsListModel *model = [MHStoreRecomGoodsListModel new];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]){
        return model;
    }
    model.coupon_name = dict[@"coupon_name"];
    NSArray *picArr = dict[@"img_cover"];
    if(picArr.count){
        NSDictionary *picDic = [picArr firstObject];
        model.img_cover = picDic[@"s_url"]?:picDic[@"url"];
    }
    model.coupon_sales = [dict[@"coupon_sales"] integerValue];
    model.coupon_price = [NSString stringWithFormat:@"%@",dict[@"coupon_price"]?:@""];
    model.coupon_id = [dict[@"coupon_id"] integerValue];
    model.retail_price = [NSString stringWithFormat:@"%@",dict[@"retail_price"]?:@""];
    model.merchant_name = dict[@"merchant_name"];
    model.distance = dict[@"distance"];
    return model;
}

@end

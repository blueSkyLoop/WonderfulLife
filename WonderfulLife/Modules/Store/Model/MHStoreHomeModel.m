//
//  MHStoreHomeModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/1.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreHomeModel.h"
#import "MHStoreRecomGoodsListModel.h"

@implementation MHStoreHomeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"recommend_merchant_list" : [MHStHoShopModel class],
             @"banner_list" : [MHStHoBannerAdModel class],
             @"recommend_coupon_list" : [MHStHomeGoodsModel class],
             @"business_buttons" : [MHStHoBusinessModel class],
             };
}

@end


@implementation MHStHoShopModel


@end


@implementation MHStHomeGoodsModel


@end


@implementation MHStHoBannerAdModel


@end

@implementation MHStHoBusinessModel

@end


@implementation MHStHoAllGoodsModel 

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [MHStoreRecomGoodsListModel class],
             
             };
}

@end




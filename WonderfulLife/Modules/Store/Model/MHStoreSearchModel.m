//
//  MHStoreSearchModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/6.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreSearchModel.h"
#import "MHAliyunManager.h"
#import "MHStoShopDetailModel.h"

@implementation MHStoreSearchGoodsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"img_cover" : [MHOOSImageModel class],
             };
}
@end

@implementation MHStoreSearchModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"merchant_list_vos" : [MHStoShopDetailModel class],
             @"coupon_list_vos" : [MHStoreSearchGoodsModel class]
             };
}


@end

//
//  MHStoShopDetailModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/11/6.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoShopDetailModel.h"
#import "MHAliyunManager.h"

@implementation MHStoShopDetailCategoryModel

@end

@implementation MHStoShopDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"img_cover" : [MHOOSImageModel class],
             @"img_details" : [MHOOSImageModel class],
             };
}

@end

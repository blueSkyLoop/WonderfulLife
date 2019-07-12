//
//  MHProvince.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineProvince.h"
@implementation MHMineProvince

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"cityList": [MHMineCity class]
             };
}
@end

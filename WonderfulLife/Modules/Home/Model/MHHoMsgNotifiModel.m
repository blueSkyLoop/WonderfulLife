//
//  MHHoMsgNotifiModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoMsgNotifiModel.h"
@class MHExtData,MHData;
@implementation MHHoMsgNotifiModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"ext_data": [MHExtData class]
             };
}

@end


@implementation MHExtData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"data": [MHData class]
             };
}

@end

@implementation MHData


@end

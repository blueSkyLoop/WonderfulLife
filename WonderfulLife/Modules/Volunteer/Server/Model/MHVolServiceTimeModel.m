//
//  MHVolServiceTimeModel.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolServiceTimeModel.h"
@class MHVolServiceTimePerMonth , MHVolServiceTimePerMonthDetail;
@implementation MHVolServiceTimeModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"attendance_records": [MHVolServiceTimePerMonth class]
             };
}

@end

@implementation MHVolServiceTimePerMonth

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"attendance_list": [MHVolServiceTimePerMonthDetail class]
             };
}


@end

@implementation MHVolServiceTimePerMonthDetail
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"service_date": [NSDate class]
             };
}
@end

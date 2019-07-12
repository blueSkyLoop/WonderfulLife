//
//  MHHoPayDetailsModel.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoPayDetailsModel.h"

@implementation MHHoPayDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list" : [MHHoPayExpensesModel class]
             };
}
@end

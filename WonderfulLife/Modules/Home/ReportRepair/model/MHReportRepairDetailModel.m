//
//  MHReportRepairDetailModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairDetailModel.h"

@implementation MHReportRepairInforModel


@end

@implementation MHReportRepairLogModel


@end

@implementation MHReportRepairCategoryModel


@end

@implementation MHReportRepairDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"img_info_dtos" : [MHReportRepairInforModel class],
             @"repair_log_app_vos" : [MHReportRepairLogModel class],
             @"repairment_category_vos" : [MHReportRepairCategoryModel class]
             };
}

@end

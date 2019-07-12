//
//  MHMineMerFinModel.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerFinModel.h"
@class MHMineMerFin_record,MHMineMerFin_record_list;
@implementation MHMineMerFinModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"finance_record_list": [MHMineMerFin_record_list class]
             };
}

@end


@implementation MHMineMerFin_record_list

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"list": [MHMineMerFin_record class]
             };
}

@end



@implementation MHMineMerFin_record



@end

//
//  MHVoSerIntegralDetailsModel.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerIntegralDetailsModel.h"
@class MHVolunteerScorePerMonth,MHVolunteerScoreRecord;
@implementation MHVoSerIntegralDetailsModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"details": [MHVolunteerScorePerMonth class]
             };
}

@end


@implementation MHVolunteerScorePerMonth

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"records": [MHVolunteerScoreRecord class]
             };
}

@end

@implementation MHVolunteerScoreRecord

@end

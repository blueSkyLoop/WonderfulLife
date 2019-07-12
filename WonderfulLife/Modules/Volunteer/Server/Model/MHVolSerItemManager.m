//
//  MHVolSerItemManager.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerItemManager.h"
#import "MHVolActiveModel.h"
@implementation MHVolSerItemManager

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"activity_list": [MHVolActiveModel class]
             };
}

@end

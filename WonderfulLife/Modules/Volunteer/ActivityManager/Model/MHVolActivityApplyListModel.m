//
//  MHVolActivityApplyListModel.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityApplyListModel.h"
@class MHVolActivityApplyCrew;
@implementation MHVolActivityApplyListModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{ @"applied":[MHVolActivityApplyCrew class],
              @"not_apply":[MHVolActivityApplyCrew class]
              };
}

@end


@implementation MHVolActivityApplyCrew


@end

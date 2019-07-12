//
//  MHReportRepairNewModel.m
//  WonderfulLife
//
//  Created by zz on 17/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairNewModel.h"

@implementation MHReportRepairNewModel

static MHReportRepairNewModel *class;
static dispatch_once_t onceToken;

+ (instancetype)share {
    dispatch_once(&onceToken, ^{
        class = [[MHReportRepairNewModel alloc]init];
        class.images = [NSMutableArray array];
    });
    return class;
}

+ (void)clear{
    onceToken = 0;
    class = nil;
}
@end

//
//  MHUnpayModel.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHUnpayModel.h"

@implementation MHUnpayModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [MHUnpaySubjectModel class]};
}

@end

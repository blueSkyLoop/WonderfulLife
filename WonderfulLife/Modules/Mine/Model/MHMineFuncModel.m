//
//  MHMineFuncModel.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineFuncModel.h"
#import "MHAreaManager.h"
@implementation MHMineFuncModel

+ (NSArray *)mineFuncs {
    
    MHMineFuncModel *m1 = [MHMineFuncModel new];
    m1.title = @"爱心积分";
    m1.type = MHMineFuncModelType_LovePoints ;
    
    MHMineFuncModel *m2 = [MHMineFuncModel new];
    m2.title = @"我的房间";
    m2.type = MHMineFuncModelType_Community ;
    
    MHMineFuncModel *m3 = [MHMineFuncModel new];
    m3.title = @"周边商户订单";
    m3.type = MHMineFuncModelType_Order ;
    
    MHMineFuncModel *m4 = [MHMineFuncModel new];
    m4.title = @"我是商家";
    m4.type = MHMineFuncModelType_Merchant ;
    
    MHMineFuncModel *m5 = [MHMineFuncModel new];
    m5.title = @"积分二维码";
    m5.type = MHMineFuncModelType_IntQrCode ;
    
    MHMineFuncModel *m6 = [MHMineFuncModel new];
    m6.title = @"个人设置";
    m6.type = MHMineFuncModelType_Setting ;
    
    
    
    BOOL hasAreaPermissions = [[MHAreaManager sharedManager] is_enable_mall_merchant];
    BOOL is_enable_property = [[MHUserInfoManager sharedManager] is_enable_property];

    NSMutableArray *array = @[m1,m2,m3,m4,m5,m6].mutableCopy;
    // 11.29 需求变更，当切换到没有商城的小区时，周边商户订单、我是商家都不用隐藏 by Lo
//    if (hasAreaPermissions == NO) {
//        [array removeObject:m4];
//    }
    if (is_enable_property == NO) { // 该小区不支持物业服务则不显示 我的房间
        //[array removeObject:m2];
    }
    return array.copy;
}

@end

//
//  MHStoreGoodsDetailModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsDetailModel.h"

@implementation MHStoreGoodsDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"img_list" : [MHStoreGoodsImageModel class],
             @"img_cover":[MHStoreGoodsImageModel class]};
}

//- (NSString *)distance{
//    if(!_distance){
//        
//        double adistance = [MHStoreGoodsHandler distanceBetweenOrderByOneLat:[MHStoreGoodsHandler shareManager].current_gps_lat oneLng:[MHStoreGoodsHandler shareManager].current_gps_lng otherLat:self.gps_lat otherLng:self.gps_lng];
//        if(adistance){
//            _distance = [NSString stringWithFormat:@"%.2fkm",adistance / 10000];
//        }
//        
//    }
//    return _distance;
//}

@end

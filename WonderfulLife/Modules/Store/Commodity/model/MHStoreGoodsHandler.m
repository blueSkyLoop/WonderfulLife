//
//  MHStoreGoodsHandler.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsHandler.h"
#import <CoreLocation/CoreLocation.h>

static MHStoreGoodsHandler *instance;

@implementation MHStoreGoodsHandler

+ (MHStoreGoodsHandler *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MHStoreGoodsHandler alloc] init];
    });
    return instance;
    
}

//计算两个经纬度的距离
+(double)distanceBetweenOrderByOneLat:(double)oneLat oneLng:(double)oneLng otherLat:(double)otherLat otherLng:(double)otherLng{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:oneLat longitude:oneLng];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:otherLat longitude:otherLng];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
}

//将角度转为弧度
+ (float)radians:(float)degrees{
    return (degrees*M_PI)/180.0;
}

//根据经纬度换算出直线距离
+ (float)getDistance:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2
{
    //地球半径
    int R = 6378137;
    //将角度转为弧度
    float radLat1 = [self radians:lat1];
    float radLat2 = [self radians:lat2];
    float radLng1 = [self radians:lng1];
    float radLng2 = [self radians:lng2];
    //结果
    float s = acos(cos(radLat1)*cos(radLat2)*cos(radLng1-radLng2)+sin(radLat1)*sin(radLat2))*R;
    //精度
    s = round(s* 10000)/10000;
    return  round(s);
}

@end

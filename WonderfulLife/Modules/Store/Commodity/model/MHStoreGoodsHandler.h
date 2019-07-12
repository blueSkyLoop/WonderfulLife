//
//  MHStoreGoodsHandler.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStoreGoodsHandler : NSObject

//经度,当前定位出来的
@property (nonatomic,assign)double current_gps_lng;
//纬度，当前定位出来的
@property (nonatomic,assign)double current_gps_lat;

//申请志愿者标记
@property (nonatomic,assign)BOOL volunteerApplyFalg;

//未开定位信息提示标识，如果已经开了定位，则为YES，或者提示过一次了，也会是YES
@property (nonatomic,assign)BOOL locationUnabelSuggestFlag;


//注册志愿者成功之后要跳转的类名
@property (nonatomic,copy)NSString *registVolunteerClassName;

+ (MHStoreGoodsHandler *)shareManager;

//计算两个经纬度的距离
+(double)distanceBetweenOrderByOneLat:(double)oneLat oneLng:(double)oneLng otherLat:(double)otherLat otherLng:(double)otherLng;

@end

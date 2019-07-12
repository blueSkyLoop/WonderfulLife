//
//  JFMapLocationModel.h
//  JFCommunityCenter
//
//  Created by hanl on 2017/5/5.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMapPOI,CLLocation;
@interface JFMapLocationModel : NSObject

/**
 *  位置名称
 */
@property (copy,nonatomic) NSString *locationName;

/**
 *  位置信息
 */
@property (copy,nonatomic) NSString *locationMessage;

/**
 *  纬度
 */
@property (assign,nonatomic) double latitude;

/**
 *  经度
 */
@property (assign,nonatomic) double longitude;

/**
 * 位置:由经纬度转换而来
 */
@property (strong,nonatomic) CLLocation *location;

//MARK - poi转为自用model
+ (instancetype)modelWithAMapPOI:(AMapPOI *)poi;

//MARK - 判断两个位置的距离
- (double)distanceFromLocation:(JFMapLocationModel *)locationModel;
@end

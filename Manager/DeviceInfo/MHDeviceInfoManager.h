//
//  MHDeviceInfoManager.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHDeviceInfoManager : NSObject
/**
 *  获取设备UUID
 */
+ (NSString*)deviceUUIDString;


/**
 *  获取设备型号  iphone 5s等等
 */
+ (NSString*)deviceVersion ;

/**
 *  获取操作系统版本号  ios9等等
 */
+ (NSString *)deviceSystemVersion;

/** 
 获取app版本号
 */
+ (NSString *)appVersion;

/** 
 获取接口规定的信息
 */
+ (NSDictionary *)getDeviceInfos;
@end

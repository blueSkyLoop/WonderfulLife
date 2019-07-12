//
//  MHMineRequestHandler.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHOOSImageModel;
@interface MHMineRequestHandler : NSObject

+ (void)postProvinceCitiesSuccess:(void (^)(NSDictionary *data))success  Failure:(void (^)(NSString *errmsg))failure;

+ (void)postReviseNativeNativeProvinceID:(NSNumber *)native_province_id NativeCityID:(NSNumber *)native_city_id Success:(void (^)(NSDictionary *data))success  Failure:(void (^)(NSString *errmsg))failure;

+ (void)postReviseNickName:(NSString *)nickname Success:(void (^)(NSDictionary *data))success  Failure:(void (^)(NSString *errmsg))failure;

+ (void)postReviseSex:(NSNumber *)sex Success:(void (^)(NSDictionary *data))success Failure:(void (^)(NSString *errmsg))failure;

+ (void)postReviseCompany:(NSString *)company Success:(void (^)(NSDictionary *data))success Failure:(void (^)(NSString *errmsg))failure;

+ (void)postReviseIntroduce:(NSString *)my_introduce Success:(void (^)(NSDictionary *data))success Failure:(void (^)(NSString *errmsg))failure;

+ (void)postReviseBirthday:(NSString *)birthday Success:(void (^)(NSDictionary *data))success Failure:(void (^)(NSString *errmsg))failure;

+ (void)GetLogOutSuccess:(void (^)(NSDictionary *data))success Failure:(void (^)(NSString *errmsg))failure;

+ (void)postReviseIcon:(MHOOSImageModel *)image Success:(void (^)(NSDictionary *data))success Failure:(void (^)(NSString *errmsg))failure;

+ (void)uptateProfileCallBack:(void (^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

/**
 * @parma   platform : 可选    微博,人人,QQ,微信好友,朋友圈
 *@parma 
 */
+ (void)postShareWithDataId:(NSNumber *)data_id DataType:(NSNumber *)data_type Platform:(NSString *)platform CallBack:(void (^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;
@end





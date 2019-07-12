//
//  MHStoreDataHandler.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStoreDataHandler : NSObject

/** 商城首页 */
+ (void)postMallMainWithCommunityID:(NSNumber *)community_id GPSLng:(NSString *)gsp_lng GPSLat:(NSString *)gps_lat Page:(NSNumber *)page CallBack:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

/** 商店详情 */
+ (void)postMallMerchantGetMerchantID:(NSNumber *)merchant_id Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude CallBack:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

/** 商城搜索 */
+ (void)postMallSearchWithKeyword:(NSString *)keyword CommunityID:(NSNumber *)community_id Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude CallBack:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

/** 商城分类列表 */
+ (void)postMallMerchantCategoryList:(NSNumber *)community_id CallBack:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

/** 分类商家列表 */
+ (void)postMallMerchantByCategorylistWithCategoryID:(NSNumber *)category_id Page:(NSNumber *)page Longitude:(NSString *)gps_lng Latitude:(NSString *)gps_lat CallBack:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

/** 查看更多商品 */
+ (void)postMallMerchantRecommendListWithCommunityID:(NSNumber *)community_id GPSLng:(NSString *)gps_lng GPSLat:(NSString *)gps_lat Page:(NSNumber *)page CallBack:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

/** 商家详情商品列表 */
+ (void)postMallMerchantCouponGetMerchantID:(NSNumber *)merchant_id Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude CallBack:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

/** 搜索更多商家 */
+ (void)postMallMerchantSearchWithCommunityID:(NSNumber *)community_id Keyword:(NSString *)keyword Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude Page:(NSNumber *)page CallBack:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;
@end





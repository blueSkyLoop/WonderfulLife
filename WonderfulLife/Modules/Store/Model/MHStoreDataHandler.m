//
//  MHStoreDataHandler.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreDataHandler.h"
#import "MHNetworking.h"

@implementation MHStoreDataHandler

+ (void)postMallMainWithCommunityID:(NSNumber *)community_id GPSLng:(NSString *)gsp_lng GPSLat:(NSString *)gps_lat Page:(NSNumber *)page CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (community_id) {
        params[@"community_id"] = community_id;
    }
    if (gsp_lng) {
        params[@"gps_lng"] = gsp_lng;
        params[@"gps_lat"] = gps_lat;
    }
    if (page) {
        params[@"page"] = page;
    }
    [[MHNetworking shareNetworking] post:@"mall/main" params:params success:^(id data) {
        callback(YES, data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postMallMerchantGetMerchantID:(NSNumber *)merchant_id Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (longitude) {
        params[@"longitude"] = longitude;
        params[@"latitude"] = latitude;
    }
    params[@"merchant_id"] = merchant_id;
    
    [[MHNetworking shareNetworking] post:@"mall/merchant/get" params:params success:^(id data) {
        callback(YES, data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postMallSearchWithKeyword:(NSString *)keyword CommunityID:(NSNumber *)community_id Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (keyword) {
        params[@"keyword"] = keyword;
    }
    params[@"community_id"] = community_id ? : @10086;
    if (longitude) {
        params[@"longitude"] = longitude;
        params[@"latitude"] = latitude;
    }
    [[MHNetworking shareNetworking] post:@"mall/search" params:params success:^(id data) {
        callback(YES, data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postMallMerchantCategoryList:(NSNumber *)community_id CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (community_id) {
        params[@"community_id"] = community_id;
    }
    [[MHNetworking shareNetworking] post:@"mall/merchant/category/list" params:params success:^(id data) {
        callback(YES, data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postMallMerchantRecommendListWithCommunityID:(NSNumber *)community_id GPSLng:(NSString *)gps_lng GPSLat:(NSString *)gps_lat Page:(NSNumber *)page CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (community_id) {
        params[@"community_id"] = community_id;
    }
    if (gps_lat) {
        params[@"gps_lat"] = gps_lat;
        params[@"gps_lng"] = gps_lng;
    }
    if (page) {
        params[@"page"] = page;
    }
    [[MHNetworking shareNetworking] post:@"mall/merchant/recommend/list" params:params success:^(id data) {
        callback(YES, data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postMallMerchantByCategorylistWithCategoryID:(NSNumber *)category_id Page:(NSNumber *)page Longitude:(NSString *)gps_lng Latitude:(NSString *)gps_lat CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (category_id) {
        params[@"category_id"] = category_id;
    }
    if (page) {
        params[@"page"] = page;
    }
    if (gps_lng) {
        params[@"gps_lng"] = gps_lng;
        params[@"gps_lat"] = gps_lat;
    }
    
    [[MHNetworking shareNetworking] post:@"mall/merchant/by-category/list" params:params success:^(id data) {
        callback(YES, data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postMallMerchantCouponGetMerchantID:(NSNumber *)merchant_id Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merchant_id"] = merchant_id;
    if (longitude) {
        params[@"longitude"] = longitude;
        params[@"latitude"] = latitude;
    }
    [[MHNetworking shareNetworking] post:@"mall/merchant/coupon/get" params:params success:^(id data) {
        callback(YES, data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
    

}

+ (void)postMallMerchantSearchWithCommunityID:(NSNumber *)community_id Keyword:(NSString *)keyword Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude Page:(NSNumber *)page CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"community_id"] = community_id ? : @10086;
    if (longitude) {
        params[@"longitude"] = longitude;
        params[@"latitude"] = latitude;
    }
    if (keyword) {
        params[@"keyword"] = keyword;
    }
    if (page) {
        params[@"page"] = page;
    }
    [[MHNetworking shareNetworking] post:@"mall/merchant/search" params:params success:^(id data) {
        callback(YES, data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}
@end

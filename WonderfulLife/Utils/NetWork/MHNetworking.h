//
//  MHRequest.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHNetworking : NSObject

#pragma mark - 单例
+(MHNetworking *)shareNetworking;

- (void)setupConfig;

#pragma mark - GET
/** 普通请求*/
- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(NSDictionary *) params
                      success:(void (^)(id data))success
                      failure:(void (^)(NSString *errmsg, NSInteger errcode))failure;
/** 用于上传图片*/
- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(NSDictionary *) params
                     progress:(void(^)(NSProgress * uploadProgress))progress
                      success:(void (^)(id data))success
                      failure:(void (^)(NSString *errmsg, NSInteger errcode))failure;


#pragma mark - POST
/** 普通请求*/
- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                       success:(void (^)(id data))success
                       failure:(void (^)(NSString *errmsg, NSInteger errcode))failure;
/** 用于上传图片*/
- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                      progress:(void(^)(NSProgress * uploadProgress))progress
                       success:(void (^)(id data))success
                       failure:(void (^)(NSString *errmsg, NSInteger errcode))failure;

#pragma mark - 网络监听
/** 开始监听网络变化 */
- (void)startMonitoring;

/** 停止监听网络状态 */
- (void)stopMonitoring;

/** 是否有网 */
- (BOOL)isReachable;

/** 是否Wifi */
- (BOOL)isWifi;

/** 是否2G|3G|4G */
- (BOOL)isWWAN;

- (NSDictionary *)builtInParams:(NSDictionary *)originParams;
/**
 0	 	 	表示成功，没有异常可处理
 -1	系统异常	 	跟接口实现人员协商
 -2	参数丢失	 	跟接口实现人员协商
 -3	参数错误	 	检查接口参数或跟接口实现人员协商
 -4	请登录后操作	 	检查是否已经登录
 -8	HTTP调用方式错误,请以上传文件方式调用	 	检查HTTP 是否用上传文件方式请求接口
 1000001	版本过低	返回 CheckUpdate 的数据	系统版本过低
 2000001	登录身份验证失败,请重新登录	 	token失效（包括超时)
 */



@end

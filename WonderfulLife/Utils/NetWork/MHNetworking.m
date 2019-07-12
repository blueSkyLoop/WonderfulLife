//
//  MHRequest.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHNetworking.h"
#import "AFNetworking.h"
#import "MHConstSDKConfig.h"
#import "MHConst.h"
#import "NSObject+isNull.h"
#import "MHDeviceInfoManager.h"

#import "MHTabBarControllerManager.h"
#import "MHAlertView.h"
#if DEBUG
#import "MHChooseUrlModel.h"
#endif

//超时时间
static const NSTimeInterval  kTimeoutInterval = 30;

@implementation MHNetworking{
     AFHTTPSessionManager *_manager;
    //设备参数
    NSDictionary *_deviceDict;
}

+ (MHNetworking *)shareNetworking{
    static MHNetworking *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[MHNetworking alloc] init];
        [request setupConfig];
    });
    return request;
}

/** 
 配置
 */
- (void)setupConfig {
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest = kTimeoutInterval;
     _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] sessionConfiguration:sessionConfiguration];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",
                                                          @"text/plain",
                                                          @"application/json",nil];
    [_manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"app"];
    [_manager.requestSerializer setTimeoutInterval: kTimeoutInterval];
    
    _deviceDict = [MHDeviceInfoManager getDeviceInfos];
}


/**
 内置参数 如token等
 */
- (NSDictionary *)builtInParams:(NSDictionary *)originParams {
     NSMutableDictionary * dictm = [NSMutableDictionary dictionaryWithDictionary:originParams];
    //添加必要的参数
    [dictm addEntriesFromDictionary:_deviceDict];
    //get token
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey];
    if (![NSObject isNull:token]) [dictm setValue:token forKey:@"token"];
    NSLog(@"pramas:%@",dictm);
    return dictm.copy;
}


#pragma mark - Get
- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(NSDictionary *) params
                      success:(void (^)(id data))success
                      failure:(void (^)(NSString *errmsg, NSInteger errcode))failure
{
    return [self get:url params:params progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(NSDictionary *) params
                     progress:(void(^)(NSProgress * uploadProgress))progress
                      success:(void (^)(id data))success
                      failure:(void (^)(NSString *errmsg, NSInteger errcode))failure
{
   
    params = [self builtInParams:params];
    return [_manager GET:url parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
#if DEBUG
NSLog(@"%@",url);      
NSLog(@"responseObject:%@",responseObject);
#endif
        
        NSDictionary *responseDict = responseObject;
        id data = responseDict[@"data"];
        NSString *errmsg = responseDict[@"errmsg"];
        NSNumber *errcodeNum = responseDict[@"errcode"];
        NSInteger errcode = [errcodeNum integerValue];
        
        if (errcode == 0) {
            success(data);
        } else if (errcode == -4){
           failure(errmsg, errcode);
        } else if (errcode < 0){
            failure(errmsg, errcode);
        } else if (errcode == 1000001){
            // 强制更新
            failure(errmsg, errcode);
            BOOL force_update = [data[@"force_update"] boolValue];
            if (force_update) {
                [MHAlertView showVersionAlertViewMessage:data[@"update_content"] sureHandler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data[@"update_url"]]];
                }];
            }
        } else if (errcode == 2000001){
            failure(errmsg, errcode);
            
            UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
            MHTabBarControllerManager *tabBarController = [[MHTabBarControllerManager alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
            if(controller){
                [controller.view removeFromSuperview];
                controller = nil;
            }
            
            // 强制挤线，需要重新登录
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginAgainNotification object:nil userInfo:@{@"errmsg": errmsg}];

        } else {
           failure(errmsg, errcode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(kErrorMsg, -9527);
    }];
}

/*-------------------------This is a line without dream-----------------------------*/


#pragma mark - Post
- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                       success:(void (^)(id data))success
                       failure:(void (^)(NSString *errmsg, NSInteger errcode))failure
{
    return [self post:url params:params progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                      progress:(void(^)(NSProgress * uploadProgress))progress
                       success:(void (^)(id data))success
                       failure:(void (^)(NSString *errmsg, NSInteger errcode))failure
{
   
    params = [self builtInParams:params];
    return [_manager POST:url parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if DEBUG
        NSLog(@"%@",url);
        NSLog(@"responseObject:%@",responseObject);
#endif
        NSDictionary *responseDict = responseObject;
        id data = responseDict[@"data"];
        NSString *errmsg = responseDict[@"errmsg"];
        NSNumber *errcodeNum = responseDict[@"errcode"];
        NSInteger errcode = [errcodeNum integerValue];
        
        if (errcode == 0) {
            success(data);
        } else if (errcode == -4){
            failure(errmsg, errcode);
        } else if (errcode < 0){
            failure(errmsg, errcode);
        } else if (errcode == 1000001){
            // 强制更新
            failure(errmsg, errcode);
            BOOL force_update = [data[@"force_update"] boolValue];
            if (force_update) {
                [MHAlertView showVersionAlertViewMessage:data[@"update_content"] sureHandler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data[@"update_url"]]];
                }];             }
        } else if (errcode == 2000001){
            failure(errmsg, errcode);
            UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
            MHTabBarControllerManager *tabBarController = [[MHTabBarControllerManager alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
            if(controller){
                [controller.view removeFromSuperview];
                controller = nil;
            }
            
            // 强制挤线，需要重新登录
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginAgainNotification object:nil userInfo:@{@"errmsg": errmsg}];

        } else {
           failure(errmsg, errcode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       failure(kErrorMsg, -9527);
    }];
    
}

/*-------------------------This is a line without dream-----------------------------*/

#pragma mark - 网络监听
/** 开始监听网络变化 */
- (void)startMonitoring
{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //发出网络更改通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:[NSNumber numberWithInt:status]];
    }];
    [reachabilityManager startMonitoring];
}
/** 停止监听网络状态 */
- (void)stopMonitoring{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

/** 是否有网 */
- (BOOL)isReachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

/** 是否Wifi */
- (BOOL)isWifi {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

/** 是否2G|3G|4G */
- (BOOL)isWWAN {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}






@end

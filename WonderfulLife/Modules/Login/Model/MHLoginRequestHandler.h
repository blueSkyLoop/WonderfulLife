//
//  MHLoginRequestHandler.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHAliyunManager.h"
@class MHCommunityModel;
@interface MHLoginRequestHandler : NSObject

/**
 *  登录
 *
 *  @param phone   <#phone description#>
 *  @param code    <#code description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)postPhone:(NSString *)phone
             code:(NSString *)code
          success:(void(^)(BOOL is_user_exist))success
          failure:(void(^)(NSString *errmsg, NSInteger errcode))failure;


/**
 *  热门城市
 *  @param success 热门城市列表
 */
+ (void)postHotCityListSuccess:(void(^)(NSArray *cities))success
                       failure:(void(^)(NSString *errmsg))failure;

/**
 *  热门小区
 *  @param success 热门小区列表
 */
+ (void)postHotPlotListWithCityName:(NSString *)city_name
                            success:(void(^)(NSArray *plots))success
                            failure:(void(^)(NSString *errmsg))failure;

/**
 *  查询小区
 *  @param success 查询结果列表
 */
+ (void)searchPlotListWithCityName:(NSString *)city_name
                           keyword:(NSString *)keyword
                           page_id:(NSNumber *)page_id
                           success:(void(^)(NSArray *plots))success
                           failure:(void(^)(NSString *errmsg))failure;

/**
 *  服务项目：志愿者服务站城市列表
 *
 *  @parma   city_name、keyword、page_id
 */
+  (void)selectServerCommunityWithCityName:(NSString *)city_name
                                   keyword:(NSString *)keyword
                                   page:(NSNumber *)page
                                   success:(void(^)(NSArray *plots))success
                                   failure:(void(^)(NSString *errmsg))failure;

/**
 *  注册
 *
 *  @param phone   电话号码
 *  @param code    <#code description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)postRegisterPhone:(NSString *)phone code:(NSString *)code CommunityID:(NSNumber *)community_id success:(void(^)())success failure:(void(^)(NSString *errmsg, NSInteger errcode))failure;

/**
 *  发送登录短信验证码
 *
 *  @param phone   <#phone description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)requestGetVaildateCodeWithPhone:(NSString *)phone
                       success:(void(^)())success
                       failure:(void(^)(NSString *errmsg))failure;

/**
 *  (自动登录) 刷新token
 *
 *  @param push_regid String	可选	 	ios 推送regsiter_id
 */
+ (void)getRefreshTokenWithPushId:(NSString *)push_regid;

/** 
 测试专用 设置验证码
 */
+ (void)requestSetVaildateCodeWithPhone:(NSString *)phone
                       success:(void(^)(NSString *code))success
                       failure:(void(^)())failure;

+ (void)dataPerfectWithName:(NSString *)nickname Sex:(NSString *)sex Birthday:(NSString *)birthday Image:(MHOOSImageModel *)image success:(void(^)())success failure:(void(^)(NSString *errmsg))failure;


+ (void)postVolunteerCountSuccess:(void(^)(NSInteger head_count))success failure:(void(^)(NSString *errmsg))failure;


+ (void)searchHotListWithCityName:(NSString *)city_name
                          keyword:(NSString *)keyword
                          page_id:(NSNumber *)page_id
                          success:(void(^)(NSArray *plots))success
                          failure:(void(^)(NSString *errmsg))failure;

+ (void)checkTheApplicationNeedsToUpdate:(void (^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;


+ (void)communitySwitchWithCommunity:(MHCommunityModel *)to_community success:(void(^)(BOOL success))isSuccess failure:(void(^)(NSString *errmsg))failure;


+ (void)checkTheRoomIsExistWithRoomID:(id)roomID success:(void(^)())success failure:(void(^)(NSString *errmsg))failure;
@end






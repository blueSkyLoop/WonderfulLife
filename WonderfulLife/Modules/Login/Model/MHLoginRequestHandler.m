//
//  MHLoginRequestHandler.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHLoginRequestHandler.h"
#import "MHNetworking.h"

#import "MHDeviceInfoManager.h"
#import "MHUserInfoManager.h"
#import "MHAreaManager.h"

#import "MHHUDManager.h"

#import "MHConst.h"
#import <NSObject+YYModel.h>
#import "MHCommunityModel.h"
#import "MHCityModel.h"
#import "MHWeakStrongDefine.h"



@implementation MHLoginRequestHandler
+ (void)postPhone:(NSString *)phone
             code:(NSString *)code
          success:(void(^)(BOOL is_user_exist))success
          failure:(void(^)(NSString *errmsg, NSInteger errcode))failure
{
    //添加设备信息参数
    NSMutableDictionary *dictm = [NSMutableDictionary dictionaryWithDictionary:[MHDeviceInfoManager getDeviceInfos]];
    [dictm setValue:phone forKey:@"phone"];
    [dictm setValue:code forKey:@"sms_code"];
    
    [[MHNetworking shareNetworking] post:@"account/login"
                                  params:dictm.copy
                                 success:^(NSDictionary * data)
     {
         //解析并归档
         [[MHUserInfoManager sharedManager] analyzingData:data];
         [[MHAreaManager sharedManager] analyzingData:data];
         BOOL exist = ({
             NSNumber *i = data[@"is_user_exist"];
             i.integerValue == 1 ? ({
                 //发送通知，更新志愿者首页界面
                 [[NSNotificationCenter defaultCenter] postNotificationName:kReplaceViewControllerNotification object:nil ];
                 // Lo  2017.7.30  刷新首页界面数据
                 [[NSNotificationCenter defaultCenter] postNotificationName:kReloadHomeControllerDataNotification object:nil];
                 YES;
             }) : NO;
         });
         success(exist);
     } failure:^(NSString *errmsg, NSInteger errcode)
     {
         failure(errmsg, errcode);
     }];
}

+  (void)searchPlotListWithCityName:(NSString *)city_name
                            keyword:(NSString *)keyword
                            page_id:(NSNumber *)page_id
                            success:(void(^)(NSArray *plots))success
                            failure:(void(^)(NSString *errmsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey];
    if (city_name) dic[@"city_name"] = city_name;
    if (keyword) dic[@"keyword"] = keyword;
    if (page_id) dic[@"page_id"] = page_id;
    [[MHNetworking shareNetworking] post:@"community/list" params:[NSDictionary dictionaryWithDictionary:dic] success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHCommunityModel class] json:data];
        success(array);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


+ (void)searchHotListWithCityName:(NSString *)city_name
                          keyword:(NSString *)keyword
                          page_id:(NSNumber *)page_id
                          success:(void(^)(NSArray *plots))success
                          failure:(void(^)(NSString *errmsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey];
    if (city_name) dic[@"city_name"] = city_name;
    if (keyword) dic[@"keyword"] = keyword;
    if (page_id) dic[@"page_id"] = page_id;
    [[MHNetworking shareNetworking] post:@"community/hot" params:[NSDictionary dictionaryWithDictionary:dic] success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHCommunityModel class] json:data];
        success(array);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
    
}

+  (void)selectServerCommunityWithCityName:(NSString *)city_name
                                   keyword:(NSString *)keyword
                                      page:(NSNumber *)page
                                   success:(void(^)(NSArray *plots))success
                                   failure:(void(^)(NSString *errmsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey];
    if (city_name) dic[@"city_name"] = city_name;
    if (keyword) dic[@"keyword"] = keyword;
    if (page) dic[@"page"] = page;
    [[MHNetworking shareNetworking] post:@"community/selectServerCommunity" params:[NSDictionary dictionaryWithDictionary:dic] success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHCommunityModel class] json:data[@"list"]];
        success(array);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postHotPlotListWithCityName:(NSString *)city_name
                            success:(void(^)(NSArray *plots))success
                            failure:(void(^)(NSString *errmsg))failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:kTokenKey];
    if (city_name) dic[@"city_name"] = city_name;
    [[MHNetworking shareNetworking] post:@"community/hot" params:[NSDictionary dictionaryWithDictionary:dic] success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHCommunityModel class] json:data];
        success(array);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postHotCityListSuccess:(void(^)(NSArray *cities))success
                       failure:(void(^)(NSString *errmsg))failure {
    [[MHNetworking shareNetworking] post:@"hotcity" params:nil success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHCityModel class] json:data];
        success(array);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


+ (void)postRegisterPhone:(NSString *)phone code:(NSString *)code CommunityID:(NSNumber *)community_id success:(void(^)())success failure:(void(^)(NSString *errmsg, NSInteger errcode))failure{
    NSMutableDictionary *dictm = [NSMutableDictionary dictionaryWithDictionary:[MHDeviceInfoManager getDeviceInfos]];
    [dictm setValue:phone forKey:@"phone"];
    [dictm setValue:code forKey:@"smscode"];
    [dictm setValue:community_id forKey:@"community_id"];
    [[MHNetworking shareNetworking] post:@"account/register" params:dictm success:^(id data) {
        //发送通知，更新志愿者首页界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadVolunteerHomePageNotification object:nil userInfo:@{kShowInvitePage: @(NO)}];
        
        BOOL exist = ({
            NSUInteger i = (long)data[@"is_user_exist"];
            i == 1 ? YES : NO;
        });
        if (exist == NO) {
            
        }
        [[MHUserInfoManager sharedManager] analyzingData:data];
        [[MHAreaManager sharedManager] analyzingData:data];
        success();
    } failure:^(NSString *errmsg, NSInteger errcode) {
        [MHHUDManager showErrorText:errmsg];
    }];
}

+ (void)checkTheRoomIsExistWithRoomID:(id)roomID success:(void(^)())success failure:(void(^)(NSString *errmsg))failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"struct_id"] = roomID;
    [[MHNetworking shareNetworking] post:@"struct/myroom/check/audit/status" params:dic success:^(id data) {
        NSInteger autit_status = [data[@"audit_status"] integerValue];
        if (autit_status == 1) {
            success();
        }else{
            [MHHUDManager dismiss];
            [MHHUDManager showErrorText:data[@"toast"]];
        }
    } failure:^(NSString *errmsg, NSInteger errcode) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

+ (void)requestGetVaildateCodeWithPhone:(NSString *)phone
                                success:(void(^)())success
                                failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"phone" : phone};
    [[MHNetworking shareNetworking] get:@"sms/loginsmscode" params:params success:^(id responseObject) {
        success();
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)requestSetVaildateCodeWithPhone:(NSString *)phone
                                success:(void(^)(NSString *code))success
                                failure:(void(^)())failure
{
    u_int32_t code = arc4random_uniform(8999) + 1000;
    NSString *codeStr = [NSString stringWithFormat:@"%d",code];
    
    NSDictionary *params = @{@"phone" : phone,
                             @"smscode" : codeStr};
    [[MHNetworking shareNetworking] get:@"sms/setsmscode" params:params success:^(id responseObject) {
        
        success(codeStr);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure();
    }];
}

+ (void)dataPerfectWithName:(NSString *)nickname Sex:(NSString *)sex Birthday:(NSString *)birthday Image:(MHOOSImageModel *)image success:(void(^)())success failure:(void(^)(NSString *errmsg))failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (nickname.length) {
        dic[@"nickname"] = nickname;
    }
    if ([sex isEqualToString:@"男"]) {
        dic[@"sex"] = @1;
    }else if ([sex isEqualToString:@"女"]){
        dic[@"sex"] = @2;
    }
    if (birthday.length) {
        dic[@"birthday"] = birthday;
    }
    if (image) {
        NSMutableDictionary *UploadImageFile = [NSMutableDictionary dictionary];
        UploadImageFile[@"img_width"] = @(image.width);
        UploadImageFile[@"img_height"] = @(image.height);
        UploadImageFile[@"file_id"] = image.name;
        UploadImageFile[@"file_url"] = image.url;
        dic[@"headphoto"] = [UploadImageFile yy_modelToJSONString];
    }
    
    MHNetworking *net = [MHNetworking shareNetworking];
    MHWeakify(net);
    [[MHNetworking shareNetworking] post:@"account/addinfo" params:dic success:^(NSDictionary *data) {
        [weak_net get:@"my/profile" params:nil success:^(id data) {
            [[MHUserInfoManager sharedManager] analyzingData:data];
            [[MHAreaManager sharedManager] analyzingData:data];
            success();
        } failure:^(NSString *errmsg, NSInteger errcode) {
            failure(errmsg);
        }];
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postVolunteerCountSuccess:(void(^)(NSInteger head_count))success failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteer/headcount" params:nil success:^(NSDictionary *data) {
        success([data[@"head_count"] integerValue]);
        
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


/**
 *  (自动登录) 刷新token
 */
+ (void)getRefreshTokenWithPushId:(NSString *)push_regid
{
    
    if ([MHUserInfoManager sharedManager].isLogin) { // 判断是否有登录再刷新token         
        NSMutableDictionary *dictm = [NSMutableDictionary dictionaryWithDictionary:[MHDeviceInfoManager getDeviceInfos]];
        [[MHNetworking shareNetworking] post:@"account/refreshtoken" params:dictm success:^(NSDictionary *data) {
            //解析并归档
            [[MHUserInfoManager sharedManager] analyzingData:data];
            [[MHAreaManager sharedManager] analyzingData:data];
        } failure:^(NSString *errmsg, NSInteger errcode) {
        }];
    }
}


/**
 检查版本更新
 
 @param callback 接口请求回调
 */
+ (void)checkTheApplicationNeedsToUpdate:(void (^)(BOOL success, NSDictionary *data, NSString *errmsg))callback{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[MHDeviceInfoManager appVersion] forKey:@"app_v"];
    [params setValue:[MHDeviceInfoManager deviceSystemVersion] forKey:@"os_v"];
    
    [params setValue:[MHDeviceInfoManager deviceUUIDString] forKey:@"service_id"];
    [params setValue:@(0) forKey:@"isAction"];
    
    [[MHNetworking shareNetworking]get:@"checkupdate" params:params success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}


+ (void)communitySwitchWithCommunity:(MHCommunityModel *)to_community success:(void(^)(BOOL success))isSuccess failure:(void(^)(NSString *errmsg))failure {
    
    [[MHNetworking shareNetworking]get:@"community/switch" params:@{@"to_community_id":to_community.community_id} success:^(id data) {
        
        [MHLoginRequestHandler getRefreshTokenWithPushId:nil];
        //  把切换的城市数据缓存到本地
        [[MHAreaManager sharedManager] analyzingData:data];
        
        isSuccess(YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

@end




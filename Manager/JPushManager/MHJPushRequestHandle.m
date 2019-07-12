//
//  MHJPushRequestHandle.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHJPushRequestHandle.h"
#import "MHNetworking.h"
#import "JPUSHService.h"
#import "NSObject+isNull.h"

#import "MHHUDManager.h"
#import "MHUserInfoManager.h"
#import "MHVolunteerUserInfo.h"
#import "MHConst.h"
@interface MHJPushRequestHandle()

/**
 *  userId_volunteerId
 */
@property (copy,nonatomic) NSString *userId_volunteerId;

@end

@implementation MHJPushRequestHandle

//jpush/reg
+ (void)JPushReg:(MHJPushRequestHandleBlock)block{
    NSNumber *volId = ![NSObject isNull:[MHVolunteerUserInfo sharedInstance].volunteer_id] ? [MHVolunteerUserInfo sharedInstance].volunteer_id : [MHUserInfoManager sharedManager].volunteer_id ;
    
    [self mhJpush_AliasWithType:MHJPushAliasType_Set volunteer_id:volId completion:^(BOOL success) {
        [self postJpushRequest:@"jpush/reg" completion:nil];
    } failure:^(NSString *errmsg) {
#ifdef DEBUG_MODE
        [MHHUDManager showErrorText:errmsg];
#endif
    }];
}

//jpush/unreg
+ (void)JPushUnReg:(MHJPushRequestHandleBlock)block{
    
    NSNumber *volId = ![NSObject isNull:[MHVolunteerUserInfo sharedInstance].volunteer_id] ? [MHVolunteerUserInfo sharedInstance].volunteer_id : [MHUserInfoManager sharedManager].volunteer_id ;
    
    [self mhJpush_AliasWithType:MHJPushAliasType_Delete volunteer_id:volId completion:^(BOOL success) {
        [self postJpushRequest:@"jpush/unreg" completion:nil];
    } failure:^(NSString *errmsg) {
#ifdef DEBUG_MODE
        [MHHUDManager showErrorText:errmsg];
#endif
    }];
    
}

/** 注册 或 注销 jpush regesterId*/
+ (void)postJpushRequest:(NSString *)url completion:(MHJPushRequestHandleBlock)block{
    NSString *jpushRegId = [JPUSHService registrationID];
    [MHHUDManager show];
    if (![NSObject isNull:jpushRegId]) {
        [[MHNetworking shareNetworking] post:url params:@{@"regesterId":jpushRegId} success:^(id data) {
            //        block (YES , nil);
            [MHHUDManager dismiss];
        } failure:^(NSString *errmsg, NSInteger errcode) {
            //        block (NO , errmsg);
            [MHHUDManager dismiss];
        }];
    }
}

+ (void)mhJpush_AliasWithType:(MHJPushAliasType)type volunteer_id:(NSNumber *)volunteer_id completion:(void (^)(BOOL success))completion  failure:(void (^)(NSString *errmsg))failure {
    
    NSString *userId =  [[MHUserInfoManager sharedManager].user_id stringValue];
    NSString *volId  =  [volunteer_id stringValue];
    NSString *userId_volunteerId = [NSString stringWithFormat:@"%@_%@",userId,volId];
    
    if (type == MHJPushAliasType_Set && ![NSObject isNull:[MHUserInfoManager sharedManager].user_id] && ![NSObject isNull:volId]) { // 极光推送注册 别名设置
        
        // seq 请求时传入的序列号，会在回调时原样返回  , iResCode : 成功为0
        [JPUSHService setAlias:userId_volunteerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if(iResCode == 0){
                completion(YES);
            }else{
                failure([NSString stringWithFormat:@"%ld",iResCode]);
            }
        } seq:0];
        
    }else if (type == MHJPushAliasType_Delete) { // 删除别名
        
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if(iResCode == 0){
                completion(YES);
            }else{
                failure([NSString stringWithFormat:@"%ld",iResCode]);
            }
        } seq:0];
    }else { // 只用设备号设置
        completion(YES);
    }
}



+ (void)mhJpush_getOffLineWithCompletion:(void (^)(BOOL success))completion
                                 failure:(void (^)(NSString *errmsg))failure{
    [MHHUDManager show];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[JPUSHService registrationID] forKey:@"regesterId"];
    [[MHNetworking shareNetworking] post:@"jpush/getOffLine" params:dic success:^(id data) {
        completion (YES);
        [MHHUDManager dismiss];
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure (errmsg);
        [MHHUDManager dismiss];
    }];
}


@end


//
//  MHCertificationRequestHandler.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//
#import "MHNetworking.h"
#import "MHCertificationRequestHandler.h"

#import "MHNetworking.h"

#import "MHHUDManager.h"
#import "MHConst.h"
#import <YYModel.h>
#import "MHStructAreaModel.h"
#import "MHStructBuildingModel.h"
#import "MHStructUnitModel.h"
#import "MHStructRoomModel.h"


@implementation MHCertificationRequestHandler

+ (void)getVaildateCodeWithPhone:(NSString *)phone
                                success:(void(^)())success
                                failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"mobile_phone" : phone};
    [[MHNetworking shareNetworking] get:@"validate/tenement/sms" params:params success:^(id responseObject) {
        success();
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postCheckVaildateCodeWithPhone:(NSString *)phone
                              structId:(NSNumber *)structId
                                  code:(NSString *)code
                               success:(void (^)(long is_success))success
                               failure:(void (^)(NSString *))failure
{
    NSDictionary *params = @{@"mobile_phone": phone,
                             @"struct_id" : structId,
                             @"code" : code};
    [[MHNetworking shareNetworking] post:@"validate/tenement/sms/check" params:params success:^(id responseObject) {
        success([responseObject[@"is_success"] longValue]);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postUploadBillWithStructId:(NSNumber *)structId
                              imgs:(NSString *)imgs
                           success:(void(^)())success
                           failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"struct_id" : structId,
                             @"imgs" : imgs};
    [[MHNetworking shareNetworking] post:@"validate/tenement/upload/bills" params:params success:^(id responseObject) {
        success();
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postCheckUserWithName:(NSString *)identity_card_name Number:(NSString *)identity_card_number RoomID:(NSNumber *)struct_id SuccessBlock:(void (^)(NSInteger is_validate))successBlock{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"identity_card_name"] = identity_card_name;
    dic[@"identity_card_number"] = identity_card_number;
    dic[@"struct_id"] = struct_id;
    
    [[MHNetworking shareNetworking] post:@"validate/tenement/check/user" params:dic success:^(NSDictionary *data) {
        successBlock([data[@"is_validate"] integerValue]);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        [MHHUDManager showErrorText:errmsg];
    }];
}

+ (void)postAreaWithCommunityID:(NSNumber *)community_id
                       callBack:(MHCiCommunityAreaListBlock)block {
    NSDictionary *dic = @{@"community_id":community_id?community_id:@0};
    
//    struct/area/list2
    [[MHNetworking shareNetworking] post:@"struct/area/list2" params:dic success:^(id data) {
        NSDictionary *dataDic = (NSDictionary *)data;
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHStructAreaModel class] json:[dataDic objectForKey:@"areas"]];
        BOOL has_area = [[dataDic objectForKey:@"has_area"] boolValue];
//        NSArray *array = [NSArray yy_modelArrayWithClass:[MHStructAreaModel class] json:data];
        
        block(array,nil,has_area);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        block(nil,errmsg,NO);
    }];
}

+ (void)postBuildWithCommunityID:(NSNumber *)community_id
                        structId:(NSNumber *)struct_id
                        callBack:(MHCiCommunityAreaListBlock)block {
    NSDictionary *dic = @{@"community_id":community_id,@"struct_id":struct_id};
    [[MHNetworking shareNetworking] post:@"struct/area/building/list" params:dic success:^(NSDictionary *data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHStructBuildingModel class] json:data[@"building_nos"]];
        block(array,nil,YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        block(nil,errmsg,NO);
    }];
}

+ (void)postUnitWithCommunityID:(NSNumber *)community_id
                        structId:(NSNumber *)struct_id
                        callBack:(MHCiCommunityAreaListBlock)block {
    NSDictionary *dic = @{@"community_id":community_id,@"struct_id":struct_id};
    [[MHNetworking shareNetworking] post:@"struct/area/building/unit/list" params:dic success:^(NSDictionary *data) {
//        NSArray *array = [NSArray yy_modelArrayWithClass:[MHStructUnitModel class] json:data[@"units"]];
        NSDictionary *dataDic = (NSDictionary *)data;
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHStructUnitModel class] json:[dataDic objectForKey:@"units"]];
        BOOL has_unit = [[dataDic objectForKey:@"has_unit"] boolValue];
        
        
        block(array,nil,has_unit);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        block(nil,errmsg,NO);
    }];
}

+ (void)postRoomWithCommunityID:(NSNumber *)community_id
                       structId:(NSNumber *)struct_id
                       callBack:(MHCiCommunityAreaListBlock)block {
    NSDictionary *dic = @{@"community_id":community_id,@"struct_id":struct_id};
    [[MHNetworking shareNetworking] post:@"struct/area/building/room/list" params:dic success:^(NSDictionary *data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHStructRoomModel class] json:data[@"building_rooms"]];
        block(array,nil,YES);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        block(nil,errmsg,NO);
    }];
}
@end

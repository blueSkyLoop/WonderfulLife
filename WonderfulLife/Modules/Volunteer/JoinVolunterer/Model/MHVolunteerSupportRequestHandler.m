//
//  MHVolunteerSupportRequestHandler.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolunteerSupportRequestHandler.h"
#import "MHConst.h"
#import "MHNetworking.h"
#import "MHVolunteerSupportModel.h"
#import "MHUserInfoManager.h"

#import <NSObject+YYModel.h>
@implementation MHVolunteerSupportRequestHandler

+ (void)postVolunteerSupportListWithUrl:(NSString *)url params:(id)params request:(void (^)(NSArray<MHVolunteerSupportModel *> *))success failure:(void (^)(NSString *))failure {
    [[MHNetworking shareNetworking] post:url params:params success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHVolunteerSupportModel class] json:data];
        success(array);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postVolunteerSupportListWithUrl:(NSString *)url request:(void (^)(NSArray<MHVolunteerSupportModel *> *))success failure:(void (^)(NSString *))failure{

    [[MHNetworking shareNetworking] post:url params:nil success:^(id data) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[MHVolunteerSupportModel class] json:data];
        success(array);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)uploadCustomHobby:(NSString *)hobby Success:(void (^)(long,NSString *))success failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] post:@"volunteer/tag/create" params:@{@"tag_name":hobby} success:^(NSDictionary *data) {
        success([data[@"tag_id"] longValue],data[@"tag_name"]);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


+ (void)postVolSupportListRepair:(NSString *)support_list success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/support/modify" params:@{@"volunteer_id":[MHUserInfoManager sharedManager].volunteer_id,@"support_list":support_list} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


@end

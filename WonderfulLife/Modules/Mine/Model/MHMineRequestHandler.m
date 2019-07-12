//
//  MHMineRequestHandler.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineRequestHandler.h"
#import "MHNetworking.h"
#import "MHAliyunManager.h"
#import <YYModel.h>
#import "MHUserInfoManager.h"

@implementation MHMineRequestHandler

+ (void)postProvinceCitiesSuccess:(void (^)(NSDictionary *data))success  Failure:(void (^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"my/provincecity" params:nil success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postReviseNativeNativeProvinceID:(NSNumber *)native_province_id NativeCityID:(NSNumber *)native_city_id Success:(void (^)(NSDictionary *data))success  Failure:(void (^)(NSString *errmsg))failure{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"native_province_id"] = native_province_id;
    dic[@"native_city_id"] = native_city_id;
    [[MHNetworking shareNetworking] post:@"my/nativeplace" params:dic success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postReviseNickName:(NSString *)nickname Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] post:@"my/nickname" params:@{@"nickname":nickname} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postReviseSex:(NSNumber *)sex Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] post:@"my/sex" params:@{@"sex":sex} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postReviseCompany:(NSString *)company Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] post:@"my/company" params:@{@"company":company} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postReviseIntroduce:(NSString *)my_introduce Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] post:@"my/myintroduce" params:@{@"my_introduce":my_introduce} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postReviseBirthday:(NSString *)birthday Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] post:@"my/birthday" params:@{@"birthday":birthday} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)GetLogOutSuccess:(void (^)(NSDictionary *))success Failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] get:@"account/logout" params:nil success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postReviseIcon:(MHOOSImageModel *)image Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSString *))failure{
    NSMutableDictionary *UploadImageFile = [NSMutableDictionary dictionary];
    UploadImageFile[@"img_width"] = @(image.width);
    UploadImageFile[@"img_height"] = @(image.height);
    UploadImageFile[@"file_id"] = image.name;
    UploadImageFile[@"file_url"] = image.url;
    [[MHNetworking shareNetworking] get:@"my/headimg" params:UploadImageFile success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)uptateProfileCallBack:(void (^)(BOOL success, NSDictionary *data, NSString *errmsg))callback{
    [[MHNetworking shareNetworking] get:@"my/profile" params:nil success:^(id data) {
        [[MHUserInfoManager sharedManager] analyzingData:data];
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];

}

+ (void)postShareWithDataId:(NSNumber *)data_id DataType:(NSNumber *)data_type Platform:(NSString *)platform CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (platform.length) {
        dic[@"platform"] = platform;
    }
    dic[@"data_id"] = data_id;
    dic[@"data_type"] = data_type;
    [[MHNetworking shareNetworking] post:@"user/share/create2" params:dic success:^(id data) {
        callback(YES ,data, nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO, nil,errmsg);
    }];
}


@end





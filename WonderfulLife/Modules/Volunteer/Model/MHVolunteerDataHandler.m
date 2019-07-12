//
//  MHVolunteerDataHandler.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolunteerDataHandler.h"

#import "MHNetworking.h"
#import <YYModel.h>
#import "MHVolServiceTimeModel.h"
#import "MHVoSerIntegralDetailsModel.h"

@implementation MHVolunteerDataHandler
+ (void)getVolunteerHeadcountSuccess:(void(^)(NSString *count))success
                             failure:(void(^)(NSString *errmsg))failure
{
    [[MHNetworking shareNetworking] get:@"volunteer/headcount"
                                 params:nil
                                success:^(NSDictionary *data)
     {
         NSNumber *count = data[@"head_count"];
         [[NSUserDefaults standardUserDefaults] setObject:count.stringValue forKey:@"volunteerHeadCountKey"];
         success(count.stringValue);
     } failure:^(NSString *errmsg, NSInteger errcode) {
        NSString *count = [[NSUserDefaults standardUserDefaults] objectForKey:@"volunteerHeadCountKey"];
         failure(count);
     }];
}

+ (void)getAttendanceRecordWithType:(NSInteger)type
                             teamId:(NSNumber *)teamId
                               year:(NSInteger)year
                              month:(NSInteger)month
                            success:(void(^)())success
                            failure:(void(^)(NSString *errmsg))failure
{
    //id_type	String	必选	a|t	id所属类型，a 表示服务项目，t 表示服务队
    NSDictionary *params = @{@"id_type": @"t",
                             @"type": @(type),
                             @"id": teamId,
                             @"year": @(year),
                             @"month": @(month)};
    [[MHNetworking shareNetworking] get:@"volunteer/attendance-record/by-team/list"
                                 params:params
                                success:^(NSDictionary *data)
     {
                 success();
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
}

+ (void)postVoCultivateCategoryListSuccess:(void(^)(NSDictionary *data))success
                                   failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteer/training-category/list" params:nil success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postVoCultivateContentCategoryListWithPage:(NSString *)page CategoryID:(NSNumber *)category_id Success:(void(^)(NSDictionary *data))success
                                   failure:(void(^)(NSString *errmsg))failure{
    
    [[MHNetworking shareNetworking] post:@"volunteer/training/list" params:@{@"page":page,@"category_id":category_id} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postVoCultivateContentDetailCategoryListWithArticleID:(NSNumber *)article_id Success:(void(^)(NSDictionary *data))success Failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteer/training/get" params:@{@"article_id":article_id} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}
+ (void)getVolunteerServiceTimeWithDic:(NSDictionary *)dic url:(NSString *)url success:(void(^)(MHVolServiceTimeModel *dataModel))success
                               failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:url params:dic success:^(id data) {
        
        MHVolServiceTimeModel *dataModel = [MHVolServiceTimeModel yy_modelWithJSON:data];
        
        success(dataModel);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)getVoSerIntegralDetails:(NSInteger)type dataDic:(NSMutableDictionary *)dataDic request:(void(^)(MHVoSerIntegralDetailsModel *dataModel))success
                        failure:(void(^)(NSString *errmsg))failure {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (dataDic) {
        dic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    }
    [dic setValue:[NSNumber numberWithInteger:type] forKey:@"score_type"];
    
    [[MHNetworking shareNetworking] post:@"volunteer/score/record/list" params:dic success:^(id data) {
        MHVoSerIntegralDetailsModel *dataModel = [MHVoSerIntegralDetailsModel yy_modelWithJSON:data];
        success(dataModel);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}




+ (void)postVolunteerInfoIdentityValidateWithIdentity:(NSString *)identity_card CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/identity/validate" params:@{@"identity_card":identity_card} success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)getVoSerMyCard:(NSNumber *)volunteerId request:(void(^)(NSDictionary *data))success
               failure:(void(^)(NSString *errmsg))failure{

    
    [[MHNetworking shareNetworking] post:@"volunteerInfo/get" params:@{@"volunteer_id":volunteerId} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-兴趣爱好列表*/
+ (void)getVoSerTheSupportListOfMyCard:(NSNumber *)volunteerId CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/tag/list" params:@{@"volunteer_id":volunteerId} success:^(NSDictionary *data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

/**我的资料卡-我的需要帮助列表*/
+ (void)getVoSerTheHobbyListOfMyCard:(NSNumber *)volunteerId request:(void(^)(NSDictionary *data))success
                             failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/support/list" params:@{@"volunteer_id":volunteerId} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}
/**我的资料卡-修改照片*/
+ (void)postVoSerModifyThePhotoOfMyCard:(id)imgData request:(void(^)(NSDictionary *data))success
                                failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/photo/modify" params:imgData success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-修改身份证*/
+ (void)postVoSerModifyTheIdentifyOfMyCard:(NSNumber *)volunteerId Identity:(NSString *)indentify request:(void(^)(NSDictionary *data))success
                                   failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/identity/modify" params:@{@"volunteer_id":volunteerId,@"identity_card":indentify} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-修改性别*/
+ (void)postVoSerModifyTheSexOfMyCard:(NSNumber *)volunteerId Sex:(NSInteger)sex request:(void(^)(NSDictionary *data))success
                              failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/sex/modify" params:@{@"volunteer_id":volunteerId,@"sex":@(sex)} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-修改生日*/
+ (void)postVoSerModifyTheBirthdayOfMyCard:(NSNumber *)volunteerId Birthday:(NSString *)day request:(void(^)(NSDictionary *data))success
                                   failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/birthday/modify" params:@{@"volunteer_id":volunteerId,@"birthday":day} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-修改手机号码*/
+ (void)postVoSerModifyThePhoneOfMyCard:(NSNumber *)volunteerId Phone:(NSString *)phone request:(void(^)(NSDictionary *data))success
                                failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/phone/modify" params:@{@"volunteer_id":volunteerId,@"phone":phone} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-修改住址*/
+ (void)postVoSerModifyTheAddressOfMyCard:(NSNumber *)volunteerId Address:(id)address request:(void(^)(NSDictionary *data))success
                                  failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/address/modify" params:@{@"volunteer_id":volunteerId,@"address":address} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-修改我的兴趣爱好列表*/
+ (void)postVoSerModifyTheHobbyListOfMyCard:(NSNumber *)volunteerId HobbyArray:(id)hobbyArray request:(void(^)(NSDictionary *data))success
                                    failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/tag/modify" params:@{@"volunteer_id":volunteerId,@"tag_list":hobbyArray} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-修改我的帮助列表*/
+ (void)postVoSerModifyTheSupportListOfMyCard:(NSNumber *)volunteerId SupportArray:(NSArray *)supportArray request:(void(^)(NSDictionary *data))success
                                      failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/support/modify" params:@{@"volunteer_id":volunteerId,@"support_id_list":supportArray} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**我的资料卡-检查身份证号是否已经注册*/
+ (void)postVoSerValidateTheIdentifyOfMyCard:(NSNumber *)volunteerId Identity:(NSString *)indentify request:(void(^)(NSDictionary *data))success
                                     failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteerInfo/identity/validate" params:@{@"volunteer_id":volunteerId,@"identity_card":indentify} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

+ (void)postVolunteerApplyCheckHasRoom:(NSNumber *)community_id Success:(void (^)(NSDictionary *))success Failure:(void (^)(NSString *))failure{
    [[MHNetworking shareNetworking] post:@"volunteer/apply/checkHasRoom" params:@{@"community_id":community_id} success:^(NSDictionary *data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}
@end





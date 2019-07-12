//
//  MHVoServerDataHandler.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoServerRequestDataHandler.h"

#import "MHNetworking.h"
#import <YYModel.h>
#import "MHConst.h"

#import "MHVolunteerServiceMainModel.h"
#import "MHUserInfoManager.h"
#import "MHAliyunManager.h"

#import "MHVolServiceTimeModel.h"
#import "MHVoSerIntegralDetailsModel.h"
#import "MHVolSerAttendanceRecordModel.h"
#import "MHVoServerPageController.h"
#import "MHVolSerReamListModel.h"
#import "MHVolSerReviewModel.h"
#import "MHVolSerReviewApplyDetailModel.h"
#import "MHVolSerReviewDistributeTeamModel.h"
#import "MHVolSerComDetailModel.h"

@implementation MHVoServerRequestDataHandler
+ (void)getServerMainSuccess:(void(^)(MHVolunteerServiceMainModel *model))success
                     failure:(void(^)(NSString *errmsg))failure;
{
    [[MHNetworking shareNetworking] get:@"volunteer/service/main"
                                 params:nil
                                success:^(NSDictionary *data)
     {
         MHVolunteerServiceMainModel *model = [MHVolunteerServiceMainModel yy_modelWithDictionary:data];
         
         //缓存
         NSString *key = [NSString stringWithFormat:@"serviceMainData--%@",[MHUserInfoManager sharedManager].user_id];
         [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
         
         success(model);
     } failure:^(NSString *errmsg, NSInteger errcode) {
         //取缓存
         NSString *key = [NSString stringWithFormat:@"serviceMainData--%@",[MHUserInfoManager sharedManager].user_id];
         NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
         
         if (data) {
             MHVolunteerServiceMainModel *model = [MHVolunteerServiceMainModel yy_modelWithDictionary:data];
             success(model);
         } else {
             failure(errmsg);
         }
     }];
}

+ (void)getVolunteerServiceTime:(void(^)(MHVolServiceTimeModel *dataModel))success
                         failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] post:@"volunteer/activity/time" params:nil success:^(id data) {
        
        MHVolServiceTimeModel *dataModel = [MHVolServiceTimeModel yy_modelWithJSON:data];
        
        success(dataModel);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}


+ (void)getVoSerIntegralDetails:(NSInteger)type request:(void(^)(MHVoSerIntegralDetailsModel *dataModel))success
                        failure:(void(^)(NSString *errmsg))failure {
    NSDictionary *dic = @{@"score_type":[NSNumber numberWithInteger:type]};
    
    [[MHNetworking shareNetworking] post:@"volunteer/score/record/list" params:dic success:^(id data) {
        MHVoSerIntegralDetailsModel *dataModel = [MHVoSerIntegralDetailsModel yy_modelWithJSON:data];
        success(dataModel);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**
 登记考勤|考勤记录 - 选择服务队
 */
+ (void)PostVolunteerAttendanceRecordsTeamListCallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"volunteer/attendance/records/team/list" params:nil success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

/**
 *  登记考勤前选择考勤类型
 */
+ (void)getVolunteervCheckinActivityItemListWithId:(NSNumber *)Id
                                              type:(NSString *)type
                                           Success:(void(^)(NSArray <MHVolSerReamListModel*> *dataSource))success
                                           failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *dic = @{@"id":Id,
                          @"id_type": type};
    
    [[MHNetworking shareNetworking] get:@"volunteer/checkin/activity-item/list" params:dic success:^(id data) {
        NSArray *arrayData = data;
        NSMutableArray *arrayM = @[].mutableCopy;
        [arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MHVolSerReamListModel *model = [MHVolSerReamListModel new];
            NSDictionary *dict = obj;
            model.id = dict[@"activity_item_id"];
            model.name = dict[@"activity_item_name"];
            [arrayM addObject:model];
        }];
        success(arrayM);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
 
}

/**
 *  登记考勤服务队员列表
 */
+ (void)getVolunteervCheckinteamMemberListtWithId:(NSNumber *)Id
                                             type:(NSString *)type
                                          Success:(void(^)(NSArray <MHVolSerReamListModel*> *dataSource))success
                                          failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"id":Id,
                          @"id_type": type};
    
    [[MHNetworking shareNetworking] get:@"volunteer/checkin/team/member/list" params:params success:^(id data) {
        NSArray *arrayData = data;
        NSMutableArray *arrayM = @[].mutableCopy;
        [arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MHVolSerReamListModel *model = [MHVolSerReamListModel new];
            NSDictionary *dict = obj;
            model.id = dict[@"user_id"];
            model.name = dict[@"real_name"];
            model.is_captain = dict[@"is_captain"];
            model.headphoto_s_url = dict[@"headphoto_s_url"];
            model.role_name = dict[@"role_name"];
            model.real_name = dict[@"real_name"];
            [arrayM addObject:model];
        }];
        success(arrayM);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**
 *  登记考勤提交
 *
 *  @param Id                 Long	必选	1	id
 *  @param type               String	必选	a|t	id所属类型，a 表示服务项目，t 表示服务队
 *  @param activity_item_id   Long	必填	1	考勤类型id
 *  @param attendance_date    String	必填	2017-07-07	考勤日期
 *  @param attendance_details String(JSON Array 格式)	必填		考勤数据
 */
+ (void)postVolunteervCheckinSaveWithId:(NSNumber *)Id
                                   type:(NSString *)type
                       activity_item_id:(NSNumber *)activity_item_id
                        attendance_date:(NSString *)attendance_date
                     attendance_details:(NSString *)attendance_details
                                success:(void(^)())success
                                failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"id": Id,
                             @"id_type": type,
                             @"activity_item_id": activity_item_id,
                             @"attendance_date": attendance_date,
                             @"attendance_details": attendance_details
                             };
    
    [[MHNetworking shareNetworking] post:@"volunteer/checkin/save"
                                 params:params
                                success:^(NSDictionary *data)
     {
        success();
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
 
}

/**
 审核人员加入列表
 */
+ (void)getVolunteerApplyListWithType:(NSInteger)type
                                 page:(NSNumber *)page
                              Success:(void(^)(NSArray *dataSource, BOOL hasNext, NSNumber *lastId))success
                              failure:(void(^)(NSString *errmsg))failure
{
   
    NSDictionary *params = @{@"type": @(type),
                             @"page": page ? page : [NSNull null]};
    
    [[MHNetworking shareNetworking] get:@"volunteer/activity/apply/list"
                                 params:params
                                success:^(NSDictionary *data)
     {
         NSNumber *number = data[@"has_next"];
         BOOL hasNext = [number isEqualToNumber:@1] ? YES : NO;
         NSArray *dataSource = [NSArray yy_modelArrayWithClass:[MHVolSerReviewModel class] json:data[@"list"]];
         MHVolSerReviewModel *model = dataSource.lastObject;
         
        success(dataSource, hasNext, model.apply_id);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        failure(errmsg);
    }];
}

/**
 *  服务项目申请-申请详情
 */
+ (void)getVolunteerApplyDetailWithApplyId:(NSNumber *)apply_id
                                   Success:(void(^)(MHVolSerReviewApplyDetailModel *dataSource))success
                                   failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"apply_id": apply_id};
    
    [[MHNetworking shareNetworking] get:@"volunteer/activity/apply/detail"
                                 params:params
                                success:^(id data)
     {
         MHVolSerReviewApplyDetailModel *dataSource = [MHVolSerReviewApplyDetailModel yy_modelWithDictionary:data];
         success(dataSource);
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
 
}

/**
 *  服务项目申请-选择服务队
 *
 *  @param apply_id Long	必选	1	申请记录ID
 */
+ (void)getVolunteerTeamListWithApplyId:(NSNumber *)apply_id
                                 Success:(void(^)(NSArray *dataSource))success
                                 failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"apply_id": apply_id};
    
    [[MHNetworking shareNetworking] get:@"volunteer/activity/team/list"
                                 params:params
                                success:^(id data)
     {
         NSArray *dataSource = [NSArray yy_modelArrayWithClass:[MHVolSerReviewDistributeTeamModel class] json:data];
         success(dataSource);
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
}

/**
 *  服务项目申请-选择服务队-确认
 */
+ (void)postVolunteerApplyAgreeWithApplyId:(NSNumber *)apply_id
                                  team_id:(NSNumber *)team_id
                                  Success:(void(^)())success
                                  failure:(void(^)(NSString *errmsg,NSInteger errcode))failure
{
    NSDictionary *params = @{@"apply_id": apply_id,
                             @"team_id": team_id};
    
    [[MHNetworking shareNetworking] post:@"volunteer/team/agree"
                                  params:params
                                 success:^(id data)
     {
         success();
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg,errcode);
     }];
}

/**
 *  服务项目申请-审核拒绝
 */
+ (void)postVolunteerApplyDenyWithApplyId:(NSNumber *)apply_id
                                   reason:(NSString *)reason
                                  Success:(void(^)())success
                                  failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"apply_id": apply_id,
                             @"reason": reason ? reason : [NSNull null]};
    
    [[MHNetworking shareNetworking] post:@"volunteer/activity/apply/deny"
                                 params:params
                                success:^(id data)
     {
        success();
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
}

/**
 *  全队考勤
 */
+ (void)getAttendanceRecordListWithType:(NSInteger)type
                                 teamId:(NSNumber *)teamId
                                id_type:(NSString *)id_type
                                   year:(NSInteger)year
                                  month:(NSInteger)month
                                Success:(void(^)(MHVolSerAttendanceRecordModel *model, NSInteger yearInt, NSInteger monthInt))success
                                failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"type":    @(type),
                             @"id":      teamId,
                             @"id_type": id_type,
                             @"year":    year != 0 ? @(year) : [NSNull null],
                             @"month":   month != 0 ? @(month) : [NSNull null]};

    [[MHNetworking shareNetworking] get:@"volunteer/attendance-record/by-team/list"
                                 params:params
                                success:^(NSDictionary *data)
     {
         MHVolSerAttendanceRecordModel *model = [MHVolSerAttendanceRecordModel yy_modelWithDictionary:data];
         if (type == 0) {
             MHVolSerAttendanceRecordByDayModel *obj = [model.records_by_day lastObject];
             MHVolSerAttendanceRecordByDayDetailModel *detailModel = [obj.attendance_list lastObject];
             NSArray *arrayStr = [detailModel.service_date componentsSeparatedByString:@"-"];
             NSString *year = arrayStr[0];
             NSInteger yearInt = year.integerValue;
             NSString *month = arrayStr[1];
             NSInteger monthInt = month.integerValue;
             success(model, yearInt, monthInt);
         } else {
             success(model, 0, 0);
         }
         
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
 
}


/**
 *  我的服务队-全队考勤-查看某天
 */
+ (void)getAttendanceRecordByDayListWithTeamId:(NSNumber *)teamId
                                       id_type:(NSString *)id_type
                                          attendance_id:(NSNumber *)attendance_id
                                       Success:(void(^)(NSArray <MHVolSerAttendanceRecordDetailByUserModel *>* dataSource))success
                                       failure:(void(^)(NSString *errmsg))failure
{
    NSDictionary *params = @{@"attendance_id":    attendance_id,
                             @"id":      teamId,
                             @"id_type": id_type};

    
    [[MHNetworking shareNetworking] get:@"volunteer/attendance-record/by-team/day/list"
                                 params:params
                                success:^(id data)
     {
         NSArray *dataSource = [NSArray yy_modelArrayWithClass:[MHVolSerAttendanceRecordDetailByUserModel class] json:data];
                 success(dataSource);
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
}

+ (void)postVolunteerAttendanceDailyListWithTeamId:(NSNumber *)team_id Year:(NSNumber *)year Month:(NSNumber *)month DateBegin:(NSString *)date_begin DateEnd:(NSString *)date_end AttendanceStatus:(NSNumber *)attendance_status CallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"team_id"] = team_id;
    
    if (year) {
        dic[@"year"] = year;
        dic[@"month"] = month;
        
    }
    if (date_begin) {
        dic[@"date_begin"] = date_begin;
    }
    if (date_end) {
        dic[@"date_end"] = date_end;
    }
    if (attendance_status) {
        dic[@"attendance_status"] = attendance_status;
    }else{
        dic[@"attendance_status"] = @-1;
    }
    
    [[MHNetworking shareNetworking] post:@"volunteer/attendance/daily/list" params:dic success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postVolunteerAttendanceMonthlyList:(NSNumber *)team_id Year:(NSNumber *)year Month:(NSNumber *)month CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (year) {
        dic[@"year"] = year;
        dic[@"month"] = month;
    }
    dic[@"team_id"] = team_id;
    [[MHNetworking shareNetworking] post:@"volunteer/attendance/monthly/list" params:dic success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postVolunteerAttendanceDetailWithTeamRefId:(NSNumber *)attendance_id CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"volunteer/attendance/get" params:@{@"attendance_id":attendance_id} success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+(void)postVolunteerAttendanceCheckinCrewList:(NSNumber *)action_team_ref_id CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"volunteer/attendance/checkin/crew/list" params:@{@"action_team_ref_id":action_team_ref_id} success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postVolunteerAttendanceCheckin:(NSArray *)images Crews:(NSArray *)crews Remark:(NSString *)remark ActionId:(NSNumber *)action_team_ref_id CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHAliyunManager sharedManager] uploadImageToAliyunWithArrayImage:images success:^(NSArray<MHOOSImageModel *> *imageModels) {
        
        NSString *imagesString = [[imageModels yy_modelToJSONObject] yy_modelToJSONString];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"imgs"] = imagesString;
        dic[@"crews"] = [[crews yy_modelToJSONObject] yy_modelToJSONString];
        dic[@"action_team_ref_id"] = action_team_ref_id;
        if (remark.length) {
            dic[@"remark"] = remark;
        }
        [[MHNetworking shareNetworking] post:@"volunteer/attendance/checkin" params:dic success:^(id data) {
            callback(YES,data,nil);
        } failure:^(NSString *errmsg, NSInteger errcode) {
            callback(NO,nil,errmsg);
        }];
        
    } failed:^(NSString *errmsg) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postVolunteerAttendanceCheckinUpdate:(NSNumber *)attendance_id Images:(NSMutableArray *)imgs deleted_imgs:(NSMutableArray *)deleted_imgs remark:(NSString *)remark Crews:(NSArray *)crews CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    if (imgs.count) {
        [[MHAliyunManager sharedManager] uploadImageToAliyunWithArrayImage:imgs success:^(NSArray<MHOOSImageModel *> *imageModels) {
            
            NSString *imagesString = [[imageModels yy_modelToJSONObject] yy_modelToJSONString];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"imgs"] = imagesString;
            dic[@"crews"] = [[crews yy_modelToJSONObject] yy_modelToJSONString];
            dic[@"attendance_id"] = attendance_id;
            if (deleted_imgs.count) {
                dic[@"deleted_imgs"] = [[deleted_imgs yy_modelToJSONObject] yy_modelToJSONString];
            }
            if (remark.length) {
                dic[@"remark"] = remark;
            }
            [[MHNetworking shareNetworking] post:@"volunteer/attendance/checkin/update" params:dic success:^(id data) {
                callback(YES,data,nil);
            } failure:^(NSString *errmsg, NSInteger errcode) {
                callback(NO,nil,errmsg);
            }];
            
        } failed:^(NSString *errmsg) {
            callback(NO,nil,errmsg);
        }];
        
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"crews"] = [[crews yy_modelToJSONObject] yy_modelToJSONString];
        dic[@"attendance_id"] = attendance_id;
        if (deleted_imgs.count) {
            dic[@"deleted_imgs"] = [[deleted_imgs yy_modelToJSONObject] yy_modelToJSONString];
        }
        if (remark.length) {
            dic[@"remark"] = remark;
        }
        [[MHNetworking shareNetworking] post:@"volunteer/attendance/checkin/update" params:dic success:^(id data) {
            callback(YES,data,nil);
        } failure:^(NSString *errmsg, NSInteger errcode) {
            callback(NO,nil,errmsg);
        }];
    }
    
}

+ (void)postVolunteerAttendanceStatusQuery:(NSNumber *)attendance_id CallBack:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"volunteer/attendance/status/query" params:@{@"attendance_id":attendance_id} success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)getVolunteerScoreRecordAndAttendanceDetailWithDic:(NSDictionary *)dic
                                                      url:(NSString *)url
                                                  Success:(void(^)(MHVolSerComDetailModel * model,BOOL isSuccess))success
                                                  failure:(void(^)(NSString *errmsg))failure{
    [[MHNetworking shareNetworking] get:url
                                 params:dic
                                success:^(id data)
     {
         MHVolSerComDetailModel * model = [MHVolSerComDetailModel yy_modelWithJSON:data];
         success(model,YES);
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
}

+ (void)switchVolunteerVirtualAccount:(NSNumber *)volunteer_id success:(void(^)(id data))success failure:(void(^)(NSString *errmsg))failure {
    [[MHNetworking shareNetworking] get:@"volunteer/switch"
                                 params:@{@"volunteer_id":volunteer_id}
                                success:^(id data){
         success(data);
     } failure:^(NSString *errmsg, NSInteger errcode) {
         failure(errmsg);
     }];
}

@end







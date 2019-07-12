//
//  MHVoServerDataHandler.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHVolunteerServiceMainModel,MHVolServiceTimeModel,MHVoSerIntegralDetailsModel;
@class MHVolSerAttendanceRecordModel;

@class MHVolunteerServiceMainModel, MHVolSerReamListModel;
@class MHVolSerReviewApplyDetailModel;
@class MHVolSerAttendanceRecordDetailByUserModel;
@class MHVolSerComDetailModel;

@interface MHVoServerRequestDataHandler : NSObject
/**
 *   志愿者服务
 */
+ (void)getServerMainSuccess:(void(^)(MHVolunteerServiceMainModel *model))success
                     failure:(void(^)(NSString *errmsg))failure;



/**积分明细*/
+ (void)getVoSerIntegralDetails:(NSInteger)type request:(void(^)(MHVoSerIntegralDetailsModel *dataModel))success
                        failure:(void(^)(NSString *errmsg))failure;

/**
 选择服务队
 */
+ (void)PostVolunteerAttendanceRecordsTeamListCallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

/**
 *  登记考勤前选择考勤类型
 *
 *  @param Id      Long	必选	1	id
 *  @param type    String	必选	a|t	id所属类型，a 表示服务项目，t 表示服务队
 */
+ (void)getVolunteervCheckinActivityItemListWithId:(NSNumber *)Id
                                              type:(NSString *)type
                                           Success:(void(^)(NSArray <MHVolSerReamListModel*> *dataSource))success
                                           failure:(void(^)(NSString *errmsg))failure;

/**
 *  登记考勤服务队员列表
 *
 *  @param Id      Long	必选	1	id
 *  @param type    String	必选	a|t	id所属类型，a 表示服务项目，t 表示服务队
 */
+ (void)getVolunteervCheckinteamMemberListtWithId:(NSNumber *)Id
                                             type:(NSString *)type
                                          Success:(void(^)(NSArray <MHVolSerReamListModel*> *dataSource))success
                                          failure:(void(^)(NSString *errmsg))failure;

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
                                failure:(void(^)(NSString *errmsg))failure;
/**
 *  审核人员加入列表
 *
 *  @param type    列表类型，0表示待审核，1表示已审核，默认是0
 *  @param page    页码，默认是0
 */
+ (void)getVolunteerApplyListWithType:(NSInteger)type
                                 page:(NSNumber *)page
                              Success:(void(^)(NSArray *dataSource, BOOL hasNext, NSNumber *lastId))success
                              failure:(void(^)(NSString *errmsg))failure;

/**
 *  服务项目申请-申请详情
 *
 *  @param apply_id  Long	必选	1	申请记录ID
 */
+ (void)getVolunteerApplyDetailWithApplyId:(NSNumber *)apply_id
                              Success:(void(^)(MHVolSerReviewApplyDetailModel *dataSource))success
                              failure:(void(^)(NSString *errmsg))failure;

/**
 *  服务项目申请-选择服务队
 *
 *  @param apply_id Long	必选	1	申请记录ID
 */
+ (void)getVolunteerTeamListWithApplyId:(NSNumber *)apply_id
                                  Success:(void(^)(NSArray *dataSource))success
                                  failure:(void(^)(NSString *errmsg))failure;

/**
 *  服务项目申请-选择服务队-确认
 *
 *  @param apply_id 	Long	必选	1	申请记录ID
 *  @param team_id  Long	必选	1	服务队ID
 */
+ (void)postVolunteerApplyAgreeWithApplyId:(NSNumber *)apply_id
                                  team_id:(NSNumber *)team_id
                                  Success:(void(^)())success
                                  failure:(void(^)(NSString *errmsg,NSInteger errcode))failure;
/**
 *  服务项目申请-审核拒绝
 *
 *  @param apply_id Long	必选	1	申请记录ID
 */
+ (void)postVolunteerApplyDenyWithApplyId:(NSNumber *)apply_id
                                   reason:(NSString *)reason
                                  Success:(void(^)())success
                                  failure:(void(^)(NSString *errmsg))failure;
/**
 *  全队考勤
 *
 *  @param type    Integer	必填	0表示按日，1表示按月	查询类型
 *  @param teamId  Long	必选	1	id
 *  @param id_type String	必选	a|t	id所属类型，a 表示服务项目，t 表示服务队
 *  @param year    Integer	选填（默认当前年份，当月份不为空，必填）	1888	年份
 *  @param month   Integer	选填（默认当前月份，当年份不为空，必填）	7	月份
 */
+ (void)getAttendanceRecordListWithType:(NSInteger)type
                                 teamId:(NSNumber *)teamId
                                id_type:(NSString *)id_type
                                   year:(NSInteger)year
                                  month:(NSInteger)month
                                Success:(void(^)(MHVolSerAttendanceRecordModel *model, NSInteger yearInt, NSInteger monthInt))success
                                failure:(void(^)(NSString *errmsg))failure;

/**
 *  我的服务队-全队考勤-查看某天
 *
 *  @param teamId  Long	必选	1	id
 *  @param id_type String	必选	a|t	id所属类型，a 表示服务项目，t 表示服务队
 *  @param attendance_id    	
 */
+ (void)getAttendanceRecordByDayListWithTeamId:(NSNumber *)teamId
                                id_type:(NSString *)id_type
                                   attendance_id:(NSNumber *)attendance_id
                                Success:(void(^)(NSArray <MHVolSerAttendanceRecordDetailByUserModel *>* dataSource))success
                                failure:(void(^)(NSString *errmsg))failure;


+ (void)postVolunteerAttendanceDailyListWithTeamId:(NSNumber *)team_id Year:(NSNumber *)year Month:(NSNumber *)month DateBegin:(NSString *)date_begin DateEnd:(NSString *)date_end AttendanceStatus:(NSNumber *)attendance_status CallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

+ (void)postVolunteerAttendanceMonthlyList:(NSNumber *)team_id Year:(NSNumber *)year Month:(NSNumber *)month CallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

+ (void)postVolunteerAttendanceDetailWithTeamRefId:(NSNumber *)attendance_id CallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

+ (void)postVolunteerAttendanceCheckinCrewList:(NSNumber *)action_team_ref_id CallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;


+ (void)postVolunteerAttendanceCheckin:(NSArray *)images Crews:(NSArray *)crews Remark:(NSString *)remark ActionId:(NSNumber *)action_team_ref_id CallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

/** 修改考勤*/
+ (void)postVolunteerAttendanceCheckinUpdate:(NSNumber *)attendance_id Images:(NSMutableArray *)imgs deleted_imgs:(NSMutableArray *)deleted_imgs remark:(NSString *)remark Crews:(NSArray *)crews CallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

/** 考勤记录-考勤单状态查询*/
+ (void)postVolunteerAttendanceStatusQuery:(NSNumber *)attendance_id CallBack:(void(^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;
/** 明细详情请求： 用于查看 服务时长明细详情、积分明细详情*/
+ (void)getVolunteerScoreRecordAndAttendanceDetailWithDic:(NSDictionary *)dic
                                                      url:(NSString *)url
                                                  Success:(void(^)(MHVolSerComDetailModel * model,BOOL isSuccess))success
                                                  failure:(void(^)(NSString *errmsg))failure;

/**
 志愿者服务-切换账号

 @param volunteer_id 需要切换到的志愿者ID
 */
+ (void)switchVolunteerVirtualAccount:(NSNumber *)volunteer_id success:(void(^)(id data))success failure:(void(^)(NSString *errmsg))failure;

@end

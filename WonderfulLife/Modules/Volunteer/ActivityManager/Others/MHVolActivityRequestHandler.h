//
//  MHVolActivityRequestHandler.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
@class MHVolActivityDetailsModel ,MHVolActivityApplyListModel;
typedef void(^ActivityDetailsBlock)(MHVolActivityDetailsModel *model ,BOOL isSuccess);
typedef void(^ActivityDetailsApply)(BOOL isSuccess);
typedef void(^ActivityBlock)(BOOL   isSuccess);
typedef void(^ActivityApplyListBlock)(MHVolActivityApplyListModel *model ,BOOL isSuccess);
@interface MHVolActivityRequestHandler : NSObject

// 活动详情
+ (void)activityDetailsRequest:(NSNumber *)action_id volunteer_id:(NSNumber *)volunteer_id action_team_ref_id:(NSNumber *)action_team_ref_id ActivityDetailsBlock:(ActivityDetailsBlock)callBack failure:(void(^)(NSString *errmsg))failure;

// 志愿者报名
+ (void)activityDetailsApplyCreateWithAction_id:(NSNumber *)action_id volunteer_id:(NSNumber *)volunteer_id team_id:(NSNumber *)team_id ActivityDetailsBlock:(ActivityDetailsApply)callBack failure:(void(^)(NSString *errmsg))failure;

// 志愿者取消报名
+ (void)activityDetailsApplyDeleteWithAction_id:(NSNumber *)action_id volunteer_id:(NSNumber *)volunteer_id team_id:(NSNumber *)team_id  ActivityDetailsBlock:(ActivityDetailsApply)callBack failure:(void(^)(NSString *errmsg))failure;

// 取消活动
+ (void)activityCancelWithAction_id:(NSNumber *)action_id volunteer_id:(NSNumber *)volunteer_id
         ActivityBlock:(ActivityBlock)callBack failure:(void(^)(NSString *errmsg))failure;

// 报名列表
+ (void)acticityApplyList:(NSNumber *)action_team_ref_id ActivityApplyListBlock:(ActivityApplyListBlock)callBack failure:(void(^)(NSString *errmsg))failure;

//

/**
 活动管理列表

 @param state 活动状态，2进行中，3已结束
 @param page 	页码
 @return data数据类型： MHVolActivityListModel
 */
+ (RACSignal *)pullActivityListWithState:(NSNumber*)state page:(NSNumber *)page;

/**
 动报名

 @param x 活动id
 @return data数据类型： Bool 是否报名成功
 */
+ (RACSignal *)pushEnrollActivityId:(id)x;
/**
 活动取消报名

 @param x 活动i
 @return data数据类型： Bool 是否报名成功
 */
+ (RACSignal *)pushEnrollCancelActivityId:(id)x;

/**
 拉取志愿者活动修改获取资料

 @param x 活动id
 @return data数据类型： MHActivityModifyModel 志愿者活动修改获取资料信息
 */
+ (RACSignal *)pullActivityModifyInfoWithId:(id)x;
/**
 更新修改的活动信息
 
 @param json 已修改的活动资料
 
 json请求参数
 
 名称	类型	是否必填	示例值	描述
 volunteer_id	Long	必填	1	志愿者id
 action_id	Long	必填	2	活动id
 intro	String	必填	负责武汉仁和天地太和园，治安巡逻，处理紧急事务	活动介绍
 rule	String	必填	负责武汉仁和天地太和园，治安巡逻，处理紧急事务	活动规则
 addr	String	必填	武汉人和天地家政服务中心	活动地点
 qty	Integer	必填	2	活动人数
 date_begin	Date	必填	2017-09-05 16:23	活动开始时间
 date_end	Date	必填	2017-09-05 16:23	活动结束时间
 
 @return data数据类型： 无
 */
+ (RACSignal *)updateActivityModifyInfoWithJson:(id)json;

/**
 拉取活动模板内容

 @param teamJson 请求参数json
 
 json请求参数
 
 名称	类型	是否必填	示例值	描述
 team_id	Long	必填	1	服务队id
 action_template_id	Long	选填	1	活动模板id,不填则使用默认活动模板
 
 @return data数据类型 MHActivityTemplateModel 活动模板model
 */
+ (RACSignal *)pullActivityInfoTemplateWithTeamJson:(id)teamJson;

/**
 提交新的志愿者活动

 @param volunteerJson 请求参数json
 
 json请求参数
 
 名称	类型	是否必填	示例值	描述
 team_id	Long	必填	1	服务队id
 action_template_id	Long	必填	1	活动模板id
 intro	String	必填	负责武汉人和天地	活动介绍
 qty	Integer	必填	1	活动人数
 date_begin	String	必填	2017-9-6 11:41	活动开始时间
 date_end	String	必填	2017-9-7 11:41	活动结束时间
 addr	String	必填	太和园园区内	活动地点
 rule	String	必填	负责武汉人和天地	活动规则
 
 @return data数据类型： 无
 */
+ (RACSignal *)commitNewActivityInfoWithVolunteerJson:(id)volunteerJson;

/**
 发布活动-选择服务队

 @param volunteer_id 志愿者ID
 @param callBack data数据类型
 
 data数据类型:
 
 名称	类型	示例值	描述
 team_id	Long	1	服务队id
 team_name	String	治安巡逻队	服务队名称
 has_action_template	Integer	0|1	0为没有活动模板,1为有活动模板
 
 @param failure 错误信息
 */
+ (void)pullActivityTeamListWithVolunteer_id:(NSNumber *)volunteer_id ActivityDetailsBlock:(void(^)(id data))callBack failure:(void(^)(NSString *errmsg))failure;
/**
 活动类型列表
 
 @param volunteer_id 志愿者ID
 @param callBack data数据类型
 
 data数据类型：
 
 名称	类型	示例值	描述
 action_template_id	Long	1	活动模板id
 title	String	治安巡逻	活动类型(即活动模板的标题)
 
 @param failure 错误信息
 */
+ (void)pullActivityTypeListWithVolunteer_id:(NSNumber *)volunteer_id teamID:(id)teamID ActivityDetailsBlock:(ActivityDetailsBlock)callBack failure:(void(^)(NSString *errmsg))failure;
@end

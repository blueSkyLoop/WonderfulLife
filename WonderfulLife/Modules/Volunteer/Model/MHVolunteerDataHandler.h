//
//  MHVolunteerDataHandler.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolServiceTimeModel,MHVoSerIntegralDetailsModel;
@interface MHVolunteerDataHandler : NSObject
/**
 *   志愿者总人数
 */
+ (void)getVolunteerHeadcountSuccess:(void(^)(NSString *count))success
                     failure:(void(^)(NSString *errmsg))failure;

/**
 *  考勤记录
 *
 *  @param type    <#type description#>
 *  @param teamId    <#type description#>
 *  @param year    <#year description#>
 *  @param month   <#month description#>
 */
+ (void)getAttendanceRecordWithType:(NSInteger)type
                             teamId:(NSNumber *)teamId
                               year:(NSInteger)year
                              month:(NSInteger)month
                            success:(void(^)())success
                            failure:(void(^)(NSString *errmsg))failure;

+ (void)postVoCultivateCategoryListSuccess:(void(^)(NSDictionary *data))success
                                   failure:(void(^)(NSString *errmsg))failure;
+ (void)postVoCultivateContentCategoryListWithPage:(NSString *)page CategoryID:(NSNumber *)category_id Success:(void(^)(NSDictionary *data))success
                                           failure:(void(^)(NSString *errmsg))failure;
+ (void)postVoCultivateContentDetailCategoryListWithArticleID:(NSNumber *)article_id Success:(void(^)(NSDictionary *data))success Failure:(void(^)(NSString *errmsg))failure;


/** 服务时长 && 查看我的考勤*/
+ (void)getVolunteerServiceTimeWithDic:(NSDictionary *)dic url:(NSString *)url success:(void(^)(MHVolServiceTimeModel *dataModel))success
                        failure:(void(^)(NSString *errmsg))failure;


/**积分明细*/
+ (void)getVoSerIntegralDetails:(NSInteger)type dataDic:(NSMutableDictionary *)dataDic request:(void(^)(MHVoSerIntegralDetailsModel *dataModel))success
                        failure:(void(^)(NSString *errmsg))failure;

+ (void)postVolunteerInfoIdentityValidateWithIdentity:(NSString *)identity_card CallBack:(void (^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

/**我的资料卡-用户资料详情*/
+ (void)getVoSerMyCard:(NSNumber *)volunteerId request:(void(^)(NSDictionary *data))success
                        failure:(void(^)(NSString *errmsg))failure;

/**我的资料卡-兴趣爱好列表*/
+ (void)getVoSerTheSupportListOfMyCard:(NSNumber *)volunteerId CallBack:(void (^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;

/**我的资料卡-我的需要帮助列表*/
+ (void)getVoSerTheHobbyListOfMyCard:(NSNumber *)volunteerId request:(void(^)(NSDictionary *data))success
                             failure:(void(^)(NSString *errmsg))failure;

/**我的资料卡-修改照片*/
+ (void)postVoSerModifyThePhotoOfMyCard:(id)imgData request:(void(^)(NSDictionary *data))success
               failure:(void(^)(NSString *errmsg))failure;

/**我的资料卡-修改身份证*/
+ (void)postVoSerModifyTheIdentifyOfMyCard:(NSNumber *)volunteerId Identity:(NSString *)indentify request:(void(^)(NSDictionary *data))success
               failure:(void(^)(NSString *errmsg))failure;

/**我的资料卡-修改性别*/
+ (void)postVoSerModifyTheSexOfMyCard:(NSNumber *)volunteerId Sex:(NSInteger)sex request:(void(^)(NSDictionary *data))success
               failure:(void(^)(NSString *errmsg))failure;

/**我的资料卡-修改生日*/
+ (void)postVoSerModifyTheBirthdayOfMyCard:(NSNumber *)volunteerId Birthday:(NSString *)day request:(void(^)(NSDictionary *data))success
                              failure:(void(^)(NSString *errmsg))failure;

/**我的资料卡-修改手机号码*/
+ (void)postVoSerModifyThePhoneOfMyCard:(NSNumber *)volunteerId Phone:(NSString *)phone request:(void(^)(NSDictionary *data))success
                              failure:(void(^)(NSString *errmsg))failure;

/**我的资料卡-修改住址*/
+ (void)postVoSerModifyTheAddressOfMyCard:(NSNumber *)volunteerId Address:(id)address request:(void(^)(NSDictionary *data))success
                              failure:(void(^)(NSString *errmsg))failure;
/**我的资料卡-修改我的兴趣爱好列表*/
+ (void)postVoSerModifyTheHobbyListOfMyCard:(NSNumber *)volunteerId HobbyArray:(id)hobbyArray request:(void(^)(NSDictionary *data))success
                                    failure:(void(^)(NSString *errmsg))failure;

+ (void)postVolunteerApplyCheckHasRoom:(NSNumber *)community_id Success:(void(^)(NSDictionary *data))success Failure:(void(^)(NSString *errmsg))failure;
@end






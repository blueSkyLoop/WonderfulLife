//
//  MHHomeRequest.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MHHomeArticle,MHHomeBannerAd,MHHoPayDetailsModel,MHHomeHTMLModel,MHHomeFunctionalModulesModel,MHHomeMoreFunctionalModulesModel;
typedef void(^MHHomeTableCallBack)(BOOL success,NSArray<MHHomeBannerAd *> *bannerList,MHHomeArticle *volunteerTopNews,NSArray<MHHomeArticle *> *communityNews,NSString *errmsg,NSString *next_page,NSArray<MHHomeFunctionalModulesModel *> *functionalList);
typedef void(^MHHomeVolListCallBack)(BOOL success,NSArray<MHHomeArticle *> *volunteerNews,NSString *errmsg,NSString *next_page);

@interface MHHomeRequest : NSObject

+ (void)loadHomeTableDataWithPage:(NSString *)page
                      communityId:(NSNumber *)community_id
                         callBack:(MHHomeTableCallBack)callBack;
+ (void)loadHomeMoreFunctionalModules:(NSNumber *)community_id
                             callBack:(void(^)(BOOL success,
                                               NSArray<MHHomeMoreFunctionalModulesModel *> *functionalPropertyList,
                                               NSString *errmsg))callBack;

+ (void)loadVolListWithPage:(NSString *)page
                communityId:(NSNumber *)community_id
                   callBack:(MHHomeVolListCallBack)callBack;

+ (void)getCommunityAnnouncementWithPage:(NSNumber *)page Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)getReddotHomeCallback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postPropertyfeeCreateWithPropertyID:(NSString *)property_id Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postPropertyfeeDeleteWithPropertyID:(NSString *)property_id Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postPropertyfeeUnpayListWithPropertyID:(id)property_id Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postPropertyfeeTrainingListWithPropertyID:(id)property_id Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postpropertyfeeUnpayDetailWithPropertyID:(NSString *)property_id FeeDate:(NSString *)fee_date Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)loadHoPayDetailsListWithPropertyID:(NSString *)property_id FeeMonth:(NSString *)fee_month Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postNotificationlistWithPage:(NSNumber *)page NotifyType:(NSNumber *)notify_type Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postNotificationReadWithNotificationId:(NSNumber *)notification_id Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postPaymentAliOrderCreateWithPropertyId:(NSNumber *)property_id PaymentMonthList:(NSString *)payment_month_list Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;

+ (void)postPaymentWeixinOrderCreateWithPropertyId:(NSNumber *)property_id PaymentMonthList:(NSString *)payment_month_list Callback:(void (^)(BOOL success, NSDictionary *data, NSString *errmsg))callback;


+ (void)postHTMLUrlControlIsShowWithBlock:(void(^)(BOOL success,MHHomeHTMLModel *model,NSString *errmsg))callBack;

+ (void)checkRoomPaidTimeoutWithRoomID:(id)roomID callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback;
/**获取用户认证的房间 */
+ (void)checkUserRoomsInfoCallback:(void (^)(NSDictionary *data))success;
@end






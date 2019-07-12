//
//  MHHomeRequest.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeRequest.h"
#import "MHNetworking.h"

#import "YYModel.h"
#import "MHUserInfoManager.h"
#import "MHAreaManager.h"
#import "MHHomeBannerAd.h"
#import "MHHomeArticle.h"
#import "MHHomeFunctionalModulesModel.h"
#import "MHHomeMoreFunctionalModulesModel.h"
#import "MHHoPayDetailsModel.h"
#import "MHHomeHTMLModel.h"

#import "MHHUDManager.h"

@implementation MHHomeRequest

+ (void)loadHomeTableDataWithPage:(NSString *)page
                      communityId:(NSNumber *)community_id
                         callBack:(MHHomeTableCallBack)callBack {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (page) dic[@"page"] = page;
    if (community_id) dic[@"community_id"] = community_id;
    [[MHNetworking shareNetworking] post:@"index"
                                  params:[dic copy]
                                 success:^(NSDictionary *data) {
        NSArray *bannerList =[NSArray yy_modelArrayWithClass:[MHHomeBannerAd class] json:data[@"banner_list"]];
        NSArray *functionalList = [NSArray yy_modelArrayWithClass:[MHHomeFunctionalModulesModel class] json:data[@"function_list"]];
        MHHomeArticle *article = [MHHomeArticle yy_modelWithJSON:data[@"volunteer_top_news"]];
        NSArray *communityNews = [NSArray yy_modelArrayWithClass:[MHHomeArticle class] json:data[@"community_news"][@"list"]];
                                     NSString *next_page;
                                     if (((NSNumber *)data[@"community_news"][@"has_next"]).boolValue) {
                                         next_page = data[@"community_news"][@"next_page"];
                                     }
        callBack(YES,bannerList,article,communityNews,nil,next_page,functionalList);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callBack(NO,nil,nil,nil,errmsg,nil,nil);
    }];
}

+ (void)loadHomeMoreFunctionalModules:(NSNumber *)community_id
                             callBack:(void(^)(BOOL success,
                                               NSArray<MHHomeMoreFunctionalModulesModel *> *functionalPropertyList,
                                               NSString *errmsg))callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (community_id) dic[@"community_id"] = community_id;
    [[MHNetworking shareNetworking] post:@"index/more"
                                  params:[dic copy]
                                 success:^(NSDictionary *data) {
                                     NSArray *property_service_list = [NSArray yy_modelArrayWithClass:[MHHomeMoreFunctionalModulesModel class] json:data];
                                     callBack(YES,property_service_list,nil);
                                 } failure:^(NSString *errmsg, NSInteger errcode) {
                                     callBack(NO,nil,errmsg);
                                 }];

}

+ (void)loadVolListWithPage:(NSString *)page
                communityId:(NSNumber *)community_id
                   callBack:(MHHomeVolListCallBack)callBack {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (page) dic[@"page"] = page;
    if (community_id) dic[@"community_id"] = community_id;
    [[MHNetworking shareNetworking] post:@"volunteer/news/list"
                                  params:[dic copy]
                                 success:^(NSDictionary *data) {
                                     NSArray *volunteerNews = [NSArray yy_modelArrayWithClass:[MHHomeArticle class] json:data[@"list"]];
                                     NSString *next_page;
                                     if (((NSNumber *)data[@"has_next"]).boolValue) {
                                         next_page = data[@"next_page"];
                                     }
                                     callBack(YES,volunteerNews,nil,next_page);
                                 } failure:^(NSString *errmsg, NSInteger errcode) {
                                     callBack(NO,nil,errmsg,nil);
                                 }];
}



+ (void)getCommunityAnnouncementWithPage:(NSNumber *)page Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"community_id"] = [MHAreaManager sharedManager].community_id;
//    dic[@"community_id"] = @126;
    dic[@"page"] = page;
    
    [[MHNetworking shareNetworking] get:@"community/annoucement" params:dic success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)getReddotHomeCallback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback{
    [[MHNetworking shareNetworking] get:@"reddot/home" params:nil success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)checkUserRoomsInfoCallback:(void (^)(NSDictionary *data))success {
    [[MHNetworking shareNetworking] post:@"struct/myroom/list" params:nil success:^(id data) {
        success(data);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}

+ (void)checkRoomPaidTimeoutWithRoomID:(id)roomID callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback{
    NSMutableDictionary *mut_dic = [NSMutableDictionary dictionary];
    mut_dic[@"struct_id"] = roomID;
    [[MHNetworking shareNetworking] post:@"payment/isPaymentClose" params:mut_dic success:^(id data) {
        if ([data[@"isCode"] isEqualToNumber:@1]) {
            callback(NO,nil,data[@"msg"]);
            return;
        }
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}



+ (void)postPropertyfeeCreateWithPropertyID:(NSString *)property_id Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback{
    [[MHNetworking shareNetworking] post:@"propertyfee/property/create" params:@{@"property_id":property_id} success:^(id data) {
        
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postPropertyfeeDeleteWithPropertyID:(NSString *)property_id Callback:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"propertyfee/property/delete" params:@{@"property_id":property_id} success:^(id data) {
        
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postPropertyfeeUnpayListWithPropertyID:(id)property_id Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback{
    [[MHNetworking shareNetworking] post:@"propertyfee/unpay/list" params:@{@"struct_id":property_id} success:^(id data) {
        
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postPropertyfeeTrainingListWithPropertyID:(id)property_id Callback:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"propertyfee/paid/list" params:@{@"struct_id":property_id} success:^(id data) {
        
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postpropertyfeeUnpayDetailWithPropertyID:(NSString *)property_id FeeDate:(NSString *)fee_date Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback{
    [[MHNetworking shareNetworking] post:@"propertyfee/unpay/get" params:@{@"struct_id":property_id,@"fee_month":fee_date} success:^(id data) {
        
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

/**
 加载物业缴费
 */
+ (void)loadHoPayDetailsListWithPropertyID:(NSString *)property_id
                                  FeeMonth:(NSString *)fee_month
                                  Callback:(void (^)(BOOL success,NSDictionary *data,NSString *errmsg))callback{
    NSDictionary *param = @{
                            @"struct_id" : property_id,
                            @"fee_month" : fee_month
                            };
    [[MHNetworking shareNetworking] post:@"propertyfee/paid/get" params:param success:^(NSDictionary *data) {
        callback(YES,data,nil);
        
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postNotificationlistWithPage:(NSNumber *)page NotifyType:(NSNumber *)notify_type Callback:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = page;
    if (notify_type.integerValue) {
        dic[@"notify_type"] = notify_type;
    }
    [[MHNetworking shareNetworking] post:@"notification/list" params:dic success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postNotificationReadWithNotificationId:(NSNumber *)notification_id Callback:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"notification_id"] = notification_id;
    [[MHNetworking shareNetworking] post:@"notification/read" params:dic success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postPaymentAliOrderCreateWithPropertyId:(NSNumber *)property_id PaymentMonthList:(NSString *)payment_month_list Callback:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"payment/ali/order/create" params:@{@"property_id":property_id,@"payment_month_list":payment_month_list} success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postPaymentWeixinOrderCreateWithPropertyId:(NSNumber *)property_id PaymentMonthList:(NSString *)payment_month_list Callback:(void (^)(BOOL, NSDictionary *, NSString *))callback{
    [[MHNetworking shareNetworking] post:@"payment/weixin/order/create" params:@{@"property_id":property_id,@"payment_month_list":payment_month_list} success:^(id data) {
        callback(YES,data,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callback(NO,nil,errmsg);
    }];
}

+ (void)postHTMLUrlControlIsShowWithBlock:(void(^)(BOOL success,MHHomeHTMLModel *model,NSString *errmsg))callBack {
    [[MHNetworking shareNetworking] post:@"control/isShow" params:nil success:^(id data) {
        MHHomeHTMLModel *model = [MHHomeHTMLModel yy_modelWithJSON:data];
        callBack(YES,model,nil);
    } failure:^(NSString *errmsg, NSInteger errcode) {
        callBack(NO,nil,errmsg);
    }];
}

@end




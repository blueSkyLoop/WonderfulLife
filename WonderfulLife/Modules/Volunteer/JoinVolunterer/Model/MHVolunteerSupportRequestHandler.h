//
//  MHVolunteerSupportRequestHandler.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/12.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHVolunteerSupportModel ;
@interface MHVolunteerSupportRequestHandler : NSObject

/** 选择需要帮助列表 */
+(void)postVolunteerSupportListWithUrl:(NSString *)url request:(void(^)(NSArray <MHVolunteerSupportModel *>*supports))success
                               failure:(void(^)(NSString *errmsg))failure;

+ (void)postVolunteerSupportListWithUrl:(NSString *)url params:(id)params request:(void (^)(NSArray<MHVolunteerSupportModel *> *))success failure:(void (^)(NSString *))failure;

+ (void)uploadCustomHobby:(NSString *)hobby Success:(void(^)(long tag_id,NSString *tag_name))success failure:(void(^)(NSString *errmsg))failure;


/** 修改帮助的列表*/
+ (void)postVolSupportListRepair:(NSString *)support_list success:(void(^)(NSDictionary  *data))success
                         failure:(void(^)(NSString *errmsg))failure;

@end

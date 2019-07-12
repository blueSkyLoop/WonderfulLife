//
//  MHCertificationRequestHandler.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//  住户认证 网络请求类

#import <Foundation/Foundation.h>

typedef void(^MHCiCommunityAreaListBlock)(NSArray *,NSString *,BOOL);

@interface MHCertificationRequestHandler : NSObject

/**
 *  发送短信验证码
 *
 *  @param phone   <#phone description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)getVaildateCodeWithPhone:(NSString *)phone
                         success:(void(^)())success
                         failure:(void(^)(NSString *errmsg))failure;


+ (void)postCheckUserWithName:(NSString *)identity_card_name Number:(NSString *)identity_card_number RoomID:(NSNumber *)struct_id SuccessBlock:(void (^)(NSInteger is_validate))successBlock;

///area
+ (void)postAreaWithCommunityID:(NSNumber *)community_id
                       callBack:(MHCiCommunityAreaListBlock)block;
///building
+ (void)postBuildWithCommunityID:(NSNumber *)community_id
                        structId:(NSNumber *)struct_id
                        callBack:(MHCiCommunityAreaListBlock)block;
///unit
+ (void)postUnitWithCommunityID:(NSNumber *)community_id
                       structId:(NSNumber *)struct_id
                       callBack:(MHCiCommunityAreaListBlock)block;
///room
+ (void)postRoomWithCommunityID:(NSNumber *)community_id
                       structId:(NSNumber *)struct_id
                       callBack:(MHCiCommunityAreaListBlock)block;


/**
 *  校验手机验证码
 *
 *  @param phone    手机号码
 *  @param structId 房间号id
 *  @param code     	验证码
 */
+ (void)postCheckVaildateCodeWithPhone:(NSString *)phone
                                 structId:(NSNumber *)structId
                                     code:(NSString *)code
                                  success:(void(^)(long is_success))success
                                  failure:(void(^)(NSString *errmsg))failure;

/**
 *  上传缴费单据认证
 *
 *  @param structId 房间号id
 *  @param imgs     上传的图片的集合
 
 */
+ (void)postUploadBillWithStructId:(NSNumber *)structId
                              imgs:(NSString *)imgs
                           success:(void(^)())success
                           failure:(void(^)(NSString *errmsg))failure;
@end

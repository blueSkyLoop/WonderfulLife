//
//  MHJPushRequestHandle.h
//  WonderfulLife
//
//  Created by Lucas on 17/8/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MHJPushRequestHandleBlock)(BOOL success, NSString *errorMsg);
typedef NS_ENUM(NSInteger, MHJPushAliasType){
    
    /** */
    MHJPushAliasType_Set  = 0,
    
    /** */
    MHJPushAliasType_Delete
};
@interface MHJPushRequestHandle : NSObject



/**
 *  我司后台 注册极光推送
 *
 *  @parma   token      String
 *  @parma   regesterId  Long （极光推送返回的注册id）   要么不传，要么传，不能传空！
 */
+ (void)JPushReg:(MHJPushRequestHandleBlock)block;



/**
 *   我司后台 注销极光推送
 *
 *  @parma   <#parma#>
 *
 */
+ (void)JPushUnReg:(MHJPushRequestHandleBlock)block;


/**
 *  用于多个志愿者角色切换时，区分特定的接收推送对象， 删除 或 添加
 *
 */
+ (void)mhJpush_AliasWithType:(MHJPushAliasType)type volunteer_id:(NSNumber *)volunteer_id completion:(void (^)(BOOL success))completion
                 failure:(void (^)(NSString *errmsg))failure;


/**
 *  通知后台推送消息
 *
 *  @parma   regesterId 、token
 */
+ (void)mhJpush_getOffLineWithCompletion:(void (^)(BOOL success))completion
                                 failure:(void (^)(NSString *errmsg))failure;



@end

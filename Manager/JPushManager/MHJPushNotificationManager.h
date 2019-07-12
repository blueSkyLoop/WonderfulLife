//
//  MHJPushNotificationManager.h
//  WonderfulLife
//
//  Created by Lucas on 17/7/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, JPushStateType){
    
    /** 站内推送 */
    JPushStateType_Active  = 0,
    
    /** 站外推送*/
    JPushStateType_Inactive
};
@interface MHJPushNotificationManager : NSObject

+ (instancetype)manager;

/** 推送通知 */
- (void)jpush_notificationUserInfo:(NSDictionary *)userInfo stateType:(JPushStateType)stateType;

/** 自定义消息 */
- (void)jpush_customMsgUserInfo:(NSDictionary *)userInfo;

@end

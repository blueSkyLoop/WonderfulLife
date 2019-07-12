//
//  AppDelegate+JPush.h
//  WonderfulLife
//
//  Created by Lucas on 17/8/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "AppDelegate.h"
#import "MHConstSDKConfig.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "MHJPushNotificationManager.h"
@interface AppDelegate (JPush)<JPUSHRegisterDelegate>
- (void)mh_jPushConfigLaunchingWithOptions:(NSDictionary *)launchOptions;

// 后台运行挂起监听方法
- (void)mh_applicationDidEnterBackground:(UIApplication *)application ;

- (void)mh_applicationWillEnterForeground:(UIApplication *)application ;

- (void)mh_registerAPNs;


- (void)mh_startReceivingNotification;

- (void)mh_stopReceivingNotification;



@end

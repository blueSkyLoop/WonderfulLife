//
//  AppDelegate+JPush.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "MHJPushNotificationManager.h"
#import "MHConst.h"
#import "MHJPushRequestHandle.h"

@implementation AppDelegate (JPush)



#pragma mark - Notification

- (void)mh_startReceivingNotification{
    
}

- (void)mh_stopReceivingNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - JPush Register
/**极光推送*/
- (void)mh_jPushConfigLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
//            if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//              NSSet<UNNotificationCategory *> *categories;
//              entity.categories = categories;
//            }
//            else {
//              NSSet<UIUserNotificationCategory *> *categories;
//              entity.categories = categories;
//            }
    }else{
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction ;
    if (MH_BUNDLEID_JF) {
        isProduction = YES;
    }else{
        isProduction = NO;
    }
    
    
    NSString *JpushKey;
    if (MH_BUNDLEID_JFKH) {// 内部测试
        JpushKey =  @"9c9ecd153a61510d835061f2";
    } else if (MH_BUNDLEID_MH) {///线上
        JpushKey = @"a98057ff807d742c08343e61";
    }else if (MH_BUNDLEID_JF) {/// 客户体验版
        JpushKey = @"b20145669045578b70d31655";
    }else {
        [NSException exceptionWithName:@"BundleIdReadException" reason:@"can fit bundle identifier for gaode map" userInfo:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:JpushKey
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"极光推送---registrationID获取成功：%@",registrationID);
            // 我司后台 注册极光推送
            [MHJPushRequestHandle JPushReg:nil];
        }
        else{
            NSLog(@"极光推送---registrationID获取失败，code：%d",resCode);
        }
    }];
}





// JPush config
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)mh_applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)mh_applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
     NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



// ios 10 以下  Lo 5s 站内 && 站外 在此方法回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {  // 站内
        [[MHJPushNotificationManager manager] jpush_notificationUserInfo:userInfo stateType:JPushStateType_Active];
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {  // 站外
        [[MHJPushNotificationManager manager] jpush_notificationUserInfo:userInfo stateType:JPushStateType_Inactive];
    }
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}




#pragma mark- JPUSHRegisterDelegate
// iOS 10 站内 Support  在此接收回调
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {

    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    
    [[MHJPushNotificationManager manager] jpush_notificationUserInfo:userInfo stateType:JPushStateType_Active];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
#pragma mark - 用于实时更新内部数据
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 站外 Support 点击通知栏执行方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [[MHJPushNotificationManager manager] jpush_notificationUserInfo:userInfo stateType:JPushStateType_Inactive];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        [[MHJPushNotificationManager manager] handleUserInfo:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}




// 极光自定义消息接收：站内
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    [[MHJPushNotificationManager manager] jpush_customMsgUserInfo:userInfo];

}

- (void)mh_registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


@end

//
//  AppDelegate.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/3.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "AppDelegate.h"
#import "MHConstSDKConfig.h"
#import "MHTabBarControllerManager.h"
#import "MHNavigationControllerManager.h"
#import "MHChooseUrlController.h"
#import "MHOwnerCheckController.h"
#import "MHVoDataFillController.h"
#import "MHVoHobbyController.h"
#import "MHDataPerfectController.h"
#import "MHHoMsgNotifiTableViewController.h"
#import "MHHoCommunityAnnouncementController.h"
#import "MHDataPerfectController.h"
#import "MHVoCultivateController.h"
#import "MHMineController.h"
#import "MHGuidePageViewController.h"

#import <UserNotifications/UserNotifications.h>
#import "MHJPushNotificationManager.h"
#import "AppDelegate+MHHelper.h"
#import "AppDelegate+JPush.h"
#import "AppDelegate+UMeng.h"

#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MHPayManager.h"
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#if MH_Dev
    NSLog(@"----------- 开发环境 -----------");
#elif MH_APPStore
    NSLog(@"--------------- APPStore -----------");
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor             = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self mh_bugly];
    [self mh_umengAnalytics];
    [self mh_umengShare];
    [NSThread sleepForTimeInterval:2.0];
    //keyboard
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    //  是否已经进入过引导页
    BOOL isAlreadyOpen = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MHGuide_page"] boolValue];
    if (isAlreadyOpen) {
        [self enterMianUI];
    }else{
        [self enterPageUI];
    }
    application.statusBarStyle = UIStatusBarStyleDefault;
    
    //添加逻辑业务
    [self addBusinessLogic];
    //添加功能业务
    [self addFunctionLogic];
    [self mh_registerAPNs];
    [self mh_jPushConfigLaunchingWithOptions:launchOptions];
//    [WXApi registerApp:@"wx1aaa005c38048f44"];
    
    //版本更新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self mh_getNewVersionInfo];
    });
    return YES;
}

#pragma mark - SetUI
/** 进入主页*/
- (void)enterMianUI{
    [SVProgressHUD dismiss];
    UIViewController *controller = self.window.rootViewController;
    MHTabBarControllerManager *tabBarController = [[MHTabBarControllerManager alloc]init];
    self.window.rootViewController = tabBarController;
    if(controller){
        [controller.view removeFromSuperview];
        controller = nil;
    }
}

/** 进入引导页*/
- (void)enterPageUI{
    UIViewController *controller = self.window.rootViewController;
    MHGuidePageViewController *vc = [[MHGuidePageViewController alloc] init];
    self.window.rootViewController = vc;
    if(controller){
        [controller.view removeFromSuperview];
        controller = nil;
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self mh_applicationDidEnterBackground:application];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    //    [APService stopLogPageView:@"aa"];
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self mh_applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 微信支付 && 支付宝支付
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [self handleURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [self mh_umengapplication:application handleOpenURL:url];
}


- (BOOL)handleURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:@"WonderfulLife"] && [url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        
    }else if ([url.scheme isEqualToString:@"wx1aaa005c38048f44"] || [url.scheme isEqualToString:@"wx84fd83ebf02f3267"]){//微信支付
        return [WXApi handleOpenURL:url delegate:[MHPayManager sharedManager]];
    }
    return YES;
}

/** 
 功能业务
 */
- (void)addFunctionLogic{
    //获取阿里云token
    [self mh_getOSSToken];
}

//添加逻辑业务
- (void)addBusinessLogic {
    //刷新token
    [self mh_getRefreshToken];
}

@end

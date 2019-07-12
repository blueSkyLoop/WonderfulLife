//
//  AppDelegate+UMeng.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "AppDelegate+UMeng.h"

#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"
#import "MHMacros.h"
#import "MHConstSDKConfig.h"
@implementation AppDelegate (UMeng)

static NSString * const UMeng_WechatAPPKey = @"wx1aaa005c38048f44";
static NSString * const UMeng_WechatAPPSecret = @"dc9f00041dd9efd52a40767c0db29ac9";

static NSString *const UMeng_WeiBoAPPKey = @"150941052" ;
static NSString * const UMeng_WeiBoAPPSecret = @"35c6ae65cd9112fabcd0431ddcf62b9f";


- (NSString *)umengKey {
    NSString *umengKey ;
    if (MH_BUNDLEID_MH) { // 线上
        umengKey = @"59e4625f310c937eaa00008c";
    }
    else { // 开发测试
        umengKey = @"59e44841bbea831a59000033";
    }return umengKey ;
}

- (void)mh_umengAnalytics {
   
    UMConfigInstance.appKey = [self umengKey];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
#if DEBUG
    
    [MobClick setLogEnabled:YES];
#else
    
    [MobClick setLogEnabled:NO];
#endif
}


- (void)mh_umengShare {
#if DEBUG
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
#endif
    
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:[self umengKey]];
    
    [self mh_confitUShareSettings];
    
    [self mh_configUSharePlatforms];
}

- (void)mh_confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)mh_configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:UMeng_WechatAPPKey appSecret:UMeng_WechatAPPSecret redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:UMeng_WechatAPPKey appSecret:UMeng_WechatAPPSecret redirectURL:nil];
    
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:UMeng_WeiBoAPPKey  appSecret:UMeng_WeiBoAPPSecret redirectURL:@"https://api.weibo.com/oauth2/default.html"];


}


- (BOOL)mh_umengapplication:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return YES;
    }
    return result;
}

@end

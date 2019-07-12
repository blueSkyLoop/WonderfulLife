//
//  AppDelegate+WHHelper.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "AppDelegate+MHHelper.h"
#import "MHAliyunManager.h"

#import "MHLoginRequestHandler.h"
#import "MHAlertView.h"
#import "MHMacros.h"
#import "MHConstSDKConfig.h"

#import <Bugly/Bugly.h>

@implementation AppDelegate (MHHelper)

- (void)mh_getOSSToken {
    [[MHAliyunManager sharedManager] getOssConfigWithCompleteBlock:^(BOOL success) {
        //do something
    }];
}

/**
 刷新token
 */
- (void)mh_getRefreshToken {
    [MHLoginRequestHandler getRefreshTokenWithPushId:nil];
}


- (void)mh_getNewVersionInfo {
    [MHLoginRequestHandler checkTheApplicationNeedsToUpdate:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        BOOL force_update = [data[@"force_update"] boolValue];
        BOOL need_update = [data[@"need_update"] boolValue];
        if (force_update) {
           [MHAlertView showVersionAlertViewMessage:data[@"update_content"] sureHandler:^{
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data[@"update_url"]]];
           }];
        }else if (need_update){
            [[MHAlertView sharedInstance]showVersionAlertViewMessage:data[@"update_content"] leftHandler:^{
                [[MHAlertView sharedInstance]dismiss];
            } rightHandler:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data[@"update_url"]]];
                [[MHAlertView sharedInstance]dismiss];
            } rightButtonColor:MColorToRGB(0X20A0FF)];
        }
    }];
}


- (void)mh_bugly {
    BuglyConfig *config = [[BuglyConfig alloc]init];
    config.viewControllerTrackingEnable = YES;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.blockMonitorEnable = YES;
    
    NSString *buglyKey ;
    if (MH_BUNDLEID_MH) {
        buglyKey = @"43741533cd";
    }else if (MH_BUNDLEID_JF) {
        buglyKey = @"2283962e03";
    }
    else {
        buglyKey = @"441f126668";
    }
    [Bugly startWithAppId:buglyKey config:config];
}



@end

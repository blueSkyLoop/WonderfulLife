//
//  AppDelegate+WHHelper.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate (MHHelper)

/** 
 获取OSS的token
 */
- (void)mh_getOSSToken;

/**
 刷新token
 */
- (void)mh_getRefreshToken;

/**
 版本更新
 */
- (void)mh_getNewVersionInfo;


/** 崩溃日志配置*/
- (void)mh_bugly ;



@end

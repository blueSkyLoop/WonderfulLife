//
//  AppDelegate+UMeng.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (UMeng)

/** 友盟统计*/
- (void)mh_umengAnalytics ;

/** 友盟分享*/
- (void)mh_umengShare ;

/** 友盟回调*/
- (BOOL)mh_umengapplication:(UIApplication *)application handleOpenURL:(NSURL *)url ;
@end

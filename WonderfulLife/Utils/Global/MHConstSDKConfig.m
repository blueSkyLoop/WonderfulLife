//
//  MHConstSDKConfig.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHConstSDKConfig.h"
#import "MHChooseUrlModel.h"
@implementation MHConstSDKConfig

#if DEBUG    // 开发配置
NSString *const kInitialHttpIP = @"http://172.16.3.188:8080/";

#else   // 线上配置 || 测试环境配置

/** 开发测试 给客户使用 */
NSString *const kInitialHttpIP = @"http://106.14.66.246/";

/**测试环境 */
//NSString *const kInitialHttpIP = @"http://172.16.3.188:8090/";

#endif

#warning 记得！！！！！！！切换好
//   bundle ID  ：  com.JFKHWonderfulLife.cn   开发测试包
//   bundle ID  ：  com.JFWonderfulLife.cn   给客户的包！
//   bundle ID  ：  com.MHWonderfulLife.cn   正式上线
@end

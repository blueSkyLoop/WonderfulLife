//
//  MHConstSDKConfig.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHChooseUrlModel.h"
@interface MHConstSDKConfig : NSObject


#pragma mark -- SDK Key

#pragma mark -- URL Config
extern NSString *const kInitialHttpIP ;


#define baseHttpIP ([MHChooseUrlModel getBaseHttpIP])

#define baseUrl [NSString stringWithFormat:@"%@web/client/",baseHttpIP]

#define MH_BUNDLEID_JFKH [[[NSBundle mainBundle]bundleIdentifier] isEqualToString:@"com.JFKHWonderfulLife.cn"]

#define MH_BUNDLEID_JF [[[NSBundle mainBundle]bundleIdentifier] isEqualToString:@"com.JFWonderfulLife.cn"]

#define MH_BUNDLEID_MH [[[NSBundle mainBundle]bundleIdentifier] isEqualToString:@"com.MHWonderfulLife.cn"]
@end

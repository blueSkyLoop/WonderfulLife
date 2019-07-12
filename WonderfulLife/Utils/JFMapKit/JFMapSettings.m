//
//  JFMapSettings.m
//  JFCommunityCenter
//
//  Created by hanl on 2017/5/3.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import "JFMapSettings.h"
#import "MHConstSDKConfig.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@implementation JFMapSettings

+ (void)registerApikey {
    NSString *gdApikey;
    if (MH_BUNDLEID_JF) {///测试
        gdApikey =  @"fd946d4ea331e536cf0fd406600ada2f";
    }else if (MH_BUNDLEID_JFKH){ // 开发环境
        gdApikey =  @"4be3036cadaa470bab052036783c00b9";
    }else if (MH_BUNDLEID_MH) {///线上
        gdApikey = @"b1980d54403ff7de6db8add529ea3276";
    } else {
        [NSException exceptionWithName:@"BundleIdReadException" reason:@"can fit bundle identifier for gaode map" userInfo:nil];
    }
    
    [[AMapServices sharedServices]setApiKey:gdApikey];
//    [[AMapServices sharedServices]setEnableHTTPS:YES]; //default is YES
}

@end

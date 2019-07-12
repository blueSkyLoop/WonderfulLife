//
//  AppDelegate+JFMapSwizzling.m
//  JFCommunityCenter
//
//  Created by hanl on 2017/5/3.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import "AppDelegate+JFMapSwizzling.h"

#import <objc/runtime.h>

#import "JFMapConfig.h"
#import "JFMapSettings.h"


@implementation AppDelegate (JFMapSwizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jf_exchangeMethod([self class], @selector(application:didFinishLaunchingWithOptions:), @selector(jfm_application:didFinishLaunchingWithOptions:));
    });
}

- (BOOL)jfm_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL status = [self jfm_application:application didFinishLaunchingWithOptions:launchOptions];
    
    [JFMapSettings registerApikey];
    
    return status;
}

@end

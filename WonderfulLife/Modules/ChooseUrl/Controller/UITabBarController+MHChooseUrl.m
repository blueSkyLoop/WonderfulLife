//
//  UITabBarController+MHChooseUrl.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UITabBarController+MHChooseUrl.h"

#import <objc/runtime.h>
#import "SwizzlingDefine.h"

#import "MHChooseUrlController.h"

#import "MHConstSDKConfig.h"

@implementation UITabBarController (MHChooseUrl)
+ (void)load {
    if (MH_BUNDLEID_JFKH) {
        swizzling_exchangeMethod([self class], @selector(viewDidLoad), @selector(mhchooseurl_viewDidLoad));
    }
}

- (void)mhchooseurl_viewDidLoad {
    [self mhchooseurl_viewDidLoad];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(mh_pressenntChoose)];
    [self.tabBar addGestureRecognizer:longPress];
}

- (void)mh_pressenntChoose {
    [(UINavigationController *)self.viewControllers[self.selectedIndex] presentViewController:[MHChooseUrlController new] animated:YES completion:nil];
}
@end

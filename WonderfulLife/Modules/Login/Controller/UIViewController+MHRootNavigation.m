//
//  UIViewController+MHRootNavigation.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+MHRootNavigation.h"
#import "MHTabBarControllerManager.h"

@implementation UIViewController (MHRootNavigation)

//找到以某个控制器为rootController的导航
- (UINavigationController *)navigationWithRootControllerStr:(NSString *)controllerStr{
    MHTabBarControllerManager *tabBar = (MHTabBarControllerManager *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSArray *controllers = tabBar.viewControllers;
    UINavigationController *nav;
    for(UINavigationController *anav in controllers){
        if([[anav.viewControllers firstObject] isKindOfClass:NSClassFromString(controllerStr)]){
            nav = anav;
            break;
        }
    }
    return nav;
}


@end

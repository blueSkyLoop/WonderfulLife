//
//  NSObject+CurrentController.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSObject+CurrentController.h"
#import "AppDelegate.h"
#import "MHTabBarControllerManager.h"
#import "MHNavigationControllerManager.h"

@implementation NSObject (CurrentController)

+ (UIViewController *)mh_findTopestController{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSAssert(window, @"window can not be nil");
    if(window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *rootController = window.rootViewController;
    if(!rootController) return nil;
    return [self getCurrentControllerWithController:rootController];
}

+ (UIViewController *)getCurrentControllerWithController:(UIViewController *)vc{
    if([vc isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *nav= (UINavigationController *)vc;
        if(nav.presentedViewController){
            return [self getCurrentControllerWithController:nav.presentedViewController];
        }
        return nav.visibleViewController;
        
    }else if([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)vc;
        UIViewController *avc = tab.selectedViewController;
        return [self getCurrentControllerWithController:avc];
    }else if(vc.presentedViewController){
        return [self getCurrentControllerWithController:vc.presentedViewController];
    }
    return vc;
}


+ (BOOL)mh_tabbarControllerContainVC:(NSString *)className {
        Class vc = NSClassFromString(className);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate enterMianUI];
    MHTabBarControllerManager *tab = (MHTabBarControllerManager *)[UIApplication sharedApplication].keyWindow.rootViewController;
    for (MHNavigationControllerManager *nav in tab.viewControllers) {
        for (UIViewController *childVC in nav.viewControllers) {
            if ([childVC isKindOfClass:vc]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)mh_containVC:(NSString *)className {
    Class vc = NSClassFromString(className);
    MHTabBarControllerManager *tab = (MHTabBarControllerManager *)[UIApplication sharedApplication].keyWindow.rootViewController;
    for (MHNavigationControllerManager *nav in tab.viewControllers) {
        for (UIViewController *childVC in nav.viewControllers) {
            if ([childVC isKindOfClass:vc]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (void)mh_enterMainUI{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    [appDelegate enterMianUI];
}

@end

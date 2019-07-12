//
//  MHJPushLogicMesList.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHJPushLogicMesList.h"
#import "AppDelegate.h"
#import "MHTabBarControllerManager.h"
#import "MHHomeController.h"
#import "MHNavigationControllerManager.h"
#import "MHHoMsgNotifiTableViewController.h"

#import "MHUserInfoManager.h"
#import "MHConst.h"
#import "NSObject+CurrentController.h"
@implementation MHJPushLogicMesList

+ (void)JPushLogicMesList{

    if ([MHUserInfoManager sharedManager].login) {
        MHTabBarControllerManager *tab = (MHTabBarControllerManager *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [tab setSelectedIndex:0];
        MHNavigationControllerManager *nav = [tab.viewControllers firstObject];
        
        for (UIViewController *vc in nav.viewControllers) {
            if ([vc isKindOfClass:[MHHomeController class]] && nav.viewControllers.count == 1) {
                MHHoMsgNotifiTableViewController *msgVC = [[MHHoMsgNotifiTableViewController alloc] init];
                msgVC.hidesBottomBarWhenPushed = YES;
                [vc.navigationController pushViewController:msgVC animated:NO];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMsgNotifiDataSource object:nil];
            }
        }
    }else {
            [NSObject mh_enterMainUI];
    }
}




@end

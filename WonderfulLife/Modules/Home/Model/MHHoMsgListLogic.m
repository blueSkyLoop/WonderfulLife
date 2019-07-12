//
//  MHHoMsgListLogic.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHoMsgListLogic.h"
#import "MHUserInfoManager.h"
#import "AppDelegate.h"
#import "MHTabBarControllerManager.h"
#import "MHMineRequestHandler.h"

#import "MHNavigationControllerManager.h"
#import "MHMineController.h"
@implementation MHHoMsgListLogic

+ (void)msgListLogicWithValidateWithResult:(BOOL)isSuccess{
    [MHMineRequestHandler uptateProfileCallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
        if (success) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate enterMianUI];
            MHTabBarControllerManager *tab = (MHTabBarControllerManager *)[UIApplication sharedApplication].keyWindow.rootViewController;
            for (MHNavigationControllerManager *nav in tab.viewControllers) {
                if ([[nav.viewControllers firstObject] isKindOfClass:[MHMineController class]]) {
                    [tab setSelectedViewController:nav];
                }
            }
        }
    }];
}

@end

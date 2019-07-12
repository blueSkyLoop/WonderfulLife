//
//  MHTabBarControllerManager+StoreSwitch.m
//  WonderfulLife
//
//  Created by Lol on 2017/12/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "MHTabBarControllerManager+StoreSwitch.h"

#import "MHAreaManager.h"
#import "MHStoreController.h"
#import "NSObject+CurrentController.h"
@implementation MHTabBarControllerManager (StoreSwitch)

#pragma mark - Public
// 主要用于商城入口是否开放 , 并重设 tabbar 的 controllers
- (void)mh_reloadChildControllers {
//    UINavigationController *nav = self.selectedViewController;
//    [nav popToRootViewControllerAnimated:NO];
    
    BOOL m = [NSObject mh_containVC:NSStringFromClass([MHStoreController class])];
    
    if ([MHAreaManager sharedManager].status != 0) { //  根据jpush自定义消息下发处理 tabbar 刷新
         
        NSInteger status = [MHAreaManager sharedManager].status ;
        
        if (status == 1 && !m) {// 需开启商城，且本地没有商城入口时，开启
            [self.mutabControllers insertObject:self.store atIndex:2];
            [MHAreaManager sharedManager].is_enable_mall_merchant = YES ;
            
        }else if (status == 2 && m) { // 需关闭商城，且本地已存在入口 ， 关闭
            [self.mutabControllers removeObject:self.store];
            [MHAreaManager sharedManager].is_enable_mall_merchant = NO ;
        }

        [MHAreaManager sharedManager].status = 0 ;
        [MHAreaManager sharedManager].isJpsuh_Reload = NO ;
        
    }else {  // 此判断场景：登录、注册、完善资料、自动登录、切换城市  5种情况的逻辑
        
        BOOL  hasAreaPermiss = [[MHAreaManager sharedManager] is_enable_mall_merchant] ;
        if (!m && hasAreaPermiss){ // 拥有权限
            [self.mutabControllers insertObject:self.store atIndex:2];
        }else if (m && !hasAreaPermiss) {
            [self.mutabControllers removeObject:self.store];
        }
        
    }
    [self setViewControllers:[self.mutabControllers copy] animated:NO];
}

@end

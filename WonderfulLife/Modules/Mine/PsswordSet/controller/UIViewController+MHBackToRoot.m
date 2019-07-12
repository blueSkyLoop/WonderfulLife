//
//  UIViewController+MHBackToRoot.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+MHBackToRoot.h"
#import "MHNavigationControllerManager.h"
#import "UINavigationController+MHDirectPop.h"

@implementation UIViewController (MHBackToRoot)

- (void)backToHome{
    [self backToRootViewController:0];
}
- (void)backToRootViewController:(NSInteger)index{
    if(index < 0) return;
    if(index >= self.tabBarController.viewControllers.count) return;
    NSInteger currentIndex = self.tabBarController.selectedIndex;
    MHNavigationControllerManager *nav = [self.tabBarController.viewControllers objectAtIndex:index];
    if(currentIndex != index){
        MHNavigationControllerManager *currentNav = [self.tabBarController.viewControllers objectAtIndex:currentIndex];
        [currentNav removeAllDirect];
        [self navPopToRootWithNav:currentNav animated:NO];
        self.tabBarController.selectedIndex = index;
    }
    [nav removeAllDirect];
    if(nav.viewControllers.count > 1){
        [self navPopToRootWithNav:nav animated:YES];
    }
}
- (void)navPopToRootWithNav:(UINavigationController *)nav animated:(BOOL)animated{
    if(nav.viewControllers.count > 1){
        [nav popToRootViewControllerAnimated:animated];
    }
}


@end

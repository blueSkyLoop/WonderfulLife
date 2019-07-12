//
//  UIViewController+PresentLoginController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+PresentLoginController.h"
#import "MHLoginController.h"
#import "MHNavigationControllerManager.h"

@implementation UIViewController (PresentLoginController)

- (void)presentLoginController {
    MHLoginController *vc = [[MHLoginController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    MHNavigationControllerManager *navi = [[MHNavigationControllerManager alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)presentLoginControllerWithJoinVolunteer:(BOOL)flag {
    MHLoginController *vc = [[MHLoginController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.joinVolunteerFlag = flag;
    MHNavigationControllerManager *navi = [[MHNavigationControllerManager alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}
@end

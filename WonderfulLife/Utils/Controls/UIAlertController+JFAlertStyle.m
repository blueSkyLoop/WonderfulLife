//
//  UIAlertController+JFAlertStyle.m
//  JFCommunityCenter
//
//  Created by hanl on 2017/4/8.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import "UIAlertController+JFAlertStyle.h"

@implementation UIAlertController (JFAlertStyle)

+ (void)jf_alertWithTitle:(NSString *)title {
    [self jf_alertWithTitle:title clickBlock:nil];
}

+ (void)jf_alertWithTitle:(NSString *)title
                  message:(NSString *)message {
    UIAlertController * alert = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmBtn];
    UITabBarController *tabBarControler = (id)UIApplication.sharedApplication.delegate.window.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    UIViewController *currentVc = navigationController.viewControllers.lastObject;
    [currentVc presentViewController:alert animated:YES completion:nil];
}

+ (void)jf_alertWithTitle:(NSString *)title
               clickBlock:(void(^)())block {
   UIAlertController * alert = [self alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (block) block();
    }];
    [alert addAction:confirmBtn];
    UITabBarController *tabBarControler = (id)UIApplication.sharedApplication.delegate.window.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    UIViewController *currentVc = navigationController.viewControllers.lastObject;
    [currentVc presentViewController:alert animated:YES completion:nil];
}

+ (void)jf_alertWithTitle:(NSString *)title
           redConfirmText:(NSString *)confirm
               clickBlock:(void(^)()) block {
    UIAlertController * alert = [self alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelBtn];
    UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        if (block) block();
    }];
    [alert addAction:confirmBtn];
    UITabBarController *tabBarControler = (id)UIApplication.sharedApplication.delegate.window.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    UIViewController *currentVc = navigationController.viewControllers.lastObject;
    [currentVc presentViewController:alert animated:YES completion:nil];
}

+ (void)jf_alertWithTitle:(NSString *)title
        normalConfirmText:(NSString *)confirm
               clickBlock:(void(^)()) block {
    UIAlertController * alert = [self alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelBtn];
    UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (block) block();
    }];
    [alert addAction:confirmBtn];
    UITabBarController *tabBarControler = (id)UIApplication.sharedApplication.delegate.window.rootViewController;
    UINavigationController *navigationController = tabBarControler.selectedViewController;
    UIViewController *currentVc = navigationController.viewControllers.lastObject;
    [currentVc presentViewController:alert animated:YES completion:nil];

}

@end

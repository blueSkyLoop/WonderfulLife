//
//  UIAlertController+JFAlertStyle.h
//  JFCommunityCenter
//
//  Created by hanl on 2017/4/8.
//  Copyright © 2017年 com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (JFAlertStyle)

#pragma mark - alert 弹框

+ (void)jf_alertWithTitle:(NSString *)title;

+ (void)jf_alertWithTitle:(NSString *)title
                  message:(NSString *)message;

+ (void)jf_alertWithTitle:(NSString *)title
               clickBlock:(void(^)())block;

+ (void)jf_alertWithTitle:(NSString *)title
           redConfirmText:(NSString *)confirm
               clickBlock:(void(^)()) block;

+ (void)jf_alertWithTitle:(NSString *)title
        normalConfirmText:(NSString *)confirm
               clickBlock:(void(^)()) block;


//#pragma mark - action 弹框
//
//+ (void)jf_actionWithTitle:(NSString *)title;
//
//+ (void)jf_actionWithTitle:(NSString *)title
//                clickBlock:(void(^)())block;
//
//+ (void)jf_actionWithTitle:(NSString *)title
//            redConfirmText:(NSString *)confirm
//                clickBlock:(void(^)()) block;
@end

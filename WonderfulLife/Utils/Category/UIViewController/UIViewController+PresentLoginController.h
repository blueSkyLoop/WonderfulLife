//
//  UIViewController+PresentLoginController.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PresentLoginController)

/** 
 present login controller
 */
- (void)presentLoginController;

- (void)presentLoginControllerWithJoinVolunteer:(BOOL)flag;
@end

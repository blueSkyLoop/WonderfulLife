//
//  NSObject+CurrentController.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (CurrentController)

/** 获取当前界面的控制器*/
+ (UIViewController *)mh_findTopestController ;

/** 判断某个控制器，是否在UITabbarController 内*/
+ (BOOL)mh_tabbarControllerContainVC:(NSString *)className ;


+ (BOOL)mh_containVC:(NSString *)className;

+ (void)mh_enterMainUI ;

@end

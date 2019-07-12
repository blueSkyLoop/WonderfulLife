//
//  UINavigationController+MHDirectPop.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/25.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MHDirectPop)

- (void)saveDirectViewControllerName:(NSString *)className;
- (void)removeDirectViewControllerName:(NSString *)className;
- (void)removeAllDirect;
- (UIViewController *)findDirectViewController;
- (void)directTopControllerPop;
- (BOOL)needCheck;
- (void)checkClassNameExsit:(NSArray *)allClassNames;
- (UIViewController *)findControllerWithControllerName:(NSString *)controllerName;

//找到指定控制器的前一个控制器
- (UIViewController *)frontControllerWithControllerName:(NSString *)controllerName;

@end

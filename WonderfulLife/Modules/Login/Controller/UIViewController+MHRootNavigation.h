//
//  UIViewController+MHRootNavigation.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MHRootNavigation)

//找到以某个控制器为rootController的导航
- (UINavigationController *)navigationWithRootControllerStr:(NSString *)controllerStr;

@end

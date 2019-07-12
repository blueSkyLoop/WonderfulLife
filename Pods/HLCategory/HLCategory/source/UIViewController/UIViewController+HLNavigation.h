//
//  UIViewController+HLNavigation.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HLBackAction)(void);

@interface UIViewController (HLNavigation)

///返回按钮点击事件, 默认pop
@property (copy,nonatomic) HLBackAction _Nullable backAction;

/// 设置导航栏的颜色
- (void)hl_setNavigationItemColor:(nullable UIColor *)color;

/// 设置导航栏分割线的颜色
- (void)hl_setNavigationItemLineColor:(nullable UIColor *)color;

/// 设置返回按钮
- (void)showBackButtonWithimage:(UIImage *_Nullable)image;
- (void)hiddenBackButton;
- (void)cleanSystemBackButton;

/// 给导航栏添加子视图
- (void)hl_addNavigationItemSubView:(nullable UIView *)subView;
@end

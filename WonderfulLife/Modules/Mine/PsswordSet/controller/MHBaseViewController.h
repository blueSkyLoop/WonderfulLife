//
//  MHBaseViewController.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHMacros.h"
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "MHHUDManager.h"

@interface MHBaseViewController : UIViewController


- (void)resetBackNaviItem;

//子类重写此方法
- (void)nav_back;

- (void)mh_setUpUI;

- (void)mh_bindViewModel;

//设置导航底部的线条颜色
- (void)setNaviBottomLineColor:(UIColor *)color;

//设置导航底部的线条颜色,颜色为分割线颜色 
- (void)setNaviBottomLineDefaultColor;

@end

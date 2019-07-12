//
//  UIViewController+NaviBigTitle.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NaviBackBarItemBlock)();
typedef void (^NaviRightBarItemBlock)();
@interface UIViewController (NaviBigTitle)

/**
 *  自定义navi  顶部大标题风格
 *
 *  @parma   title: 标题内容
 *  @parma   rightBarText: 右按钮text    传nil 则不会显示
 *  @parma   backBarItemBlock: 返回回调
 *  @parma   rightBarItemBlock: 右按钮点击回调
 */

- (UIView *)mh_addNaviBigTitleViewWithTitle:(NSString *)title
                        rightBarText:(NSString *)rightBarText
                        BackBarItemBlock:(NaviBackBarItemBlock)backBarItemBlock RightBarItemBlock:(NaviRightBarItemBlock)rightBarItemBlock ;

@end

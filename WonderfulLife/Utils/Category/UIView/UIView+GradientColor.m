//
//  UIView+GradientColor.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIView+GradientColor.h"
/*
 颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
 */
@implementation UIView (GradientColor)

/** 美好志愿主题色 */
- (CAGradientLayer *)mh_gradientSetMainColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer.borderWidth = 0;
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithRed:255.0 / 255.0 green:88.0 / 255.0 blue:110.0 / 255.0 alpha:1].CGColor,
                            (id)[UIColor colorWithRed:255.0 / 255.0 green:126.0 / 255.0 blue:96.0 / 255.0 alpha:1].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0.0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [self.layer insertSublayer:gradientLayer atIndex:0];
    return gradientLayer;
}


@end

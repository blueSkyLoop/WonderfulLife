//
//  UIView+HLCornerRadius.m
//  HLCategory
//
//  Created by hanl on 2017/5/2.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import "UIView+HLCornerRadius.h"

@implementation UIView (HLCornerRadius)

- (void)hl_setCornerRadius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end

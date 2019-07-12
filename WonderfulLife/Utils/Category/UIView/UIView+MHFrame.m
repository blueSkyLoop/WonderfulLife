//
//  UIView+MHFrame.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIView+MHFrame.h"

@implementation UIView (MHFrame)
- (CGFloat)mh_x {
    return self.frame.origin.x;
}

- (void)setMh_x:(CGFloat)mh_x {
    CGRect frame = self.frame;
    frame.origin.x = mh_x;
    self.frame = frame;
}

- (CGFloat)mh_y {
    return self.frame.origin.y;
}

- (void)setMh_y:(CGFloat)mh_y {
    CGRect frame = self.frame;
    frame.origin.y = mh_y;
    self.frame = frame;
}

- (CGFloat)mh_w {
    return self.frame.size.width;
}

- (void)setMh_w:(CGFloat)mh_w {
    CGRect frame = self.frame;
    frame.size.width = mh_w;
    self.frame = frame;
}

- (CGFloat)mh_h {
    return self.frame.size.height;
}

- (void)setMh_h:(CGFloat)mh_h {
    CGRect frame = self.frame;
    frame.size.height = mh_h;
    self.frame = frame;
}

- (CGFloat)mh_centerX {
    return self.center.x;
}

- (void)setMh_centerX:(CGFloat)mh_centerX {
    self.center = CGPointMake(mh_centerX, self.center.y);
}

- (CGFloat)mh_centerY {
    return self.center.y;
}

- (void)setMh_centerY:(CGFloat)mh_centerY {
    self.center = CGPointMake(self.center.x, mh_centerY);
}

- (CGPoint)mh_center {
    return self.center;
}

- (void)setMh_center:(CGPoint)mh_center {
    self.center = mh_center;
}

- (CGPoint)mh_origin {
    return self.frame.origin;
}

- (void)setMh_origin:(CGPoint)mh_origin {
    CGRect frame = self.frame;
    frame.origin = mh_origin;
    self.frame = frame;
}

- (CGSize)mh_size {
    return self.frame.size;
}

- (void)setMh_size:(CGSize)mh_size {
    CGRect frame = self.frame;
    frame.size = mh_size;
    self.frame = frame;
}

- (CGFloat)mh_left {
    return self.frame.origin.x;
}

- (CGFloat)mh_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)mh_top {
    return self.frame.origin.y;
}

- (CGFloat)mh_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMh_bottom:(CGFloat)mh_bottom {
    CGRect frame = self.frame;
    frame.origin.y = mh_bottom - frame.size.height;
    self.frame = frame;
}

- (UIViewController *)mh_viewController{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end

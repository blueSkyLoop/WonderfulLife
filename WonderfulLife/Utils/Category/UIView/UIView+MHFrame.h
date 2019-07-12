//
//  UIView+MHFrame.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MHFrame)
@property (nonatomic) CGFloat mh_x;
@property (nonatomic) CGFloat mh_y;
@property (nonatomic) CGFloat mh_w;
@property (nonatomic) CGFloat mh_h;

@property (nonatomic) CGFloat mh_centerX;
@property (nonatomic) CGFloat mh_centerY;
@property (nonatomic) CGPoint mh_center;

@property (nonatomic) CGPoint mh_origin;
@property (nonatomic) CGSize  mh_size;

@property (nonatomic, readonly) CGFloat mh_left;
@property (nonatomic, readonly) CGFloat mh_right;
@property (nonatomic, readonly) CGFloat mh_top;
@property (nonatomic) CGFloat mh_bottom;


- (UIViewController *)mh_viewController;
@end

//
//  UIButton+MHImageUpTitleDown.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MHImageUpTitleDown)

/** 
 图文上下间隙默认为5*/
- (void)mh_imageUpTitleDown;

/** 
 offset 自定义设置图文间隙
 */
- (void)mh_imageUpTitleDownWithOffset:(CGFloat)offset;


- (void)mh_setLeftTitle:(NSString *)title
             rightImage:(UIImage *)image;
- (void)mh_setLeftTitle:(NSString *)title
             rightImage:(UIImage *)image
               interval:(CGFloat)interval;
- (void)mh_setLeftTitle:(NSString *)title
             rightImage:(UIImage *)image
               forState:(UIControlState)state
               interval:(CGFloat)interval;
@end

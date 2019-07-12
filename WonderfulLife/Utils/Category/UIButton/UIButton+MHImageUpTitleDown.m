//
//  UIButton+MHImageUpTitleDown.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIButton+MHImageUpTitleDown.h"

const static CGFloat kDefaultInterval = 5.0;

@implementation UIButton (MHImageUpTitleDown)

- (void)mh_imageUpTitleDown {
    [self mh_imageUpTitleDownWithOffset:kDefaultInterval];
}

- (void)mh_imageUpTitleDownWithOffset:(CGFloat)offset {
    self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                            -self.imageView.frame.size.width,
                                            -self.imageView.frame.size.height - offset,
                                            0);
    // 由于iOS8中titleLabel的size为0，使用intrinsicContentSize
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - offset,
                                            0,
                                            0,
                                            -self.titleLabel.intrinsicContentSize.width);
}




- (void)mh_setLeftTitle:(NSString *)title
             rightImage:(UIImage *)image {
    [self mh_setLeftTitle:title rightImage:image interval:kDefaultInterval];
}

- (void)mh_setLeftTitle:(NSString *)title
             rightImage:(UIImage *)image
               interval:(CGFloat)interval {
    [self mh_setLeftTitle:title
               rightImage:image
                 forState:UIControlStateNormal
                 interval:interval];
}

- (void)mh_setLeftTitle:(NSString *)title
             rightImage:(UIImage *)image
               forState:(UIControlState)state
               interval:(CGFloat)interval {
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                            -self.imageView.frame.size.width-interval,
                                            0,
                                            self.imageView.frame.size.width+interval);
    self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                            self.titleLabel.frame.size.width+interval,
                                            0,
                                            -self.titleLabel.frame.size.width-interval);
}
@end

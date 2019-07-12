//
//  UIImage+HLColor.h
//  HLCategory
//
//  Created by hanl on 2017/5/3.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HLColor)

/**
 *  get image from color
 *
 *  @parma   color - UIColor
 *
 *  @return  UIImage instancetype 
 */
+ (UIImage *)hl_imageWithUIColor:(UIColor *)color;

@end

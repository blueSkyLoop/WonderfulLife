//
//  UIImage+HLColor.m
//  HLCategory
//
//  Created by hanl on 2017/5/3.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import "UIImage+HLColor.h"

@implementation UIImage (HLColor)

+ (UIImage *)hl_imageWithUIColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

//
//  UIImage+Color.h
//  XXiOSProject
//
//  Created by Beelin on 17/6/23.
//  Copyright © 2017年 xx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIImageGradientDirection) {
   UIImageGradientDirectionRight, //左-->右
    UIImageGradientDirectionDown  //上-->下
};
@interface UIImage (Color)

+ (UIImage *)mh_imageWithColor:(UIColor *)color;
+ (UIImage *)mh_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *   获取渐变的图片
 *
 *  @param bounds bounds
 *  @param colors 数组颜色
 *  @param direction 方向
 *
 *  @return 渐变的图片
 */
+ (UIImage *)mh_gradientImageWithBounds:(CGRect)bounds  direction:(UIImageGradientDirection)direction colors:(NSArray *)colors;

+ (UIImage *)mh_imageGradientSetMineColorWithBounds:(CGRect)bounds;
/**
 *  美好志愿主题色
 *
 *  @param bounds bounds
 *
 *  @return 渐变的图片
 */
+ (UIImage *)mh_imageGradientSetMainColorWithBounds:(CGRect)bounds;
+ (UIImage *)mh_imageGradientSetMainHighlightColorWithBounds:(CGRect)bounds;
@end

//
//  UIImage+Color.m
//  XXiOSProject
//
//  Created by Beelin on 17/6/23.
//  Copyright © 2017年 xx. All rights reserved.
//

#import "UIImage+Color.h"
#import "MHMacros.h"

@implementation UIImage (Color)

+ (UIImage *)mh_imageWithColor:(UIColor *)color {
    return  [self mh_imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)mh_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)mh_imageGradientSetMainColorWithBounds:(CGRect)bounds{
   return [self mh_gradientImageWithBounds:bounds direction:UIImageGradientDirectionRight colors:@[MColorMainGradientStart, MColorMainGradientEnd]];
}

+ (UIImage *)mh_imageGradientSetMainHighlightColorWithBounds:(CGRect)bounds{
    return [self mh_gradientImageWithBounds:bounds direction:UIImageGradientDirectionRight colors:@[MColorMainGradientHighlightStart, MColorMainGradientHighlightEnd]];
}

+ (UIImage *)mh_imageGradientSetMineColorWithBounds:(CGRect)bounds{
    return [self mh_gradientImageWithBounds:bounds direction:UIImageGradientDirectionDown colors:@[MColorMainGradientStart, MColorMainGradientEnd]];
}

+ (UIImage *)mh_gradientImageWithBounds:(CGRect)bounds  direction:(UIImageGradientDirection)direction colors:(NSArray *)colors {
    if (!colors.count) return nil;
    NSMutableArray *crefs = @[].mutableCopy;
    [colors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *c = obj;
        CGColorRef cref = c.CGColor;
        [crefs addObject:(__bridge id _Nonnull)(cref)];
    }];
    
    CALayer * bgGradientLayer = [self mh_gradientBGLayerForBounds:bounds colors:crefs.copy direction:direction];
    UIGraphicsBeginImageContext(bgGradientLayer.bounds.size);
    [bgGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * bgAsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return bgAsImage;
}

+ (CALayer *)mh_gradientBGLayerForBounds:(CGRect)bounds colors:(NSArray *)colors direction:(UIImageGradientDirection)direction
{
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = bounds;
    gradientBG.colors = colors;
    if (direction == UIImageGradientDirectionRight) {
        gradientBG.startPoint = CGPointMake(0.0, 0);
        gradientBG.endPoint = CGPointMake(1, 0);
    } else {
        gradientBG.startPoint = CGPointMake(0.0, 0);
        gradientBG.endPoint = CGPointMake(0.0, 1.0);
    }
    return gradientBG;
}
@end

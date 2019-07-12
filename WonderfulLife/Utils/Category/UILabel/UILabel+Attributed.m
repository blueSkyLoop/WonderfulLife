//
//  UILabel+Attributed.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UILabel+Attributed.h"

@implementation UILabel (Attributed)


- (void)mh_setAttributedWithRange:(NSRange)range attributeName:(NSString *)attributeName font:(UIFont *)font{
    //富文本对象
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    //富文本样式  NSFontAttributeName
    [aAttributedString addAttribute:attributeName             //文字字体
                              value:font
                              range:range];
    self.attributedText = aAttributedString;
}


@end

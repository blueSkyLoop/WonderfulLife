//
//  NSMutableAttributedString+MHColor.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSMutableAttributedString+MHColor.h"
#import <UIKit/UIKit.h>

@implementation NSMutableAttributedString (MHColor)
- (void)mh_attributedStringWithColorArray:(NSArray<UIColor *> *)colors ranges:(NSArray <NSValue*>*)ranges {
    for (int i = 0; i < colors.count; i ++) {
        NSValue *r = ranges[i];
        NSRange range = r.rangeValue;
        [self addAttribute:NSForegroundColorAttributeName value:colors[i] range:range];
    }
}
@end

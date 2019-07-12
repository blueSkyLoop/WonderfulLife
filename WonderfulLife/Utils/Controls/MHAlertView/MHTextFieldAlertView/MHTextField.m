//
//  MHTextField.m
//  01-封装提示框
//
//  Created by hehuafeng on 2017/7/21.
//  Copyright © 2017年 Lo. All rights reserved.
//

#import "MHTextField.h"

#define MColorToRGB(value) MColorToRGBWithAlpha(value, 1.0f)
#define MColorToRGBWithAlpha(value, alpha1) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:alpha1]//十六进制转RGB色

@implementation MHTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置属性
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = MColorToRGB(0XC0CCDA).CGColor;
    [self setValue:MColorToRGB(0XC0CCDA) forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont systemFontOfSize:17.0]  forKeyPath:@"_placeholderLabel.font"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置属性
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = MColorToRGB(0XC0CCDA).CGColor;
        [self setValue:MColorToRGB(0XC0CCDA) forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont systemFontOfSize:17.0]  forKeyPath:@"_placeholderLabel.font"];
    }
    return self;
}

/**
 调整文字位置
 */
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x = 11;
    return rect;
}

/**
 调整编辑时文字位置
 */
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x = 11;
    return rect;
}

/**
 文本框成为第一响应者
 */
- (BOOL)becomeFirstResponder {
    self.layer.borderColor = MColorToRGB(0X99A9BF).CGColor;
    return [super becomeFirstResponder];
}

@end
